#encoding: utf-8
class Proposal < ActiveRecord::Base
  include BlogKitModelHelper

  belongs_to :state, :class_name => 'ProposalState', :foreign_key => :proposal_state_id
  belongs_to :category, :class_name => 'ProposalCategory', :foreign_key => :proposal_category_id
  belongs_to :vote_period, :class_name => 'Event', :foreign_key => :vote_period_id
  has_many :proposal_presentations, :class_name => 'ProposalPresentation', order: 'id DESC', dependent: :destroy

  has_many :proposal_borders, :class_name => 'ProposalBorder', dependent: :destroy
  has_many :proposal_histories, :class_name => 'ProposalHistory'

  has_many :revisions, class_name: 'ProposalRevision', dependent: :destroy

  #  has_many :proposal_watches, :class_name => 'ProposalWatch'
  has_one :vote, :class_name => 'ProposalVote', dependent: :destroy

  has_many :user_votes, :class_name => 'UserVote'

  has_many :schulze_votes, :class_name => 'ProposalSchulzeVote', dependent: :destroy

  # all the comments related to the proposal
  has_many :comments, :class_name => 'ProposalComment', :dependent => :destroy
  # only the main contributes related to the proposal
  has_many :contributes, :class_name => 'ProposalComment', :dependent => :destroy, :conditions => ['parent_proposal_comment_id is null']
  has_many :rankings, :class_name => 'ProposalRanking', :dependent => :destroy
  has_many :positive_rankings, :class_name => 'ProposalRanking', :conditions => ['ranking_type_id = 1']

  has_many :proposal_lives, :class_name => 'ProposalLife', order: 'proposal_lives.created_at DESC', :dependent => :destroy
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

  #eager_load :quorum

  has_many :proposal_sections, :dependent => :destroy
  has_many :sections, :through => :proposal_sections, :order => :seq

  has_many :solutions, :order => 'solutions.seq', :dependent => :destroy

  belongs_to :proposal_votation_type, :class_name => 'ProposalVotationType'

  belongs_to :proposal_type, :class_name => 'ProposalType'

  #forum
  has_many :topic_proposals, class_name: 'Frm::TopicProposal', foreign_key: 'proposal_id'
  has_many :topics, class_name: 'Frm::Topic', through: :topic_proposals

  has_many :proposal_alerts, :class_name => 'ProposalAlert', dependent: :destroy
  has_many :blocked_proposal_alerts, :class_name => 'BlockedProposalAlert', dependent: :destroy

  #validation
  validates_presence_of :title, :message => "obbligatorio" #TODO:I18n
  validates_uniqueness_of :title
  validates_presence_of :proposal_category_id, :message => "obbligatorio"

  validates_presence_of :quorum_id #, :if => :is_standard? #todo bug in client_side_validation

  validates_with AtLeastOneValidator, associations: [:solutions]

  attr_accessor :update_user_id, :group_area_id, :percentage, :integrated_contributes_ids, :integrated_contributes_ids_list, :last_revision, :topic_id, :votation, :signatures, :petition_phase

  attr_accessible :proposal_category_id, :content, :title, :interest_borders_tkn, :subtitle, :objectives, :problems, :tags_list,
                  :presentation_group_ids, :private, :anonima, :quorum_id, :visible_outside, :secret_vote, :vote_period_id,
                  :group_area_id, :topic_id,
                  :sections_attributes, :solutions_attributes, :proposal_type_id, :proposal_votation_type_id, :integrated_contributes_ids_list, :votation

  accepts_nested_attributes_for :sections, allow_destroy: true
  accepts_nested_attributes_for :solutions, allow_destroy: true

  #tutte le proposte 'attive'. sono attive le proposte dalla  fase di valutazione fino a quando non vengono accettate o respinte
  scope :current, {:conditions => {:proposal_state_id => [PROP_VALUT, PROP_WAIT_DATE, PROP_WAIT, PROP_VOTING]}}
  #tutte le proposte in valutazione
  scope :in_valutation, {:conditions => {:proposal_state_id => PROP_VALUT}}
  #tutte le proposte in attesa di votazione o attualmente in votazione

  #scope :waiting, {:conditions => {:proposal_state_id => [ProposalState::WAIT_DATE, ProposalState::WAIT]}}

  scope :before_votation, {:conditions => {:proposal_state_id => [PROP_VALUT, PROP_WAIT_DATE, PROP_WAIT]}}

  scope :in_votation, {:conditions => {:proposal_state_id => [ProposalState::WAIT_DATE, ProposalState::WAIT, PROP_VOTING]}}

  scope :voting, {:conditions => {:proposal_state_id => ProposalState::VOTING}}

  scope :not_voted_by, lambda { |user_id| {:conditions => ['proposal_state_id = ? and proposals.id not in (select proposal_id from user_votes where user_id = ?)', ProposalState::VOTING, user_id]} }

  #tutte le proposte accettate
  scope :accepted, {:conditions => {:proposal_state_id => ProposalState::ACCEPTED}}
  #tutte le proposte respinte
  scope :rejected, {:conditions => {:proposal_state_id => ProposalState::REJECTED}}
  #tutte le proposte respinte
  scope :abandoned, {:conditions => {:proposal_state_id => ProposalState::ABANDONED}}

  scope :voted, {:conditions => {:proposal_state_id => [ProposalState::ACCEPTED, ProposalState::REJECTED]}}

  #tutte le proposte entrate in fase di revisione e feedback
  scope :revision, {:conditions => {:proposal_state_id => ProposalState::ABANDONED}}

  scope :public, {:conditions => {:private => false}}
  scope :private, {:conditions => {:private => true}} #proposte interne ai gruppi

  #condizione di appartenenza ad una categoria
  scope :in_category, lambda { |category_id| {:conditions => ['proposal_category_id = ?', category_id]} if (category_id && !category_id.empty?) }

  #condizione di visualizzazione in un gruppo
  scope :in_group, lambda { |group_id| {:include => [:proposal_supports, :group_proposals], :conditions => ["((proposal_supports.group_id = ? and proposals.private = 'f') or (group_proposals.group_id = ? and proposals.private = 't'))", group_id, group_id]} if group_id }

  #condizione di visualizzazione in area di lavoro
  scope :in_group_area, lambda { |group_area_id| {:include => [:area_proposals], :conditions => ["((area_proposals.group_area_id = ? and proposals.private = 't'))", group_area_id]} if group_area_id }


  before_update :save_proposal_history
  after_update :mark_integrated_contributes
  before_save :save_tags
  after_destroy :remove_scheduled_tasks
  before_create :populate_fake_url


  #retrieve the list of propsoals for the user with a count of the number of the notifications for each proposal
  def self.home_portlet(user)
    @list_a = user.proposals.before_votation.pluck('proposals.id')
    @list_b = user.partecipating_proposals.before_votation.pluck('proposals.id')
    @list_c = @list_a | @list_b
    if @list_c.empty?
      return []
    else
      return self.current
      .select('distinct proposals.*, proposal_alerts.count as alerts_count, proposal_rankings.ranking_type_id as ranking')
      .includes([:quorum, {:users => :image}, :proposal_type, :groups, :presentation_groups, :category])
      .joins("left outer join proposal_alerts on proposals.id = proposal_alerts.proposal_id and proposal_alerts.user_id = #{user.id}").where(['proposals.id in (?) ', @list_c])
      .joins("left outer join proposal_rankings on proposals.id = proposal_rankings.proposal_id and proposal_rankings.user_id = #{user.id}")
      .order('proposals.updated_at desc')
    end
  end

  def self.votation_portlet(user)
    proposals = Proposal.find_by_sql("select distinct p.*, pa.count as alerts_count, pk.ranking_type_id as ranking, e.endtime as end_time
                          from proposals p
                          join group_proposals gp on p.id = gp.proposal_id
                          join groups g on g.id = gp.group_id
                          join group_partecipations gi on (g.id = gi.group_id and gi.user_id = #{user.id})
                          join partecipation_roles pr on (gi.partecipation_role_id = pr.id)
                          join events e on e.id = p.vote_period_id
                          left join action_abilitations aa on (aa.partecipation_role_id = pr.id)
                          left join user_votes uv on (uv.proposal_id = p.id and uv.user_id = #{user.id})
                          left join proposal_alerts pa on p.id = pa.proposal_id and pa.user_id = #{user.id}
                          left join proposal_rankings pk on p.id = pk.proposal_id and pk.user_id = #{user.id}
                          where  p.proposal_state_id = #{ProposalState::VOTING}
                          and uv.id is null
                          and (aa.group_action_id = #{GroupAction::PROPOSAL_VOTE} or pr.id = #{PartecipationRole::PORTAVOCE})
                          order by e.endtime asc")
    ActiveRecord::Associations::Preloader.new(proposals,[:quorum, {:users => :image}, :proposal_type, :groups, :presentation_groups, :category]).run
    proposals
  end

  #retrieve the list of proposals for the group with a count of the number of the notifications for each proposal
  def self.group_portlet(group,user)
    query = group.internal_proposals.includes([:quorum, {:users => :image}, :proposal_type, :groups, :presentation_groups, :category]).order('created_at desc').limit(10)
    if user
    query = query.select('distinct proposals.*, proposal_alerts.count as alerts_count, proposal_rankings.ranking_type_id as ranking')
    .joins(" left outer join proposal_alerts on proposals.id = proposal_alerts.proposal_id and proposal_alerts.user_id = #{user.id}")
    .joins("left outer join proposal_rankings on proposals.id = proposal_rankings.proposal_id and proposal_rankings.user_id = #{user.id}")
  end
end


def count_notifications(user_id)
  (alerts = self.proposal_alerts.where(:user_id => user_id).first) ? alerts.count : 0

end

def populate_fake_url
  self.url = ''
end

#after_find :calculate_percentage

def integrated_contributes_ids_list=(value)
  self.integrated_contributes_ids = value.split(/,\s*/)
end

def is_schulze?
  self.solutions.count > 1
end

def is_standard?
  self.proposal_type.name == ProposalType::STANDARD
end

def is_polling?
  self.proposal_type.name == ProposalType::POLL
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

def abandoned?
  self.proposal_state_id == ProposalState::ABANDONED
end

def voted?
  [ProposalState::ACCEPTED, ProposalState::REJECTED].include? self.proposal_state_id
end

def rejected?
  self.proposal_state_id == ProposalState::REJECTED
end

def is_current?
  [PROP_VALUT, PROP_WAIT_DATE, PROP_WAIT, PROP_VOTING].include? self.proposal_state_id
end

#restituisce 'true' se la proposta è attualmente anonima, ovvero è stata definita come tale ed è in dibattito
def is_anonima?
  is_current? && self.anonima
end

#return true if the proposal is in a group
def in_group?
  self.private?
end

def in_group_area?
  self.in_group? && !self.presentation_areas.first.nil?
end

def is_petition?
  self.proposal_type_id == 11
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

  first_solution = self.solutions.first
  first_section =
      if first_solution && first_solution.sections.first
        first_solution.sections.first
      else
        self.sections.first
      end
  self.content = truncate_words(first_section.paragraphs.first.content.gsub(%r{</?[^>]+?>}, ''), 60)


end

def to_param
  "#{id}-#{title.downcase.gsub(/[^a-zA-Z0-9]+/, '-').gsub(/-{2,}/, '-').gsub(/^-|-$/, '')}"
end

#prima di aggiornare la proposta salvane la
#storia nella tabella dedicata (se è cambiato il testo)
def save_proposal_history
  something = false
  seq = (self.revisions.maximum(:seq) || 0) + 1
  @revision = self.revisions.build(user_id: self.update_user_id, valutations: self.valutations_was, rank: self.rank_was, seq: seq)
  self.sections.each do |section|
    paragraph = section.paragraphs.first
    paragraph.content = '' if (paragraph.content == '<p></p>' && paragraph.content_was == '')
    if paragraph.content_changed? || section.marked_for_destruction?
      something = true
      section_history = @revision.section_histories.build(section_id: section.id, title: section.title, seq: section.seq, added: section.new_record?, removed: section.marked_for_destruction?)
      section_history.paragraphs.build(content: paragraph.content_dirty, seq: 1, proposal_id: self.id)
    end
  end
  self.solutions.each do |solution|

    solution_history = @revision.solution_histories.build(seq: solution.seq, title: solution.title, added: solution.new_record?, removed: solution.marked_for_destruction?)
    something_solution = solution.title_changed? || solution.marked_for_destruction?
        solution.sections.each do |section|
      paragraph = section.paragraphs.first
      paragraph.content = '' if (paragraph.content == '<p></p>' && paragraph.content_was == '')
      if paragraph.content_changed? || section.marked_for_destruction? || solution.marked_for_destruction?
        something = true
        something_solution = true
        section_history = solution_history.section_histories.build(section_id: section.id, title: section.title, seq: section.seq, added: section.new_record?, removed: (section.marked_for_destruction? || solution.marked_for_destruction?))
        section_history.paragraphs.build(content: paragraph.content_dirty, seq: 1, proposal_id: self.id)
      end
    end
    solution_history.destroy unless something_solution
    something = true if something_solution
  end
  something ? @revision.save! : @revision.destroy
  self.touch
end

def mark_integrated_contributes
  if @revision.id
    self.last_revision = @revision
    comment_ids = ProposalComment.where({:id => integrated_contributes_ids, :parent_proposal_comment_id => nil}).pluck(:id) #controllo di sicurezza
    ProposalComment.update_all({:integrated => true}, {:id => comment_ids})
    comment_ids.each do |id|
      self.last_revision.integrated_contributes.create(:proposal_comment_id => id)
    end
  end
end

#restituisce il primo autore della proposta
def user
  @first_user ||= self.proposal_presentations.first.user
  #@first_user ||= self.proposals_presentations.
  return @first_user
end

def short_content
  truncate_words(self.content.gsub(%r{</?[^>]+?>}, ''), 35)
end

def interest_borders_tkn

end

def interest_borders_tkn=(list)

end


#retrieve the number of users that can vote this proposal
def eligible_voters_count
  if self.private?
    if self.presentation_areas.size > 0 #if we are in a working area
      self.presentation_areas.first.count_voter_partecipants
    else
      self.presentation_groups.first.count_voter_partecipants
    end
  else
    User.confirmed.unblocked.count #if it's public everyone can vote
  end
end


#count without fetching, for the list. this number may be different from partecipants because doesn't look if the partecipants are still in the group
def partecipants_count
  a = User.joins({:proposal_rankings => [:proposal]}).where(["proposals.id = ?", self.id]).count
  a += User.joins({:proposal_comments => [:proposal]}).where(["proposals.id = ?", self.id]).count
end

#retrieve all the partecipants to the proposals that are still part of the group
def partecipants
  #all users who ranked the proposal
  a = User.all(:joins => {:proposal_rankings => [:proposal]}, :conditions => ["proposals.id = ?", self.id])
  #all users who contributed to the proposal
  b = User.all(:joins => {:proposal_comments => [:proposal]}, :conditions => ["proposals.id = ?", self.id])
  c = (a | b)
  if self.private
    #all users that are part of the group of the proposal
    d = self.presentation_groups.map { |group| group.partecipants }.flatten
    e = self.groups.map { |group| group.partecipants }.flatten
    f = d | e
    #the partecipants are user that partecipated the proposal and are still in the group
    c = c & f
  end
  c
end


#all users that will receive a notification that asks them to check or give their valutation to the proposal
def notification_receivers
  #will receive the notification the users that partecipated to the proposal and can change their valutation or they haven't give it yet
  users = self.partecipants
  res = []
  users.each do |user|
    #user ranking to the proposal
    ranking = user.proposal_rankings.first(:conditions => {:proposal_id => self.id})
    res << user if !ranking || (ranking && (ranking.updated_at < self.updated_at)) #if he ranked and can change it
  end
end


#all users that will receive a notification that asks them to vote the proposal
def vote_notification_receivers
  #will receive the notification the users that partecipated to the proposal and can change their valutation or they haven't give it yet
  users = self.partecipants
  res = []
  users.each do |user|
    #user ranking to the proposal
    ranking = user.proposal_rankings.first(:conditions => {:proposal_id => self.id})
    res << user if !ranking || (ranking && (ranking.updated_at < self.updated_at)) #if he ranked and can change it
  end
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
               ORDER BY closeness DESC limit 10"
  Proposal.find_by_sql(sql_q)
end


searchable do
  text :title, boost: 5
  text :content, boost: 2
  text :paragraphs do
    (sections.map { |section| section.paragraphs.map { |paragraph| paragraph.content } } +
        solutions.map { |solution| solution.sections.map { |section| section.paragraphs.map { |paragraph| paragraph.content } } }).flatten
  end
  boolean :visible_outside
  boolean :private
  integer :presentation_group_ids, multiple: true #presentation groups
  integer :group_ids, multiple: true #supporting groups
  integer :presentation_area_ids, multiple: true #area
  integer :proposal_state_id
  integer :proposal_category_id
  integer :proposal_type_id
  time :created_at
  time :updated_at
  integer :valutations
  double :rank
  time :quorum_ends_at do
    self.quorum.ends_at
  end

  #two infos only when is in vote
  integer :votes do
    self.user_votes.count if voting? || voted?
  end
  time :votation_ends_at do
    self.vote_period.endtime if voting? || voted?
  end
end

#restituisce la percentuale di avanzamento della proposta in base al quorum assegnato
def calculate_percentage
  return unless self.quorum
  @percentage = self.quorum.debate_progress
end

def percentage
  @percentage ||= calculate_percentage
end


def users_j
  self.is_anonima? ?
      self.proposal_nicknames.where(:user_id => self.user_ids).as_json(only: [:nickname]) :
      self.users.as_json(:only => [:id], :methods => [:fullname])
end

end
