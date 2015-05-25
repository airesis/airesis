class Proposal < ActiveRecord::Base
  include BlogKitModelHelper, Frm::Concerns::Viewable, Concerns::ProposalBuildable

  belongs_to :state, class_name: 'ProposalState', foreign_key: :proposal_state_id
  belongs_to :category, class_name: 'ProposalCategory', foreign_key: :proposal_category_id
  belongs_to :vote_period, class_name: 'Event', foreign_key: :vote_period_id #attached when is decided
  belongs_to :vote_event, class_name: 'Event', foreign_key: :vote_event_id #attached when the proposal is created, only possible
  has_many :proposal_presentations, -> { order 'id DESC' }, class_name: 'ProposalPresentation', dependent: :destroy

  has_many :proposal_borders, class_name: 'ProposalBorder', dependent: :destroy

  has_many :proposal_revisions, dependent: :destroy
  has_many :paragraph_histories, dependent: :destroy

  has_one :vote, class_name: 'ProposalVote', dependent: :destroy

  has_many :user_votes, class_name: 'UserVote'

  has_many :schulze_votes, class_name: 'ProposalSchulzeVote', dependent: :destroy

  # all the comments related to the proposal
  has_many :proposal_comments, class_name: 'ProposalComment', dependent: :destroy
  # only the main contributes related to the proposal
  has_many :contributes, -> { where(['parent_proposal_comment_id is null']) }, class_name: 'ProposalComment', dependent: :destroy
  has_many :rankings, class_name: 'ProposalRanking', dependent: :destroy
  has_many :positive_rankings, -> { where(['ranking_type_id = 1']) }, class_name: 'ProposalRanking'

  has_many :proposal_lives, -> { order 'proposal_lives.created_at DESC' }, class_name: 'ProposalLife', dependent: :destroy
  has_many :users, through: :proposal_presentations, class_name: 'User'

  has_many :proposal_supports, class_name: 'ProposalSupport', dependent: :destroy
  has_many :supporting_groups, through: :proposal_supports, class_name: 'Group', source: :group
  #confini di interesse
  has_many :interest_borders, through: :proposal_borders, class_name: 'InterestBorder'

  has_many :proposal_tags, class_name: 'ProposalTag', dependent: :destroy
  has_many :tags, through: :proposal_tags, class_name: 'Tag'

  has_many :proposal_nicknames, class_name: 'ProposalNickname', dependent: :destroy

  has_many :group_proposals, class_name: 'GroupProposal', dependent: :delete_all
  has_many :groups, through: :group_proposals, class_name: 'Group', source: :group

  has_many :area_proposals, class_name: 'AreaProposal', dependent: :destroy
  has_many :presentation_areas, through: :area_proposals, class_name: 'GroupArea', source: :group_area

  has_many :available_authors, class_name: 'AvailableAuthor', dependent: :destroy
  has_many :available_user_authors, through: :available_authors, class_name: 'User', source: :user

  belongs_to :quorum, class_name: 'Quorum'

  #eager_load :quorum

  has_many :proposal_sections, dependent: :destroy
  has_many :sections, -> { order :seq }, through: :proposal_sections

  has_many :solutions, -> { order 'solutions.seq' }, dependent: :destroy

  belongs_to :proposal_votation_type, class_name: 'ProposalVotationType'

  belongs_to :proposal_type, class_name: 'ProposalType'

  #forum
  has_many :topic_proposals, class_name: 'Frm::TopicProposal', foreign_key: 'proposal_id'
  has_many :topics, class_name: 'Frm::Topic', through: :topic_proposals

  has_many :blocked_proposal_alerts, class_name: 'BlockedProposalAlert', dependent: :destroy

  #validation
  validates_presence_of :title, message: "obbligatorio" #TODO:I18n
  validates_uniqueness_of :title
  validates_presence_of :proposal_category_id, message: "obbligatorio"

  validates_presence_of :quorum, unless: :is_petition? #todo bug in client_side_validation

  validates_with AtLeastOneValidator, associations: [:solutions], unless: :is_petition?

  attr_accessor :update_user_id, :group_area_id, :percentage, :integrated_contributes_ids, :integrated_contributes_ids_list, :topic_id, :votation, :petition_phase, :change_advanced_options, :current_user_id, :interest_borders_tkn

  accepts_nested_attributes_for :sections, allow_destroy: true
  accepts_nested_attributes_for :solutions, allow_destroy: true

  #tutte le proposte 'attive'. sono attive le proposte dalla  fase di valutazione fino a quando non vengono accettate o respinte
  scope :current, -> { where(proposal_state_id: [ProposalState::VALUTATION, ProposalState::WAIT_DATE, ProposalState::WAIT, ProposalState::VOTING]) }
  #tutte le proposte in valutazione
  scope :in_valutation, -> { where(proposal_state_id: ProposalState::VALUTATION) }
  #tutte le proposte in attesa di votazione o attualmente in votazione


  #retrieve proposals in a state before votation, exclude petitions
  scope :before_votation, -> { where(['proposal_state_id in (?) and proposal_type_id != ?', [ProposalState::VALUTATION, ProposalState::WAIT_DATE, ProposalState::WAIT], 11]) }

  scope :in_votation, -> { where(proposal_state_id: [ProposalState::WAIT_DATE, ProposalState::WAIT, ProposalState::VOTING]) }

  #waiting for the votation to start (already choosen)
  scope :waiting, -> { where(proposal_state_id: ProposalState::WAIT) }
  scope :voting, -> { where(proposal_state_id: ProposalState::VOTING) }

  scope :not_voted_by, ->(user_id) { where('proposal_state_id = ? and proposals.id not in (select proposal_id from user_votes where user_id = ?)', ProposalState::VOTING, user_id) }

  #tutte le proposte accettate
  scope :accepted, -> { where(proposal_state_id: ProposalState::ACCEPTED) }
  #tutte le proposte respinte
  scope :rejected, -> { where(proposal_state_id: ProposalState::REJECTED) }
  #tutte le proposte respinte
  scope :abandoned, -> { where(proposal_state_id: ProposalState::ABANDONED) }

  scope :voted, -> { where(proposal_state_id: [ProposalState::ACCEPTED, ProposalState::REJECTED]) }

  #tutte le proposte entrate in fase di revisione e feedback
  scope :revision, -> { where(proposal_state_id: ProposalState::ABANDONED) }

  #all proposals visible to not logged users
  scope :public, -> { where(['private = ? or visible_outside = ?', false, true]) }

  scope :private, -> { where(private: true) } #proposte interne ai gruppi

  #inconsistent proposals
  scope :invalid_debate_phase, -> { in_valutation.joins(:quorum).where('current_timestamp > quorums.ends_at') }
  scope :invalid_waiting_phase, -> { waiting.joins(:vote_period).where('current_timestamp > events.starttime') }
  scope :invalid_vote_phase, -> { voting.joins(:vote_period).where('current_timestamp > events.endtime') }

  after_initialize :init

  before_validation :before_create_populate, on: :create

  after_create :generate_nickname

  after_commit :send_notifications, on: :create
  after_commit :send_update_notifications, on: :update

  before_update :before_update_populate
  before_save :save_tags

  after_destroy :remove_scheduled_tasks

  def acked_by?(user)
    last_view = view_for(user)
    last_view.present? && (last_view.current_viewed_at > updated_at)
  end

  def init
    self.quorum_id ||= Quorum::STANDARD
    self.anonima = (self.is_petition? ? false : DEFAULT_ANONIMA) if self.anonima.nil?
    self.visible_outside = true if self.visible_outside.nil?
    self.secret_vote = true if self.secret_vote.nil?
    self.change_advanced_options = DEFAULT_CHANGE_ADVANCED_OPTIONS if self.change_advanced_options.nil?
    self.proposal_votation_type_id ||= ProposalVotationType::STANDARD
  end


  def self.alerts_count_subquery(user_id)
    alerts = Alert.arel_table
    proposals = Proposal.arel_table
    alerts_count = alerts.
      project('count(*)').
      where(alerts[:trackable_id].eq(proposals[:id]).
              and(alerts[:trackable_type].eq('Proposal')).
              and(alerts[:user_id].eq(user_id)).
              and(alerts[:checked].eq(false)))
  end

  def self.ranking_subquery(user_id)
    proposals = Proposal.arel_table
    proposal_rankings = ProposalRanking.arel_table
    ranking = proposal_rankings.
      project(proposal_rankings[:ranking_type_id]).
      where(proposal_rankings[:proposal_id].eq(proposals[:id]).
              and(proposal_rankings[:user_id].eq(user_id)))
  end

  #retrieve the list of propsoals for the user with a count of the number of the notifications for each proposal
  def self.open_space_portlet(user=nil)
    user_id = user ? user.id : -1
    proposals = Proposal.arel_table
    petition_id = ProposalType.find_by(name: ProposalType::PETITION).id
    alerts_count = alerts_count_subquery(user_id)
    ranking = ranking_subquery(user_id)
    Proposal.public.
      select('distinct proposals.*', alerts_count.as('alerts_count'), ranking.as('ranking')).
      where(proposals[:proposal_type_id].not_eq(petition_id)).
      order(updated_at: :desc).limit(10)
  end

  #retrieve the list of proposals for the user with a count of the number of the notifications for each proposal
  def self.home_portlet(user)
    proposals = Proposal.arel_table
    petition_id = ProposalType.find_by(name: ProposalType::PETITION).id
    alerts_count = alerts_count_subquery(user.id)
    ranking = ranking_subquery(user.id)

    list_a = user.proposals.before_votation.pluck('proposals.id')
    list_b = user.partecipating_proposals.before_votation.pluck('proposals.id')
    list_c = list_a | list_b
    return [] if list_c.empty?

    proposals = Proposal.current.
      select('distinct proposals.*', alerts_count.as('alerts_count'), ranking.as('ranking')).
      where(proposals[:proposal_type_id].not_eq(petition_id)).
      where(proposals[:id].in(list_c)).
      order(updated_at: :desc).to_a
    ActiveRecord::Associations::Preloader.new(proposals, [:quorum, {users: :image}, :proposal_type, :groups, :supporting_groups, :category]).run
    proposals
  end

  #retrieve the list of propsoals for the user with a count of the number of the notifications for each proposal
  def self.open_space_petitions_portlet(user)
    proposals = Proposal.arel_table
    petition_id = ProposalType.find_by(name: ProposalType::PETITION).id
    alerts_count = alerts_count_subquery(user.id)

    Proposal.public.
      select('distinct proposals.*', alerts_count.as('alerts_count')).
      where(proposals[:proposal_type_id].eq(petition_id)).
      order(updated_at: :desc).limit(10)
  end

  def self.votation_portlet(user)
    user_id = user.id
    proposals = Proposal.arel_table
    group_proposals = GroupProposal.arel_table
    group_participations = GroupParticipation.arel_table
    groups = Group.arel_table
    events = Event.arel_table
    action_abilitations = ActionAbilitation.arel_table
    participation_roles = ParticipationRole.arel_table
    user_votes = UserVote.arel_table
    petition_id = ProposalType.find_by(name: ProposalType::PETITION).id
    alerts_count = alerts_count_subquery(user_id)
    ranking = ranking_subquery(user_id)

    proposals_sql = Proposal.voting.uniq.
      project(alerts_count.as('alerts_count'), ranking.as('ranking'), events[:endtime].as('end_time')).
      join(group_proposals).on(group_proposals[:proposal_id].eq(proposals[:id])).
      join(groups).on(groups[:id].eq(group_proposals[:group_id])).
      join(group_participations).on(groups[:id].eq(group_participations[:group_id]).
                                      and(group_participations[:user_id].eq(user.id))).
      join(participation_roles).on(group_participations[:participation_role_id].eq(participation_roles[:id])).
      join(events).on(events[:id].eq(proposals[:vote_period_id])).
      join(action_abilitations, Arel::OuterJoin).on(action_abilitations[:participation_role_id].eq(participation_roles[:id])).
      join(user_votes, Arel::OuterJoin).on(user_votes[:proposal_id].eq(proposals[:id]).and(user_votes[:user_id].eq(user.id))).
      where(proposals[:proposal_type_id].not_eq(petition_id)).
      where(user_votes[:id].eq(nil)).
      where(action_abilitations[:group_action_id].eq(GroupAction::PROPOSAL_VOTE).
              or(participation_roles[:id].eq(ParticipationRole.admin.id))).
      order('end_time asc').to_sql
    proposals = Proposal.find_by_sql(proposals_sql)
    ActiveRecord::Associations::Preloader.new(proposals, [:quorum, {users: :image}, :proposal_type, :groups, :supporting_groups, :category]).run
    proposals
  end

  #retrieve the list of proposals for the group with a count of the number of the notifications for each proposal
  def self.group_portlet(group, user)
    user_id = user.id
    proposals = Proposal.arel_table
    group_proposals = GroupProposal.arel_table
    alerts_count = alerts_count_subquery(user_id)
    ranking = ranking_subquery(user_id)
    Proposal.find_by_sql(proposals.
      project('distinct proposals.*',alerts_count.as('alerts_count'), ranking.as('ranking')).
      join(group_proposals).on(proposals[:id].eq(group_proposals[:proposal_id])).
      where(group_proposals[:group_id].eq(group.id)).
      order(proposals[:created_at].desc).take(10).to_sql)
  end


  def count_notifications(user_id)
    alerts = Alert.where(trackable: self, checked: false, user_id: user_id).count
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
    #Resque.remove_delayed(ProposalsWorker, {action: ProposalsWorker::ENDTIME, proposal_id: self.id}) #TODO remove jobs
  end

  # return true if the proposal is currently in debate
  def in_valutation?
    proposal_state_id == ProposalState::VALUTATION
  end

  # the proposal is waiting for someone to decide the vote date
  def waiting_date?
    proposal_state_id == ProposalState::WAIT_DATE
  end

  def waiting?
    proposal_state_id == ProposalState::WAIT
  end

  def voting?
    proposal_state_id == ProposalState::VOTING
  end

  def abandoned?
    proposal_state_id == ProposalState::ABANDONED
  end

  def voted?
    accepted? || rejected?
  end

  def accepted?
    proposal_state_id == ProposalState::ACCEPTED
  end

  def rejected?
    proposal_state_id == ProposalState::REJECTED
  end

  def is_current?
    [ProposalState::VALUTATION, ProposalState::WAIT_DATE, ProposalState::WAIT, ProposalState::VOTING].include? proposal_state_id
  end

  #restituisce 'true' se la proposta è attualmente anonima, ovvero è stata definita come tale ed è in dibattito
  def is_anonima?
    is_current? && anonima
  end

  #return true if the proposal is in a group
  def in_group?
    private?
  end

  def in_group_area?
    in_group? && presentation_areas.any?
  end

  def is_petition?
    proposal_type_id == 11
  end

  #return the group to which belongs the proposal
  #if is in the open space then nil is returned
  #TODO if belongs to many groups returns the first. we actually have max 1 group
  def group
    groups.first
  end

  #return the group_area to which belongs the proposal
  #if is in the open space then nil is returned
  #TODO if belongs to many group_areas returns the first. we actually have max 1 group area
  def group_area
    presentation_areas.first
  end

  def tags_list
    @tags_list ||= tags.map(&:text).join(', ')
  end


  def tags_list=(tags_list)
    @tags_list = tags_list
  end

  def tags_list_json
    @tags_list ||= tags.map(&:text).join(', ')
  end


  def tags_with_links
    tags.collect { |t| "<a href=\"/tag/#{t.text.strip}\">#{t.text.strip}</a>" }.join(', ')
  end

  def save_tags
    return unless @tags_list
    tids = []
    @tags_list.split(/,/).each do |tag|
      stripped = tag.strip.downcase.gsub('.', '').gsub("'", "")
      unless stripped.blank?
        t = Tag.find_or_create_by(text: stripped)
        tids << t.id
      end
    end
    self.tag_ids = tids
  end

  def to_param
    "#{id}-#{title.downcase.gsub(/[^a-zA-Z0-9]+/, '-').gsub(/-{2,}/, '-').gsub(/^-|-$/, '')}"
  end

  #restituisce il primo autore della proposta
  def user
    @first_user ||= proposal_presentations.first.user
  end

  def short_content
    begin
      section = sections.first || solutions.first.sections.first
      truncate_words(section.paragraphs.first.content.gsub(%r{</?[^>]+?>}, ''), 40)
    rescue
      nil
    end
  end

  #retrieve the number of users that can vote this proposal
  def eligible_voters_count
    return User.confirmed.unblocked.count unless private?
    if self.presentation_areas.size > 0 #if we are in a working area
      presentation_areas.first.scoped_participants(GroupAction::PROPOSAL_VOTE).count #todo more areas
    else
      groups.first.scoped_participants(GroupAction::PROPOSAL_VOTE).count #todo more groups
    end
  end


  # count without fetching, for the list.
  # this number may be different from participants because doesn't look if the participants are still in the group
  def participants_count
    users = User.arel_table
    proposal_comments = ProposalComment.arel_table
    proposal_rankings = ProposalRanking.arel_table
    query = users.
      project(users[:id].count(true)).
      join(proposal_comments, Arel::Nodes::OuterJoin).
      on(users[:id].eq proposal_comments[:user_id]).
      join(proposal_rankings, Arel::Nodes::OuterJoin).
      on(users[:id].eq proposal_rankings[:user_id]).
      where(proposal_rankings[:proposal_id].eq id).
      where(proposal_comments[:proposal_id].eq id)
    ActiveRecord::Base.connection.execute(query.to_sql)[0]['count'].to_i
  end

  #retrieve all the participants to the proposals that are still part of the group
  def participants
    #all users who ranked the proposal
    a = User.joins(proposal_rankings: :proposal).where(proposals: {id: id}).load
    #all users who contributed to the proposal
    b = User.joins(proposal_comments: :proposal).where(proposals: {id: id}).load
    c = (a | b)
    if private
      #all users that are part of the group of the proposal
      d = self.supporting_groups.map { |group| group.participants }.flatten
      e = self.groups.map { |group| group.participants }.flatten
      f = d | e
      #the participants are user that partecipated the proposal and are still in the group
      c = c & f
    end
    c
  end

  #all users that will receive a notification that asks them to check or give their valutation to the proposal
  def notification_receivers
    #will receive the notification the users that partecipated to the proposal and can change their valutation or they haven't give it yet
    users = self.participants
    res = []
    users.each do |user|
      #user ranking to the proposal
      ranking = user.proposal_rankings.where(proposal_id: id).first
      res << user if !ranking || (ranking && (ranking.updated_at < updated_at)) #if he ranked and can change it
    end
    res
  end


  #all users that will receive a notification that asks them to vote the proposal
  def vote_notification_receivers
    #will receive the notification the users that partecipated to the proposal and can change their valutation or they haven't give it yet
    users = self.participants
    res = []
    users.each do |user|
      #user ranking to the proposal
      ranking = user.proposal_rankings.find_by(proposal_id: id)
      res << user if !ranking || (ranking.updated_at < updated_at) #if he ranked and can change it
    end
  end

  #restituisce la lista delle 10 proposte più vicine a questa
  def closest(group_id=nil)
    sql_q = " SELECT p.id, p.proposal_state_id, p.proposal_category_id, p.title, p.quorum_id, p.anonima, p.visible_outside, p.secret_vote, p.proposal_votation_type_id, p.content,
              p.created_at, p.updated_at, p.valutations, p.vote_period_id, p.proposal_comments_count,
              p.rank, p.show_comment_authors, COUNT(*) AS closeness
              FROM proposal_tags pt join proposals p on pt.proposal_id = p.id "

    sql_q += " left join group_proposals gp on gp.proposal_id = p.id " if group_id
    sql_q += " WHERE pt.tag_id IN (SELECT pti.tag_id
                                  FROM proposal_tags pti
                                  WHERE pti.proposal_id = #{self.id})
              AND pt.proposal_id != #{self.id} "
    sql_q += " AND (p.private = false OR p.visible_outside = true "
    sql_q += group_id ? " OR (p.private = true AND gp.group_id = #{group_id}))" : ")"
    sql_q += " GROUP BY p.id, p.proposal_state_id, p.proposal_category_id, p.title, p.quorum_id, p.anonima, p.visible_outside, p.secret_vote, p.proposal_votation_type_id, p.content,
               p.created_at, p.updated_at, p.valutations, p.vote_period_id, p.proposal_comments_count,
               p.rank, p.show_comment_authors
               ORDER BY closeness DESC limit 10"
    Proposal.find_by_sql(sql_q)
  end

  searchable do
    text :title, boost: 5
    text :content, boost: 2
    text :paragraphs do
      (sections.map { |section| section.paragraphs.map { |paragraph| paragraph.content.gsub!(/\p{Cc}/, '') } } +
        solutions.map { |solution| solution.sections.map { |section| section.paragraphs.map { |paragraph| paragraph.content.gsub!(/\p{Cc}/, '') } } }).flatten
    end
    text :tags_list do
      self.tags.map(&:text).join(' ')
    end
    boolean :visible_outside
    boolean :private
    integer :id
    integer :supporting_group_ids, multiple: true #presentation groups
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
      self.quorum.ends_at if self.quorum
    end

    integer :votes do
      self.user_votes.count if voting? || voted?
    end
    time :votation_ends_at do
      self.vote_period.endtime if self.vote_period && (voting? || voted?)
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
      self.proposal_nicknames.where(user_id: self.user_ids).as_json(only: [:nickname]) :
      self.users.as_json(only: [:id], methods: [:fullname])
  end


  #check if we have to close the debate and pass to votation phase
  #accept a force parameter to close the debate in any case
  def check_phase(force_end=false)
    quorum.check_phase(force_end) if in_valutation? #if the proposal already passed this phase skip this check
  end


  def close_vote_phase
    quorum.close_vote_phase if voting?
  end

  def abandon
    return unless in_valutation?
    logger.info "Abandoning proposal #{id}"
    self.proposal_state_id = ProposalState::ABANDONED
    life = proposal_lives.build(quorum_id: quorum_id, valutations: valutations, rank: rank, seq: ((proposal_lives.maximum(:seq) || 0) + 1))
    #save old authors
    users.each do |user|
      life.users << user
    end
    #delete old data
    self.valutations = 0
    self.rank = 0

    NotificationProposalAbandoned.perform_in(1.minute, id, participants.map(&:id))
    #and authors
    proposal_presentations.destroy_all

    #and rankings
    rankings.destroy_all

    save
    #remove the timer if is still there
    #if self.minutes #todo remove jobs
    #  Resque.remove_delayed(ProposalsWorker, {action: ProposalsWorker::ENDTIME, proposal_id: proposal.id})
    #end
  end

  # put the proposal back in debate from abandoned
  def regenerate(params)
    self.proposal_state_id = ProposalState::VALUTATION
    user = User.find(current_user_id)
    users << user
    update(params)
    assign_quorum

    ProposalNickname.generate(user, self)

    #if the time is fixed we schedule notifications 24h and 1h before the end of debate
    if quorum.time_fixed?
      ProposalsWorker.perform_at(quorum.ends_at - 24.hours, {action: ProposalsWorker::LEFT24, proposal_id: id}) if quorum.minutes > 1440
      ProposalsWorker.perform_at(quorum.ends_at - 1.hour, {action: ProposalsWorker::LEFT1, proposal_id: id}) if quorum.minutes > 60
    end
  end


  def set_votation_date(vote_period_id)
    vote_period = Event.find(vote_period_id)
    raise Exception unless vote_period.starttime > (5.seconds.from_now) # security check
    self.vote_period_id = vote_period_id
    self.proposal_state_id = ProposalState::WAIT
    save!
  end

  private

  def before_update_populate
    self.update_user_id = current_user_id
    save_history
    update_borders
    assign_quorum if self.quorum_id_changed?
  end

  def before_create_populate
    return unless quorum
    group = group_proposals.first.try(:group)

    update_borders

    current_user = User.find(current_user_id)
    proposal_presentations.build(user: current_user)

    #per sicurezza reimposto questi parametri per far si che i cattivi hacker non cambino le impostazioni se non possono
    if group
      unless group.change_advanced_options
        self.anonima = group.default_anonima
        self.visible_outside = group.default_visible_outside
        self.secret_vote = group.default_secret_vote
      end
      self.private = true

      group_area = GroupArea.find(group_area_id) if group_area_id.present?
      if group_area #check user permissions for this group area
        errors.add(:group_area_id, I18n.t('permissions_required')) if current_user.cannot? :insert_proposal, group_area
        self.presentation_areas << group_area
      end

      topic = group.topics.find(topic_id) if topic_id.present?
      topic_proposals.build(topic_id: topic.id, user_id: current_user_id) if topic
    end

    #we don't use quorum for petitions
    if self.is_petition?
      self.proposal_state_id = (self.petition_phase == 'signatures') ? ProposalState::VOTING : ProposalState::VALUTATION
      self.build_vote(positive: 0, negative: 0, neutral: 0)
    else
      assign_quorum

      self.proposal_state_id = ProposalState::VALUTATION
      self.rank = 0
    end
  end

  def send_notifications
    return if is_petition?

    #if the time is fixed we schedule notifications 24h and 1h before the end of debate
    if quorum.time_fixed?
      ProposalsWorker.perform_at(quorum.ends_at - 24.hours, {action: ProposalsWorker::LEFT24, proposal_id: id}) if quorum.minutes > 1440
      ProposalsWorker.perform_at(quorum.ends_at - 1.hour, {action: ProposalsWorker::LEFT1, proposal_id: id}) if quorum.minutes > 60
    end

    #end of debate timer
    ProposalsWorker.perform_at(quorum.ends_at, {action: ProposalsWorker::ENDTIME, proposal_id: id}) if quorum.minutes

    #alert users of the new proposal
    NotificationProposalCreate.perform_async(id)
  end


  def send_update_notifications
    if quorum_id_changed? # regenerated
      ProposalsWorker.perform_at(quorum.ends_at, {action: ProposalsWorker::ENDTIME, proposal_id: id})
    elsif current_user_id # updated or set votation date
      if waiting? # someone chose votation date
        NotificationProposalWaitingForDate.perform_async(id, current_user.id)
      else # standard update
        NotificationProposalUpdate.perform_async(current_user_id, id, groups.first.try(:id))
      end
    end
  end

  def save_history
    something = false
    seq = (self.proposal_revisions.maximum(:seq) || 0) + 1
    revision = self.proposal_revisions.build(user_id: update_user_id, valutations: valutations_was, rank: rank_was, seq: seq)
    self.sections.each do |section|
      paragraph = section.paragraphs.first
      paragraph.content = '' if (paragraph.content == '<p></p>' && paragraph.content_was == '')
      if paragraph.content_changed? || section.marked_for_destruction?
        something = true
        section_history = revision.section_histories.build(section_id: section.id, title: section.title, seq: section.seq, added: section.new_record?, removed: section.marked_for_destruction?)
        section_history.paragraphs.build(content: paragraph.content_dirty, seq: 1, proposal_id: self.id)
      end
    end
    self.solutions.each do |solution|

      solution_history = revision.solution_histories.build(seq: solution.seq, title: solution.title, added: solution.new_record?, removed: solution.marked_for_destruction?)
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
    if something
      comment_ids = ProposalComment.where({id: integrated_contributes_ids, parent_proposal_comment_id: nil}).pluck(:id) #controllo di sicurezza
      ProposalComment.where(id: comment_ids).update_all({integrated: true})
      revision.contribute_ids = comment_ids
      self.updated_at = Time.now
    else
      revision.destroy
    end
  end

  def update_borders
    proposal_borders.destroy_all
    interest_borders_tkn.to_s.split(',').each do |border| # l'identificativo è nella forma 'X-id'
      ftype = border[0, 1] #tipologia (primo carattere)
      fid = border[2..-1] #chiave primaria (dal terzo all'ultimo carattere)
      found = InterestBorder.table_element(border)
      if found #se ho trovato qualcosa, allora l'identificativo è corretto e posso procedere alla creazione del confine di interesse
        interest_b = InterestBorder.find_or_create_by(territory_type: InterestBorder::I_TYPE_MAP[ftype], territory_id: fid)
        i = proposal_borders.build(interest_border_id: interest_b.id)
      end
    end
  end

  def assign_quorum
    group = self.group_proposals.first.try(:group)
    group_area = GroupArea.find(group_area_id) if group_area_id.present?
    copy = quorum.dup #make a copy of the assigned quorum and work on it
    starttime = Time.now
    #the quorum has minutes defined. calculate started_at and ends_at using these minutes
    copy.started_at = starttime
    if quorum.minutes
      endtime = starttime + quorum.minutes.minutes
      copy.ends_at = endtime
    end

    #todo move quorum build in quorum model
    base_valutations = 0
    base_vote_valutations = 0
    if group_area #we have to calculate the number of valutations based on group area participants
      base_valutations = group_area.scoped_participants(GroupAction::PROPOSAL_PARTICIPATION).count.to_f
      base_vote_valutations = group_area.scoped_participants(GroupAction::PROPOSAL_VOTE).count.to_f
    elsif group #we have to calculate the number of valutations based on group participants
      base_valutations = group.scoped_participants(GroupAction::PROPOSAL_PARTICIPATION).count.to_f
      base_vote_valutations = group.scoped_participants(GroupAction::PROPOSAL_VOTE).count.to_f
    else #we calculate the number of valutations based on application users number
      base_vote_valutations = base_valutations = User.count_active
    end
    copy.valutations = ((quorum.percentage.to_f * base_valutations) / 100).floor
    copy.vote_valutations = ((quorum.vote_percentage.to_f * base_vote_valutations) / 100).floor #todo we must calculate it before votation because there can be new users in the meantime

    #always add 1 and at least 1. todo max is useless
    copy.valutations = [copy.valutations + 1, 1].max
    copy.vote_valutations = [copy.vote_valutations + 1, 1].max

    copy.public = false #assigned quorum are never public
    copy.assigned = true
    copy.save
    self.quorum_id = copy.id #replace the quorum with the copy

    #if is time fixed you can choose immediatly vote period
    return unless copy.time_fixed?
    #if the user chose it
    if votation && (votation[:later] != 'true')
      #if he took a vote period already existing
      if (votation[:choise] && (votation[:choise] == 'preset')) || (!votation[:choise] && votation[:vote_period_id].present?)
        self.vote_event = Event.find(votation[:vote_period_id])
        if vote_event.starttime < Time.now + copy.minutes.minutes + DEBATE_VOTE_DIFFERENCE #if the vote period start before the end of debate there is an error
          errors.add(:base, I18n.t('error.proposals.vote_period_incorrect'))
        end
      else #if he created a new period
        start = ((votation[:start_edited].present?) && votation[:start]) || (copy.ends_at + DEBATE_VOTE_DIFFERENCE) #look if he edited the starttime or not
        raise Exception 'error' unless votation[:end].present?
        self.vote_starts_at = start
        self.vote_ends_at = votation[:end]
        if (vote_starts_at - copy.ends_at) < DEBATE_VOTE_DIFFERENCE
          errors.add(:base, I18n.t('error.proposals.vote_period_soon', time: DEBATE_VOTE_DIFFERENCE.to_i / 60))
        end
        if vote_ends_at < (vote_starts_at + 10.minutes)
          errors.add(:base, I18n.t('error.proposals.vote_period_short'))
        end
      end
      self.vote_defined = true
    else
      self.vote_defined = false
      self.vote_starts_at = nil
      self.vote_ends_at = nil
    end
  end

  def generate_nickname
    ProposalNickname.generate(User.find(current_user_id), self)
  end
end
