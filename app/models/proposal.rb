#encoding: utf-8
class Proposal < ActiveRecord::Base
  include BlogKitModelHelper

  belongs_to :state, :class_name => 'ProposalState', :foreign_key => :proposal_state_id
  belongs_to :category, :class_name => 'ProposalCategory', :foreign_key => :proposal_category_id
  belongs_to :vote_period, :class_name => 'Event', :foreign_key => :vote_period_id
  has_many :proposal_presentations, :class_name => 'ProposalPresentation', :order => 'id DESC', :dependent => :destroy
  has_many :proposal_borders, :class_name => 'ProposalBorder', :dependent => :destroy
  has_many :proposal_histories, :class_name => 'ProposalHistory'

  has_many :revisions, class_name: 'ProposalRevision'


  #  has_many :proposal_watches, :class_name => 'ProposalWatch'
  has_one :vote, :class_name => 'ProposalVote'
  has_many :user_votes, :class_name => 'UserVote'
  # all the comments related to the proposal
  has_many :comments, :class_name => 'ProposalComment', :dependent => :destroy
  # only the main contributes related to the proposal
  has_many :contributes, :class_name => 'ProposalComment', :dependent => :destroy, :conditions => ['parent_proposal_comment_id is null']
  has_many :rankings, :class_name => 'ProposalRanking', :dependent => :destroy
  has_many :positive_rankings, :class_name => 'ProposalRanking', :conditions => ['ranking_type_id = 1']

  has_many :users, :through => :proposal_presentations, :class_name => 'User'

  has_many :proposal_supports, :class_name => 'ProposalSupport', :dependent => :destroy
  has_many :groups, :through => :proposal_supports, :class_name => 'Group'
  #confini di interesse
  has_many :interest_borders, :through => :proposal_borders, :class_name => 'InterestBorder'

  has_many :proposal_tags, :class_name => 'ProposalTag', :dependent => :destroy
  has_many :tags, :through => :proposal_tags, :class_name => 'Tag'

  has_many :proposal_nicknames, :class_name => 'ProposalNickname', :dependent => :destroy

  has_many :group_proposals, :class_name => 'GroupProposal', :dependent => :destroy
  has_many :presentation_groups, :through => :group_proposals, :class_name => 'Group', :source => :group

  has_many :area_proposals, :class_name => 'AreaProposal', :dependent => :destroy
  has_many :presentation_areas, :through => :area_proposals, :class_name => 'GroupArea', :source => :group_area

  has_many :available_authors, :class_name => 'AvailableAuthor', :dependent => :destroy
  has_many :available_user_authors, :through => :available_authors, :class_name => 'User', :source => :user

  belongs_to :quorum, :class_name => 'Quorum'

  has_many :proposal_sections, :dependent => :destroy
  has_many :sections, :through => :proposal_sections, :order => :seq

  has_many :solutions, :order => :seq, :dependent => :destroy

  belongs_to :proposal_votation_type, :class_name => 'ProposalVotationType'

  belongs_to :proposal_type, :class_name => 'ProposalType'

  #validation
  validates_presence_of :title, :message => "Il titolo della proposta è obbligatorio"
  validates_uniqueness_of :title

  validates_presence_of :quorum_id#, :if => :is_standard? #todo bug in client_side_validation

  attr_accessor :update_user_id, :group_area_id, :objectives_dirty, :problems_dirty, :content_dirty, :percentage

  attr_accessible :proposal_category_id, :content, :title, :interest_borders_tkn, :subtitle, :objectives, :problems, :tags_list,
                  :presentation_group_ids, :private, :anonima, :quorum_id, :visible_outside, :secret_vote, :vote_period_id,
                  :group_area_id, :objectives_dirty, :problems_dirty, :content_dirty,
                  :sections_attributes, :solutions_attributes, :proposal_type_id, :proposal_votation_type_id

  accepts_nested_attributes_for :sections
  accepts_nested_attributes_for :solutions, allow_destroy: true

  #tutte le proposte 'attive'. sono attive le proposte dalla  fase di valutazione fino a quando non vengono accettate o respinte
  scope :current, {:conditions => {:proposal_state_id => [PROP_VALUT, PROP_WAIT_DATE, PROP_WAIT, PROP_VOTING]}}
  #tutte le proposte in valutazione
  scope :in_valutation, {:conditions => {:proposal_state_id => PROP_VALUT}}
  #tutte le proposte in attesa di votazione o attualmente in votazione
  scope :in_votation, {:conditions => {:proposal_state_id => [PROP_WAIT_DATE, PROP_WAIT, PROP_VOTING]}}
  #tutte le proposte accettate
  scope :accepted, {:conditions => {:proposal_state_id => PROP_ACCEPT}}
  #tutte le proposte respinte
  scope :rejected, {:conditions => {:proposal_state_id => PROP_RESP}}

  scope :voted, {:conditions => {:proposal_state_id => [ProposalState::ACCEPTED, ProposalState::REJECTED]}}

  #tutte le proposte entrate in fase di revisione e feedback
  scope :revision, {:conditions => {:proposal_state_id => PROP_REVISION}}

  scope :public, {:conditions => {:private => false}}
  scope :private, {:conditions => {:private => true}}

  #condizione di appartenenza ad una categoria
  scope :in_category, lambda { |category_id| {:conditions => ['proposal_category_id = ?', category_id]} if (category_id && !category_id.empty?) }

  #condizione di visualizzazione in un gruppo
  scope :in_group, lambda { |group_id| {:include => [:proposal_supports, :group_proposals], :conditions => ["((proposal_supports.group_id = ? and proposals.private = 'f') or (group_proposals.group_id = ? and proposals.private = 't'))", group_id, group_id]} if group_id }

  #condizione di visualizzazione in area di lavoro
  scope :in_group_area, lambda { |group_area_id| {:include => [:area_proposals], :conditions => ["((area_proposals.group_area_id = ? and proposals.private = 't'))",group_area_id]} if group_area_id}


  before_update :save_proposal_history
  before_save :save_tags
  after_destroy :remove_scheduled_tasks
  after_find :calculate_percentage


  def is_standard?
    self.proposal_type_id.to_s == ProposalType::STANDARD.to_s
  end

  def is_polling?
    self.proposal_type_id.to_s == ProposalType::POLL.to_s
  end


  def remove_scheduled_tasks
    Resque.remove_delayed(ProposalsWorker, {:action => ProposalsWorker::ENDTIME, :proposal_id => self.id})
  end

  #return true if the proposal is currently in debate
  def in_valutation?
    self.proposal_state_id == ProposalState::VALUTATION
  end

  def waiting_date?
    self.proposal_state_id == ProposalState::WAIT_DATE
  end

  def waiting?
    self.proposal_state_id == ProposalState::WAIT
  end

  def voting?
    self.proposal_state_id == ProposalState::VOTING
  end

  def voted?
    [ProposalState::ACCEPTED, ProposalState::REJECTED].include? self.proposal_state_id
  end

  def is_current?
    [PROP_VALUT, PROP_WAIT_DATE, PROP_WAIT, PROP_VOTING].include? self.proposal_state_id
  end

  #restituisce 'true' se la proposta è attualmente anonima, ovvero è stata definita come tale ed è in dibattito
  def is_anonima?
    is_current? && self.anonima
  end

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
    self.tags.collect { |t| "<a href=\"/tag/#{t.text.strip}\">#{t.text.strip}</a>" }.join(', ')
  end

  def save_tags
    if @tags_list
      # Remove old tags
      #self.proposal_tags.destroy_all

      # Save new tags
      tids = []
      @tags_list.split(/,/).each do |tag|
        stripped = tag.strip.downcase.gsub('.', '').gsub("'", "")
        unless stripped.blank?
          t = Tag.find_or_create_by_text(stripped)
          tids << t.id
        end
        #if (!self.tags.include? t)
        #  self.tags << t
        #end
      end
      self.tag_ids = tids
    end

    self.content = truncate_words(self.solutions.first.sections.first.paragraphs.first.content.gsub( %r{</?[^>]+?>}, '' ), 60)
  end

  def to_param
    "#{id}-#{title.downcase.gsub(/[^a-zA-Z0-9]+/, '-').gsub(/-{2,}/, '-').gsub(/^-|-$/, '')}"
  end

  #prima di aggiornare la proposta salvane la
  #storia nella tabella dedicata (se è cambiato il testo)
  def save_proposal_history
    something = false
    seq = (self.revisions.maximum(:seq) || 0) + 1
    revision = self.revisions.build(user_id: self.update_user_id, valutations: self.valutations_was, rank: self.rank_was, seq: seq)
    self.sections.each do |section|
      paragraph = section.paragraphs.first
      if paragraph.content_changed?
        something = true
        section_history = revision.section_histories.build(section_id: section.id, title: section.title, seq: section.seq)
        section_history.paragraphs.build(content: paragraph.content_dirty, seq: 1)
      end
    end
    self.solutions.each do |solution|
      solution_history = revision.solution_histories.build(seq: solution.seq)
      something_solution = false
      solution.sections.each do |section|
        paragraph = section.paragraphs.first
        if paragraph.content_changed?
          something = true
          something_solution = true
          section_history = solution_history.section_histories.build(section_id: section.id, title: section.title, seq: section.seq)
          section_history.paragraphs.build(content: paragraph.content_dirty, seq: 1)
        end
      end
      solution_history.destroy unless something_solution
    end
    something ? revision.save! : revision.destroy
  end

  #restituisce il primo autore della proposta
  def user
    @first_user ||= self.proposal_presentations.first.user
    #@first_user ||= self.proposals_presentations. 
    return @first_user
  end

  def short_content
    truncate_words(self.content.gsub(%r{</?[^>]+?>}, ''), 60)
  end

  def interest_borders_tkn

  end

  def interest_borders_tkn=(list)

  end

  def partecipants
    a = User.all(:joins => {:proposal_rankings => [:proposal]}, :conditions => ["proposals.id = ?", self.id])
    b = User.all(:joins => {:proposal_comments => [:proposal]}, :conditions => ["proposals.id = ?", self.id])
    c = (a | b)
    return c
  end

  #restituisce la lista delle 10 proposte più vicine a questa
  def closest(group_id=nil)
    sql_q = " SELECT p.id, p.proposal_state_id, p.proposal_category_id, p.title, p.content,
              p.created_at, p.updated_at, p.valutations, p.vote_period_id, p.proposal_comments_count,
              p.rank, p.problem, p.subtitle, p.problems, p.objectives, p.show_comment_authors, COUNT(*) AS closeness
              FROM proposal_tags pt join proposals p on pt.proposal_id = p.id "

    sql_q += " left join group_proposals gp on gp.proposal_id = p.id " if group_id
    sql_q += " WHERE pt.tag_id IN (SELECT pti.tag_id
                                  FROM proposal_tags pti
                                  WHERE pti.proposal_id = #{self.id})
              AND pt.proposal_id != #{self.id} "
    sql_q += " AND (p.private = false OR p.visible_outside = true "
    sql_q += group_id ? " OR (p.private = true AND gp.group_id = #{group_id}))" : ")"
    sql_q += " GROUP BY p.id, p.proposal_state_id, p.proposal_category_id, p.title, p.content,
               p.created_at, p.updated_at, p.valutations, p.vote_period_id, p.proposal_comments_count,
               p.rank, p.problem, p.subtitle, p.problems, p.objectives, p.show_comment_authors
               ORDER BY closeness DESC"
    Proposal.find_by_sql(sql_q)
  end


  searchable do
    text :title, boost: 5
    text :content, boost: 2
    text :paragraphs do
      (sections.map { |section| section.paragraphs.map { |paragraph| paragraph.content } } +
          solutions.map { |solution| solution.sections.map { |section| section.paragraphs.map { |paragraph| paragraph.content } } }).flatten
    end
    integer :presentation_group_ids, multiple: true
    integer :group_ids, multiple: true
  end

  #restituisce la percentuale di avanzamento della proposta in abse al quorum assegnato
  def calculate_percentage
    return unless self.quorum
    percentages = []
    if self.quorum.valutations
      minimum = [self.valutations, self.quorum.valutations].min
      percentagevals = minimum.to_f/self.quorum.valutations.to_f
      percentagevals *= 100
      percentages << percentagevals
    end
    if self.quorum.minutes
      minimum = [Time.now, self.quorum.ends_at].min
      minimum = ((minimum - self.quorum.started_at)/60)
      percentagetime = minimum.to_f/self.quorum.minutes.to_f
      percentagetime *= 100
      percentages << percentagetime
    end

    if self.quorum.or?
      @percentage=percentages.max
    else
      @percentage=percentages.min
    end
  end


  def users_j
    self.is_anonima? ?
    self.proposal_nicknames.where(:user_id => self.user_ids).as_json(only: [:nickname]) :
    self.users.as_json(:only => [:id], :methods => [:fullname])
  end
end
