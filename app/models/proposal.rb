#encoding: utf-8
class Proposal < ActiveRecord::Base
  include BlogKitModelHelper
    
  belongs_to :state, :class_name => 'ProposalState', :foreign_key => :proposal_state_id
  belongs_to :category, :class_name => 'ProposalCategory', :foreign_key => :proposal_category_id
  belongs_to :vote_period, :class_name => 'Event', :foreign_key => :vote_period_id
  has_many :proposal_presentations, :class_name => 'ProposalPresentation', :order => 'id DESC'
  has_many :proposal_borders, :class_name => 'ProposalBorder'
  has_many :proposal_histories, :class_name => 'ProposalHistory'
  #  has_many :proposal_watches, :class_name => 'ProposalWatch'
  has_one :vote, :class_name => 'ProposalVote'
  has_many :user_votes, :class_name => 'UserVote'
  has_many :comments, :class_name => 'ProposalComment', :dependent => :destroy
  has_many :rankings, :class_name => 'ProposalRanking', :dependent => :destroy
  has_many :positive_rankings, :class_name => 'ProposalRanking', :conditions => ['ranking_type_id = 1']

  has_many :users, :through => :proposal_presentations, :class_name => 'User'
  
  has_many :proposal_supports, :class_name => 'ProposalSupport', :dependent => :destroy
  has_many :groups, :through => :proposal_supports, :class_name => 'Group'
  #confini di interesse
  has_many :interest_borders,:through => :proposal_borders, :class_name => 'InterestBorder'  
  
  has_many :proposal_tags, :class_name => 'ProposalTag'
  has_many :tags, :through => :proposal_tags, :class_name => 'Tag'
  
  
  
  #validation
  validates_presence_of :title, :message => "Il titolo della proposta è obbligatorio" 
  validates_uniqueness_of :title 
  
  validates_presence_of :objectives,:problems
  
  attr_accessor :update_user_id
  
  attr_accessible :proposal_category_id, :content, :title, :interest_borders_tkn, :subtitle, :objectives, :problems, :tags_list
  
  #tutte le proposte 'attive'. sono attive le proposte dalla  fase di valutazione fino a quando non vengono accettate o respinte
  scope :current, { :conditions => {:proposal_state_id => [PROP_VALUT,PROP_WAIT_DATE,PROP_WAIT,PROP_VOTING] }}
  #tutte le proposte in valutazione
  scope :in_valutation, { :conditions => {:proposal_state_id => PROP_VALUT }}
  #tutte le proposte in attesa di votazione o attualmente in votazione
  scope :in_votation, { :conditions => {:proposal_state_id => [PROP_WAIT_DATE,PROP_WAIT,PROP_VOTING] }}
  #tutte le proposte accettate
  scope :accepted, { :conditions => {:proposal_state_id => PROP_ACCEPT }}
  #tutte le proposte respinte
  scope :rejected, { :conditions => {:proposal_state_id => PROP_RESP }}
  
  #tutte le proposte entrate in fase di revisione e feedback
  scope :revision, { :conditions => {:proposal_state_id => PROP_REVISION }}
  
  
  before_save :save_tags
  after_update :save_proposal_history
 
 
  def tags_list
    @tags_list ||= self.tags.map(&:text).join(', ')
  end
  
  def tags_list_json
    @tags_list ||= self.tags.map(&:text).join(', ')
  end
  
  def tags_list=(tags_list)
    @tags_list = tags_list
  end

  def tags_with_links
    html = self.tags.collect {|t| "<a href=\"/tag/#{t.text.strip}\">#{t.text.strip}</a>" }.join(', ')
    return html
  end
  
  def save_tags
    if @tags_list
      # Remove old tags
      #self.proposal_tags.destroy_all
    
      # Save new tags
      tids = []
      @tags_list.split(/,/).each do |tag|
        stripped = tag.strip.downcase.gsub('.','')
        t = Tag.find_or_create_by_text(stripped)
        tids << t.id
        #if (!self.tags.include? t)
        #  self.tags << t
        #end
      end
      self.tag_ids = tids
    end
  end 
  
 
 #prima di aggiornare la proposta salvane la 
 #storia nella tabella dedicata (se è cambiato il testo)
 def save_proposal_history
   if self.content_changed? || self.problem_changed?
     puts "Updated!"
     history = ProposalHistory.new
     history.proposal_id = self.id
     history.user_id = self.update_user_id
     history.content = self.content_was
     history.problem = self.problem_was
     history.valutations = self.valutations_was
     history.rank = self.rank_was
     history.save
   end
 end
  
  #restituisce il primo autore della proposta
  def user
    @first_user ||= self.proposal_presentations.first.user
    #@first_user ||= self.proposals_presentations. 
    return @first_user
  end
    
  def short_content
    return truncate_words(self.content,60)
  end
  
  def interest_borders_tkn
    
  end
  
  def interest_borders_tkn=(list)
    
  end

  def partecipants
    return User.all(:joins => {:proposal_rankings =>[:proposal]}, :conditions => ["proposals.id = ?", self.id])
  end
  
  #restituisce la lista delle 10 proposte più vicine a questa
  def closest
    return Proposal.find_by_sql(" 
    SELECT p.id, p.proposal_state_id, p.proposal_category_id, p.title, p.content, 
p.created_at, p.updated_at, p.valutations, p.vote_period_id, p.proposal_comments_count, 
p.rank, p.problem, p.subtitle, p.problems, p.objectives, p.show_comment_authors, COUNT(*) AS closeness
                    FROM proposal_tags pt join proposals p on pt.proposal_id = p.id  
                    WHERE pt.tag_id IN (SELECT pti.tag_id
                            FROM proposal_tags pti 
                            WHERE pti.proposal_id = #{self.id})
                    AND pt.proposal_id != #{self.id}
                    GROUP BY p.id, p.proposal_state_id, p.proposal_category_id, p.title, p.content, 
p.created_at, p.updated_at, p.valutations, p.vote_period_id, p.proposal_comments_count, 
p.rank, p.problem, p.subtitle, p.problems, p.objectives, p.show_comment_authors
                    ORDER BY closeness DESC")    
  end 
end
