class BestQuorum < Quorum
  validates :minutes, numericality: { only_integer: true, greater_than_or_equal_to: 5 }
  attr_accessor :vote_days_m, :vote_hours_m, :vote_minutes_m

  before_save :populate_vote

  before_update :populate_vote!

  after_find :populate_accessor

  def valutations
    (read_attribute :valutations) || 1
  end

  # calculate minutes from user input only if they were not set already
  def populate_vote
    unless vote_minutes
      self.vote_minutes = vote_minutes_m.to_i + (vote_hours_m.to_i * 60) + (vote_days_m.to_i * 24 * 60)
      self.vote_minutes = nil if vote_minutes == 0
    end
    self.bad_score = good_score
  end

  def populate_vote!
    self.vote_minutes = vote_minutes_m.to_i + (vote_hours_m.to_i * 60) + (vote_days_m.to_i * 24 * 60)
    self.vote_minutes = nil if vote_minutes == 0
  end

  def or?
    fail Exception
  end

  def and?
    fail Exception
  end

  def time_fixed?
    true # new quora are all time fixed
  end

  def vote_time_set?
    t_vote_minutes == 's'
  end

  def vote_time_free?
    t_vote_minutes == 'f'
  end

  # text to show in the stop cursor of rank bar
  def end_desc
    I18n.l ends_at
  end

  # short description of time left to show in the rank bar and proposals list
  def time_left
    amount = ends_at - Time.now # left in seconds
    if amount > 0
      left = I18n.t('time.left.seconds', count: amount.to_i)
      if amount >= 60 # if more or equal than 60 seconds left give me minutes
        amount_min = amount / 60
        left = I18n.t('time.left.minutes', count: amount_min.to_i)
        if amount_min >= 60 # if more or equal than 60 minutes left give me hours
          amount_hour = amount_min / 60
          left = I18n.t('time.left.hours', count: amount_hour.to_i)
          if amount_hour > 24 # if more than 24 hours left give me days
            amount_days = amount_hour / 24
            left = I18n.t('time.left.days', count: amount_days.to_i)
          end
        end
      end
      left.upcase
    else
      'STALLED' # TODO: i18n
    end
  end

  # show the total time of votation
  def vote_time
    case t_vote_minutes
    when 'f'
      'free' # TODO: I18n
    when 's'
      min = vote_minutes if vote_minutes

      if min && min > 0
        if min > 59
          hours = min / 60
          min = min % 60
          if hours > 23
            days = hours / 24
            hours = hours % 24
            min = 0 if hours != 0
            if days > 30
              months = days / 30
              days = days % 30
              min = 0
            end
          end
        end
        ar = []
        ar << I18n.t('time.left.months', count: months) if months && months > 0
        ar << I18n.t('time.left.days', count: days) if days && days > 0
        ar << I18n.t('time.left.hours', count: hours) if hours && hours > 0
        ar << I18n.t('time.left.minutes', count: min) if min && min > 0
        retstr = ar.join(" #{I18n.t('words.and')} ")
      else
        retstr = nil
      end
      retstr
    when 'r'
      'ranged'
    end
  end

  def check_phase(force_end = false)
    return unless force_end || (Time.now > ends_at) # skip if we have not passed the time yet

    vpassed = !valutations || (proposal.valutations >= valutations)
    if (proposal.rank >= good_score) && vpassed # and we passed the debate quorum
      if proposal.vote_defined # the user already chose the votation period! that's great, we can just sit along the river waiting for it to begin
        proposal.proposal_state_id = ProposalState::WAIT
        # automatically create
        if proposal.vote_event_id
          @event = Event.find(proposal.vote_event_id)
        else
          event_p = {
            event_type_id: EventType::VOTATION,
            title: "Votation #{proposal.title}",
            starttime: proposal.vote_starts_at,
            endtime: proposal.vote_ends_at,
            description: "Votation #{proposal.title}",
            user: proposal.users.first
          }
          if proposal.private?
            @event = proposal.groups.first.events.create!(event_p)
          else
            @event = Event.create!(event_p)
          end
        end
        proposal.vote_period = @event
      else
        proposal.proposal_state_id = ProposalState::WAIT_DATE # we passed the debate, we are now waiting for someone to choose the vote date
        NotificationProposalReadyForVote.perform_async(proposal.id)
      end
      proposal.save
      # remove the timer if is still there
      # Resque.remove_delayed(ProposalsWorker, {action: ProposalsWorker::ENDTIME, proposal_id: proposal.id}) if minutes #TODO remove job
    else
      proposal.abandon
    end
    proposal.reload
  end

  def exceed_vote_quorum?(votes)
    votes >= vote_valutations
  end

  def exceed_conditions?(vote_data)
    positive_perc = vote_data.positive_perc_over_valuable
    votes = vote_data.number
    vote_data.any_valuable_vote? && (positive_perc > (vote_good_score.to_f / 100)) && exceed_vote_quorum?(votes)
  end

  def close_vote_phase
    if proposal.is_schulze?
      proposal.build_proposal_votation_result(data: SchulzeSolver.new(proposal).calculate)
      votes = proposal.schulze_votes.sum(:count)
      proposal.proposal_state_id = exceed_vote_quorum?(votes) ? ProposalState::ACCEPTED : ProposalState::REJECTED
    else
      vote_data = proposal.vote
      proposal.proposal_state_id = if exceed_conditions?(vote_data)
                                     ProposalState::ACCEPTED
                                   else
                                     ProposalState::REJECTED
                                   end
    end
    proposal.save!
    NotificationProposalVoteClosed.perform_async(proposal.id)
    true
  end

  def debate_progress
    minimum = [Time.now, ends_at].min
    minimum = ((minimum - started_at) / 60)
    percentagetime = minimum.to_f / minutes.to_f
    percentagetime * 100
  end

  protected

  def populate_accessor
    super
    self.vote_minutes_m = vote_minutes
    return unless vote_minutes_m.to_f > 59
    self.vote_hours_m, self.vote_minutes_m = vote_minutes_m.divmod 60
    return unless vote_hours_m > 23
    self.vote_days_m, self.vote_hours_m = vote_hours_m.divmod 24
  end

  def min_participants_pop
    percentage_f = percentage.to_f
    count = if group # TODO: group areas
              percentage_f * 0.01 * group.scoped_participants(GroupAction::PROPOSAL_PARTICIPATION).count
            else
              percentage_f * 0.001 * User.count
            end
    [count, 0].max.floor + 1 # we always add +1 in new quora
  end

  def min_vote_participants_pop
    vote_percentage_f = vote_percentage.to_f
    count = if group # TODO: group areas
              vote_percentage_f * 0.01 * group.scoped_participants(GroupAction::PROPOSAL_VOTE).count
            else
              vote_percentage_f * 0.001 * User.count
            end
    [count, 0].max.floor + 1 # we always add +1 in new quora
  end

  def explanation_pop
    ret = if assigned? # explain a quorum assigned to a proposal
            if proposal_life.present? || proposal.abandoned?
              terminated_explanation_pop
            else
              assigned_explanation_pop
            end
          else
            unassigned_explanation_pop # it a non assigned quorum
          end + '.'
    ret.html_safe
  end

  # TODO: we need to refactor this part of code but at least now is more clear
  # explain a quorum when assigned to a proposal in it's current state
  def assigned_explanation_pop
    time = "<b>#{self.time}</b> "
    time += I18n.t('models.quorum.until_date', date: I18n.l(ends_at))
    ret = I18n.translate('models.quorum.time_condition_1', time: time) # display the time left for discussion
    ret += '<br/>'
    participants = I18n.t('models.quorum.participants', count: valutations)
    ret + I18n.translate('models.best_quorum.good_score_condition', good_score: good_score, participants: participants)
  end

  # explain a quorum in a proposal that has terminated her life cycle
  def terminated_explanation_pop
    time = "<b>#{self.time(true)}</b> " # show total time if the quorum is terminated
    time += I18n.t('models.quorum.until_date', date: I18n.l(ends_at))
    ret = I18n.translate('models.quorum.time_condition_1_past', time: time) # display the time left for discussion
    ret += '<br/>'
    participants = I18n.t('models.quorum.participants_past', count: valutations)
    ret + I18n.translate('models.best_quorum.good_score_condition_past',
                         good_score: good_score, participants: participants)
  end

  # explain a non assigned quorum
  def unassigned_explanation_pop
    time = "<b>#{self.time}</b> "
    ret = I18n.translate('models.quorum.time_condition_1', time: time) # display the time left for discussion
    ret += '<br/>'
    participants = I18n.t('models.quorum.participants', count: min_participants)
    ret + I18n.translate('models.best_quorum.good_score_condition',
                         good_score: good_score, participants: participants)
  end
end
