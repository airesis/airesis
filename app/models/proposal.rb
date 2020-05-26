class Proposal < ApplicationRecord
  include Taggable
  include ProposalBuildable
  include Frm::Concerns::Viewable
  include ProposalSearchable

  belongs_to :state, class_name: 'ProposalState', foreign_key: :proposal_state_id
  belongs_to :category, class_name: 'ProposalCategory', foreign_key: :proposal_category_id
  belongs_to :vote_period, class_name: 'Event', foreign_key: :vote_period_id, optional: true # attached when is decided
  belongs_to :vote_event, class_name: 'Event', foreign_key: :vote_event_id, optional: true # attached when the proposal is created

  # can't move tags before proposal_presentations because these are necessary when creating the tags
  # can't add dependent_destroy to presentations because tags must be destroyed before
  has_many :proposal_presentations, -> { order 'id DESC' }, class_name: 'ProposalPresentation', inverse_of: :proposal
  has_many :users, through: :proposal_presentations, class_name: 'User', inverse_of: :proposals
  has_many :proposal_tags, class_name: 'ProposalTag', dependent: :destroy
  has_many :tags, through: :proposal_tags, class_name: 'Tag'

  has_many :proposal_revisions, inverse_of: :proposal, dependent: :destroy
  has_many :paragraph_histories, inverse_of: :proposal, dependent: :destroy

  has_one :vote, class_name: 'ProposalVote', dependent: :destroy

  has_many :user_votes

  has_many :schulze_votes, class_name: 'ProposalSchulzeVote', inverse_of: :proposal, dependent: :destroy

  # all the comments related to the proposal
  has_many :proposal_comments, class_name: 'ProposalComment', inverse_of: :proposal, dependent: :destroy
  # only the main contributes related to the proposal
  has_many :contributes, -> { where(parent_proposal_comment_id: nil) },
           class_name: 'ProposalComment', dependent: :destroy
  has_many :rankings, class_name: 'ProposalRanking', dependent: :destroy
  has_many :positive_rankings, -> { where(['ranking_type_id = 1']) }, class_name: 'ProposalRanking'

  has_many :proposal_lives, -> { order 'proposal_lives.created_at DESC' },
           class_name: 'ProposalLife', dependent: :destroy

  has_many :proposal_supports, class_name: 'ProposalSupport', dependent: :destroy
  has_many :supporting_groups, through: :proposal_supports, class_name: 'Group', source: :group

  # TODO: remove both
  has_many :proposal_borders, class_name: 'ProposalBorder', dependent: :destroy
  has_many :interest_borders, through: :proposal_borders, class_name: 'InterestBorder'

  has_many :proposal_nicknames, class_name: 'ProposalNickname', dependent: :destroy

  has_many :group_proposals, class_name: 'GroupProposal', dependent: :delete_all
  has_many :groups, through: :group_proposals, class_name: 'Group', source: :group

  has_many :area_proposals, class_name: 'AreaProposal', dependent: :destroy
  has_many :presentation_areas, through: :area_proposals, class_name: 'GroupArea', source: :group_area

  has_many :available_authors, class_name: 'AvailableAuthor', dependent: :destroy
  has_many :available_user_authors, through: :available_authors, class_name: 'User', source: :user

  belongs_to :quorum, class_name: 'Quorum'

  # eager_load :quorum

  has_many :proposal_sections, dependent: :destroy
  has_many :sections, -> { order :seq }, through: :proposal_sections

  has_many :solutions, -> { order 'solutions.seq' }, inverse_of: :proposal, dependent: :destroy

  belongs_to :proposal_type, class_name: 'ProposalType'

  # forum
  has_many :topic_proposals, class_name: 'Frm::TopicProposal', foreign_key: 'proposal_id'
  has_many :topics, class_name: 'Frm::Topic', through: :topic_proposals

  has_many :blocked_proposal_alerts, class_name: 'BlockedProposalAlert', dependent: :destroy

  has_many :alerts, as: :trackable

  # validation
  validates :title, presence: true, uniqueness: true

  validates :quorum, presence: { unless: :is_petition? } # TODO: bug in client_side_validation

  validates_with AtLeastOneValidator, associations: [:solutions], unless: :is_petition?

  attr_accessor :update_user_id, :group_area_id, :percentage, :integrated_contributes_ids,
                :integrated_contributes_ids_list, :topic_id, :votation, :petition_phase, :change_advanced_options,
                :current_user_id, :interest_borders_tkn

  enum proposal_votation_type_id: { standard: 1, preference: 2, schulze: 3 }, _prefix: true

  accepts_nested_attributes_for :sections, allow_destroy: true
  accepts_nested_attributes_for :solutions, allow_destroy: true

  # tutte le proposte 'attive'. sono attive le proposte dalla  fase di valutazione fino a quando non vengono accettate o respinte
  scope :current, lambda {
    where(proposal_state_id: [ProposalState::VALUTATION,
                              ProposalState::WAIT_DATE,
                              ProposalState::WAIT,
                              ProposalState::VOTING])
  }
  # tutte le proposte in valutazione
  scope :in_valutation, -> { where(proposal_state_id: ProposalState::VALUTATION) }
  # tutte le proposte in attesa di votazione o attualmente in votazione

  # retrieve proposals in a state before votation, exclude petitions
  scope :before_votation,
        lambda {
          where(['proposal_state_id in (?) and proposal_type_id != ?', [ProposalState::VALUTATION,
                                                                        ProposalState::WAIT_DATE,
                                                                        ProposalState::WAIT], 11])
        }

  scope :in_votation,
        -> { where(proposal_state_id: [ProposalState::WAIT_DATE, ProposalState::WAIT, ProposalState::VOTING]) }

  # waiting for the votation to start (already choosen)
  scope :waiting, -> { where(proposal_state_id: ProposalState::WAIT) }
  scope :voting, -> { where(arel_table[:proposal_state_id].eq(ProposalState::VOTING)) }

  scope :not_voted_by, lambda { |user_id|
    where('proposal_state_id = ? and
                       proposals.id not in (select proposal_id from user_votes where user_id = ?)',
          ProposalState::VOTING, user_id)
  }

  # tutte le proposte accettate
  scope :accepted, -> { where(proposal_state_id: ProposalState::ACCEPTED) }
  # tutte le proposte respinte
  scope :rejected, -> { where(proposal_state_id: ProposalState::REJECTED) }
  # tutte le proposte respinte
  scope :abandoned, -> { where(proposal_state_id: ProposalState::ABANDONED) }

  scope :voted, -> { where(proposal_state_id: [ProposalState::ACCEPTED, ProposalState::REJECTED]) }

  # tutte le proposte entrate in fase di revisione e feedback
  scope :revision, -> { where(proposal_state_id: ProposalState::ABANDONED) }

  # all proposals visible to not logged users
  scope :visible, -> { where('private = ? or visible_outside = ?', false, true) }

  scope :internal, -> { where(private: true) } # proposte interne ai gruppi

  # inconsistent proposals
  scope :invalid_debate_phase, -> { in_valutation.joins(:quorum).where('current_timestamp > quorums.ends_at') }
  scope :invalid_waiting_phase, -> { waiting.joins(:vote_period).where('current_timestamp > events.starttime') }
  scope :invalid_vote_phase, -> { voting.joins(:vote_period).where('current_timestamp > events.endtime') }

  scope :select_alerts_and_rankings, lambda { |user_id|
    select('proposals.*',
           Proposal.alerts_count_subquery(user_id).as('alerts_count'),
           Proposal.ranking_subquery(user_id).as('ranking'))
  }

  scope :for_list, lambda { |user_id = nil|
    select_alerts_and_rankings(user_id).
      includes(:interest_borders, :user_votes, :presentation_areas, :groups,
               :category, :quorum, :vote_period, :proposal_type)
  }

  scope :by_interest_borders, ->(ib) { where('proposals.derived_interest_borders_tokens @> ARRAY[?]::varchar[]', ib) }

  after_initialize :init

  before_validation :before_create_populate, on: :create

  after_create :generate_nickname

  after_commit :send_notifications, on: :create
  after_commit :send_update_notifications, on: :update

  before_update :before_update_populate

  # fix to delete relations properly
  before_destroy :destroy_presentations

  after_destroy :remove_scheduled_tasks

  # updates the content of the short_content field which is displayed in the lists
  after_validation :update_short_content

  def init
    self.anonima = (is_petition? ? false : DEFAULT_ANONIMA) if anonima.nil?
    self.visible_outside = true if visible_outside.nil?
    self.secret_vote = true if secret_vote.nil?
    self.change_advanced_options = DEFAULT_CHANGE_ADVANCED_OPTIONS if change_advanced_options.nil?
    self.proposal_votation_type_id ||= :standard
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

  # retrieve the list of propsoals for the user with a count of the number of the notifications for each proposal
  def self.open_space_portlet(user = nil, current_territory = nil)
    user_id = user ? user.id : -1

    proposals = Proposal.
                select('distinct proposals.*',
                       alerts_count_subquery(user_id).as('alerts_count'),
                       ranking_subquery(user_id).as('ranking')).
                where('proposals.private = false or proposals.visible_outside = false').
                where.not(proposal_type_id: 11) # TODO: petitions excluded
    proposals = proposals.by_interest_borders(InterestBorder.to_key(current_territory)) if current_territory.present?
    proposals = proposals.order(updated_at: :desc).page(1).per(10)
    ActiveRecord::Associations::Preloader.new.preload(proposals, %i[quorum groups supporting_groups category])
    proposals
  end

  # retrieve the list of proposals for the user with a count of the number of the notifications for each proposal
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
    ActiveRecord::Associations::Preloader.new.preload(proposals, [:quorum, :category, { users: :image },
                                                                  :proposal_type, :groups, :supporting_groups])
    proposals
  end

  # retrieve the list of propsoals for the user with a count of the number of the notifications for each proposal
  def self.open_space_petitions_portlet(user)
    proposals = Proposal.arel_table
    petition_id = ProposalType.find_by(name: ProposalType::PETITION).id
    alerts_count = alerts_count_subquery(user.id)

    Proposal.visible.
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
    participation_roles = ParticipationRole.arel_table
    user_votes = UserVote.arel_table
    petition_id = ProposalType.find_by(name: ProposalType::PETITION).id
    alerts_count = alerts_count_subquery(user_id)
    ranking = ranking_subquery(user_id)

    proposals = Proposal.voting.distinct.
                select('proposals.*', alerts_count.as('alerts_count'), ranking.as('ranking'), events[:endtime].as('end_time')).
                joins(:vote_period, groups: { group_participations: %i[participation_role user] }).
                left_joins(:user_votes).
                where.not(proposals: { proposal_type_id: petition_id }).
                where(user_votes: { id: nil }).
                where(participation_roles[:vote_proposals].eq(true).or(participation_roles[:id].eq(ParticipationRole.admin.id))).
                order(end_time: :asc)
    ActiveRecord::Associations::Preloader.new.preload(proposals, [:quorum, { users: :image }, :proposal_type, :groups,
                                                                  :supporting_groups, :category])
    proposals
  end

  # retrieve the list of proposals for the group with a count of the number of the notifications for each proposal
  def self.group_portlet(group, user)
    user_id = user.id
    proposals = Proposal.arel_table
    group_proposals = GroupProposal.arel_table
    alerts_count = alerts_count_subquery(user_id)
    ranking = ranking_subquery(user_id)
    Proposal.find_by_sql(proposals.
        project('distinct proposals.*', alerts_count.as('alerts_count'), ranking.as('ranking')).
        join(group_proposals).on(proposals[:id].eq(group_proposals[:proposal_id])).
        where(group_proposals[:group_id].eq(group.id)).
        order(proposals[:created_at].desc).take(10).to_sql)
  end

  def count_notifications(user_id)
    Alert.unscoped.where(trackable: self, checked: false, user_id: user_id).count
  end

  # after_find :calculate_percentage

  def integrated_contributes_ids_list=(value)
    self.integrated_contributes_ids = value.split(/,\s*/)
  end

  def is_schulze?
    solutions.count > 1
  end

  def is_standard?
    proposal_type.name == ProposalType::STANDARD
  end

  def is_polling?
    proposal_type.name == ProposalType::POLL
  end

  # TODO: remove jobs
  def remove_scheduled_tasks
    # Resque.remove_delayed(ProposalsWorker, {action: ProposalsWorker::ENDTIME, proposal_id: self.id})
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
    [ProposalState::VALUTATION,
     ProposalState::WAIT_DATE,
     ProposalState::WAIT,
     ProposalState::VOTING].include? proposal_state_id
  end

  # restituisce 'true' se la proposta è attualmente anonima, ovvero è stata definita come tale ed è in dibattito
  def is_anonima?
    is_current? && anonima
  end

  # return true if the proposal is in a group
  def in_group?
    private?
  end

  def in_group_area?
    in_group? && presentation_areas.any?
  end

  def is_petition?
    proposal_type_id == 11
  end

  # return the group to which belongs the proposal
  # if is in the open space then nil is returned
  # TODO: if belongs to many groups returns the first. we actually have max 1 group
  def group
    groups.first
  end

  # return the group_area to which belongs the proposal
  # if is in the open space then nil is returned
  # TODO: if belongs to many group_areas returns the first. we actually have max 1 group area
  def group_area
    presentation_areas.first
  end

  def to_param
    "#{id}-#{title.downcase.gsub(/[^a-zA-Z0-9]+/, '-').gsub(/-{2,}/, '-').gsub(/^-|-$/, '')}"
  end

  # restituisce il primo autore della proposta
  def user
    @first_user ||= proposal_presentations.first.user
  end

  # retrieve the number of users that can vote this proposal
  def eligible_voters_count
    return User.confirmed.unblocked.count unless private?

    if !presentation_areas.empty? # if we are in a working area
      presentation_areas.first.scoped_participants(:vote_proposals).count # TODO: it can belong to more areas
    else
      groups.first.scoped_participants(:vote_proposals).count # TODO: it can belong to more groups
    end
  end

  # count without fetching, for the list.
  # this number may be different from participants because doesn't look if the participants are still in the group
  def participants_count
    users = User.arel_table
    proposal_comments = ProposalComment.arel_table
    proposal_rankings = ProposalRanking.arel_table

    comments_subquery = join_users_table(proposal_comments)
    rankings_subquery = join_users_table(proposal_rankings)

    User.where(users[:id].in(comments_subquery).or(users[:id].in(rankings_subquery))).count
  end

  # retrieve all the participants to the proposals that are still part of the group
  def participants
    # all users who ranked the proposal
    rankers = User.joins(proposal_rankings: :proposal).where(proposals: { id: id }).load

    # all users who contributed to the proposal
    contributors = User.joins(proposal_comments: :proposal).where(proposals: { id: id }).load
    rankers_and_contributors = (rankers | contributors)
    if private
      # all users that are part of the group of the proposal
      group_supporters = supporting_groups.map(&:participants).flatten
      group_participants = groups.map(&:participants).flatten
      supporters_or_participants = group_supporters | group_participants
      # the participants are user that partecipated the proposal and are still in the group
      rankers_and_contributors &= supporters_or_participants
    end
    rankers_and_contributors
  end

  # all users that will receive a notification that asks them to check or give their valutation to the proposal
  def notification_receivers
    # the users that partecipated to the proposal and can change their valutation or they haven't gave it yet
    users = participants
    res = []
    users.each do |user|
      # user ranking to the proposal
      ranking = user.proposal_rankings.where(proposal_id: id).first
      res << user if !ranking || (ranking && (ranking.updated_at < updated_at)) # if he ranked and can change it
    end
    res
  end

  # all users that will receive a notification that asks them to vote the proposal
  def vote_notification_receivers
    # users that partecipated to the proposal and can change their valutation or they haven't give it yet
    users = participants
    res = []
    users.each do |user|
      # user ranking to the proposal
      ranking = user.proposal_rankings.find_by(proposal_id: id)
      res << user if !ranking || (ranking.updated_at < updated_at) # if he ranked and can change it
    end
  end

  # returns 10
  def closest(group_id = nil)
    sql_q = " SELECT p.id, p.proposal_state_id, p.proposal_category_id, p.title, p.quorum_id, p.anonima,
              p.visible_outside, p.secret_vote, p.proposal_votation_type_id, p.content,
              p.created_at, p.updated_at, p.valutations, p.vote_period_id, p.proposal_comments_count,
              p.rank, p.show_comment_authors, COUNT(*) AS closeness
              FROM proposal_tags pt join proposals p on pt.proposal_id = p.id "

    sql_q += ' left join group_proposals gp on gp.proposal_id = p.id ' if group_id
    sql_q += " WHERE pt.tag_id IN (SELECT pti.tag_id
                                  FROM proposal_tags pti
                                  WHERE pti.proposal_id = #{id})
              AND pt.proposal_id != #{id} "
    sql_q += ' AND (p.private = false OR p.visible_outside = true '
    sql_q += group_id ? " OR (p.private = true AND gp.group_id = #{group_id}))" : ')'
    sql_q += " GROUP BY p.id, p.proposal_state_id, p.proposal_category_id, p.title, p.quorum_id, p.anonima,
               p.visible_outside, p.secret_vote, p.proposal_votation_type_id, p.content,
               p.created_at, p.updated_at, p.valutations, p.vote_period_id, p.proposal_comments_count,
               p.rank, p.show_comment_authors
               ORDER BY closeness DESC limit 10"
    Proposal.find_by_sql(sql_q)
  end

  def user_territory
    user = User.find(update_user_id || current_user_id)
    user.original_locale.territory
  end

  # restituisce la percentuale di avanzamento della proposta in base al quorum assegnato
  def calculate_percentage
    return unless quorum

    @percentage = quorum.debate_progress
  end

  def percentage
    @percentage ||= calculate_percentage
  end

  def users_j
    is_anonima? ?
        proposal_nicknames.where(user_id: user_ids).as_json(only: [:nickname]) :
        users.as_json(only: [:id], methods: [:fullname])
  end

  # check if we have to close the debate and pass to votation phase
  # accept a force parameter to close the debate in any case
  def check_phase(force_end = false)
    quorum.check_phase(force_end) if in_valutation? # if the proposal already passed this phase skip this check
  end

  def close_vote_phase
    quorum.close_vote_phase if voting?
  end

  def abandon
    return unless in_valutation?

    logger.info "Abandoning proposal #{id}"
    self.proposal_state_id = ProposalState::ABANDONED
    life = proposal_lives.build(quorum: quorum,
                                valutations: valutations,
                                rank: rank,
                                seq: ((proposal_lives.maximum(:seq) || 0) + 1))

    # save old authors
    users.each { |user| life.users << user }
    # delete old data
    self.valutations = 0
    self.rank = 0

    NotificationProposalAbandoned.perform_in(1.minute, id, participants.map(&:id))
    # and authors
    proposal_presentations.destroy_all

    # and rankings
    rankings.destroy_all

    save!

    # remove the timer if is still there
    # if self.minutes #todo remove jobs
    #  Resque.remove_delayed(ProposalsWorker, {action: ProposalsWorker::ENDTIME, proposal_id: proposal.id})
    # end
  end

  # put the proposal back in debate from abandoned
  def regenerate(params)
    self.proposal_state_id = ProposalState::VALUTATION
    user = User.find(current_user_id)
    users << user
    update(params)
    assign_quorum

    ProposalNickname.generate(user, self)

    # if the time is fixed we schedule notifications 24h and 1h before the end of debate
    if quorum.time_fixed?
      if quorum.minutes > 1440
        ProposalsWorker.perform_at(quorum.ends_at - 24.hours,
                                   action: ProposalsWorker::LEFT24, proposal_id: id)
      end
      if quorum.minutes > 60
        ProposalsWorker.perform_at(quorum.ends_at - 1.hour,
                                   action: ProposalsWorker::LEFT1, proposal_id: id)
      end
    end
  end

  def start_votation
    return if voting?

    self.proposal_state_id = ProposalState::VOTING
    save!
    unless vote # TODO: non è possibile che esistano già
      vote_data = ProposalVote.new(proposal_id: id, positive: 0, negative: 0, neutral: 0)
      vote_data.save!
    end

    NotificationProposalVoteStarts.perform_async(id, groups.first.try(:id), presentation_areas.first.try(:id))

    if (vote_period.duration / 60) > 1440
      ProposalsWorker.
        perform_at(vote_period.endtime - 24.hours,
                   action: ProposalsWorker::LEFT24VOTE, proposal_id: id)
    end
    if (vote_period.duration / 60) > 60
      ProposalsWorker.
        perform_at(vote_period.endtime - 1.hour,
                   action: ProposalsWorker::LEFT1VOTE, proposal_id: id)
    end
  end

  def set_votation_date(vote_period_id)
    vote_period = Event.find(vote_period_id)
    raise StandardError unless vote_period.starttime > 5.seconds.from_now # security check

    self.vote_period_id = vote_period_id
    self.proposal_state_id = ProposalState::WAIT
    save!
  end

  def user_avatar_url(user)
    if !is_anonima?
      user.user_image_url(24)
    else
      proposal_nickname = proposal_nicknames.find_by(user_id: user.id)
      if proposal_nickname.present?
        proposal_nickname.avatar(24)
      else
        user.user_image_url(24)
      end
    end
  end

  def generate_short_content
    section = sections.first || solutions.first.sections.first
    truncate_words(section.paragraphs.first.content.gsub(%r{</?[^>]+?>}, ''), 40)
  rescue StandardError
    nil
  end

  def derived_countries_tokens
    derived_interest_borders_tokens.select { |ib| ib.starts_with? InterestBorder::SHORT_COUNTRY }
  end

  def derived_continents_tokens
    derived_interest_borders_tokens.select { |ib| ib.starts_with? InterestBorder::SHORT_CONTINENT }
  end

  private

  def destroy_presentations
    proposal_presentations.destroy_all
  end

  def update_short_content
    self.short_content = generate_short_content
  end

  def truncate_words(text, length = 30, end_string = ' ...')
    words = text.split
    words[0..(length - 1)].join(' ') + (words.length > length ? end_string : '')
  end

  def join_users_table(table)
    users = User.arel_table
    users.
      join(table).on(users[:id].eq(table[:user_id])).
      where(table[:proposal_id].eq(id)).
      project(users[:id])
  end

  def before_update_populate
    self.update_user_id = current_user_id
    save_history
    update_borders
    assign_quorum if quorum_id_changed?
  end

  def before_create_populate
    return unless quorum

    group = group_proposals.first.try(:group)

    update_borders

    current_user = User.find(current_user_id)
    proposal_presentations.build(user: current_user)
    # per sicurezza reimposto questi parametri
    if group
      unless group.change_advanced_options
        self.anonima = group.default_anonima
        self.visible_outside = group.default_visible_outside
        self.secret_vote = group.default_secret_vote
      end
      self.private = true

      group_area = GroupArea.find(group_area_id) if group_area_id.present?
      if group_area # check user permissions for this group area
        errors.add(:group_area_id, I18n.t('permissions_required')) if current_user.cannot? :insert_proposal, group_area
        self.area_private = true
        presentation_areas << group_area
      end

      topic = group.topics.find(topic_id) if topic_id.present?
      topic_proposals.build(topic_id: topic.id, user_id: current_user_id) if topic
    end

    # we don't use quorum for petitions
    if is_petition?
      self.proposal_state_id = petition_phase == 'signatures' ? ProposalState::VOTING : ProposalState::VALUTATION
      build_vote(positive: 0, negative: 0, neutral: 0)
    else
      assign_quorum

      self.proposal_state_id = ProposalState::VALUTATION
      self.rank = 0
    end
  end

  def send_notifications
    return if is_petition?

    # if the time is fixed we schedule notifications 24h and 1h before the end of debate
    if quorum.time_fixed?
      if quorum.minutes > 1440
        ProposalsWorker.perform_at(quorum.ends_at - 24.hours,
                                   action: ProposalsWorker::LEFT24, proposal_id: id)
      end
      if quorum.minutes > 60
        ProposalsWorker.perform_at(quorum.ends_at - 1.hour,
                                   action: ProposalsWorker::LEFT1, proposal_id: id)
      end
    end

    # end of debate timer
    ProposalsWorker.perform_at(quorum.ends_at, action: ProposalsWorker::ENDTIME, proposal_id: id) if quorum.minutes

    # alert users of the new proposal
    NotificationProposalCreate.perform_async(id)
  end

  def send_update_notifications
    if quorum_id_changed? # regenerated
      ProposalsWorker.perform_at(quorum.ends_at, action: ProposalsWorker::ENDTIME, proposal_id: id)
    elsif current_user_id # updated or set votation date
      if waiting? # someone chose votation date
        NotificationProposalWaitingForDate.perform_async(id, current_user_id)
      else # standard update
        NotificationProposalUpdate.perform_async(current_user_id, id, groups.first.try(:id))
      end
    end
  end

  def save_section_history(revision, section)
    paragraph = section.paragraphs.first
    paragraph.content = '' if paragraph.content == '<p></p>' && paragraph.content_was == ''
    return false unless paragraph.content_changed? || section.marked_for_destruction?

    section_history = revision.section_histories.build(section_id: section.id,
                                                       title: section.title,
                                                       seq: section.seq,
                                                       added: section.new_record?,
                                                       removed: section.marked_for_destruction?)
    section_history.paragraphs.build(content: paragraph.content_dirty, seq: 1, proposal_id: id)
    true
  end

  def save_sections_history(revision)
    something = false
    sections.each do |section|
      something = true if save_section_history(revision, section)
    end
    something
  end

  def save_solutions_history(revision)
    something_solution = false
    solutions.each do |solution|
      solution_history = revision.solution_histories.build(seq: solution.seq,
                                                           title: solution.title,
                                                           added: solution.new_record?,
                                                           removed: solution.marked_for_destruction?)
      something_solution = solution.title_changed? || solution.marked_for_destruction?
      solution.sections.each do |section|
        paragraph = section.paragraphs.first
        paragraph.content = '' if paragraph.content == '<p></p>' && paragraph.content_was == ''
        next unless paragraph.content_changed? || section.marked_for_destruction? || solution.marked_for_destruction?

        something_solution = true
        section_history = solution_history.section_histories.build(section_id: section.id,
                                                                   title: section.title,
                                                                   seq: section.seq,
                                                                   added: section.new_record?,
                                                                   removed: (section.marked_for_destruction? ||
                                                                       solution.marked_for_destruction?))
        section_history.paragraphs.build(content: paragraph.content_dirty, seq: 1, proposal_id: id)
      end
      solution_history.destroy unless something_solution
    end
    something_solution
  end

  def save_history
    something = false
    seq = (proposal_revisions.maximum(:seq) || 0) + 1
    revision = proposal_revisions.build(user_id: update_user_id, valutations: valutations_was, rank: rank_was, seq: seq)
    something_sections = save_sections_history(revision)
    something_solutions = save_solutions_history(revision)
    something = something_sections || something_solutions
    if something
      comment_ids = ProposalComment.where(id: integrated_contributes_ids, parent_proposal_comment_id: nil).pluck(:id)
      ProposalComment.where(id: comment_ids).update_all(integrated: true)
      revision.contribute_ids = comment_ids
      self.updated_at = Time.zone.now
    else
      revision.destroy
    end
  end

  def update_borders
    proposal_borders.destroy_all

    # set the interest border and extracts the derived ones
    interest_borders_tkn.to_s.split(',').each do |border| # the identifiers are in the format 'X-id'
      found = InterestBorder.table_element(border)

      next unless found # if I found something I can proceed

      interest_borders_tokens << border
      derived_row = found
      while derived_row
        self.derived_interest_borders_tokens |= [InterestBorder.to_key(derived_row)]
        derived_row = derived_row.parent
      end

      proposal_borders.build(interest_border_id: InterestBorder.find_or_create_by_key(border).id)
    end

    if derived_interest_borders_tokens.empty?
      if group.present?
        if group.interest_border.country.present?
          interest_borders_tokens << InterestBorder.to_key(group.interest_border.country)
          self.derived_interest_borders_tokens << InterestBorder.to_key(group.interest_border.country)
          self.derived_interest_borders_tokens << InterestBorder.to_key(group.interest_border.continent)
        end
      else
        if user_territory.present?
          derived_row = user_territory
          interest_borders_tokens << InterestBorder.to_key(derived_row)
          while derived_row
            self.derived_interest_borders_tokens |= [InterestBorder.to_key(derived_row)]
            derived_row = derived_row.parent
          end
        end
      end
    end
  end

  def assign_quorum
    group = group_proposals.first.try(:group)
    group_area = GroupArea.find(group_area_id) if group_area_id.present?
    copy = quorum.dup # make a copy of the assigned quorum and work on it
    starttime = Time.zone.now
    # the quorum has minutes defined. calculate started_at and ends_at using these minutes
    copy.started_at = starttime
    if quorum.minutes
      endtime = starttime + quorum.minutes.minutes
      copy.ends_at = endtime
    end

    # TODO: move quorum build in quorum model
    base_valutations = 0
    base_vote_valutations = 0
    if group_area # we have to calculate the number of valutations based on group area participants
      base_valutations = group_area.scoped_participants(:participate_proposals).count.to_f
      base_vote_valutations = group_area.scoped_participants(:vote_proposals).count.to_f
    elsif group # we have to calculate the number of valutations based on group participants
      base_valutations = group.scoped_participants(:participate_proposals).count.to_f
      base_vote_valutations = group.scoped_participants(:vote_proposals).count.to_f
    else # we calculate the number of valutations based on application users number
      base_vote_valutations = base_valutations = User.count_active
    end
    copy.valutations = ((quorum.percentage.to_f * base_valutations) / 100).floor
    # TODO: we must calculate it before votation because there can be new users in the meantime
    copy.vote_valutations = ((quorum.vote_percentage.to_f * base_vote_valutations) / 100).floor

    # always add 1 and at least 1.
    copy.valutations = copy.valutations + 1
    copy.vote_valutations = copy.vote_valutations + 1

    copy.public = false # assigned quorum are never public
    copy.assigned = true
    copy.save
    self.quorum_id = copy.id # replace the quorum with the copy

    # if is time fixed you can choose immediatly vote period
    return unless copy.time_fixed?

    # if the user chose it
    if votation && (votation[:later] != 'true')
      # if he took a vote period already existing
      if (votation[:choise] && (votation[:choise] == 'preset')) ||
          (!votation[:choise] && votation[:vote_period_id].present?)
        self.vote_event = Event.find(votation[:vote_period_id])
        # if the vote period start before the end of debate there is an error
        errors.add(:base, I18n.t('error.proposals.vote_period_incorrect')) if vote_event.starttime < Time.zone.now + copy.minutes.minutes + DEBATE_VOTE_DIFFERENCE
      else # if he created a new period
        # look if he edited the starttime or not
        start = (votation[:start_edited].present? && votation[:start]) || (copy.ends_at + DEBATE_VOTE_DIFFERENCE)
        raise Exception 'error' if votation[:end].blank?

        self.vote_starts_at = start
        self.vote_ends_at = votation[:end]
        errors.add(:base, I18n.t('error.proposals.vote_period_soon', time: DEBATE_VOTE_DIFFERENCE.to_i / 60)) if (vote_starts_at - copy.ends_at) < DEBATE_VOTE_DIFFERENCE
        errors.add(:base, I18n.t('error.proposals.vote_period_short')) if vote_ends_at < (vote_starts_at + 10.minutes)
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
