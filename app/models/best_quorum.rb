#encoding: utf-8
class BestQuorum < Quorum

  validates :minutes, numericality: {only_integer: true, greater_than_or_equal_to: 5}
  attr_accessor :vote_days_m, :vote_hours_m, :vote_minutes_m

  before_save :populate_vote

  before_update :populate_vote!

  after_find :populate_accessor

  def valutations
    (read_attribute :valutations) || 1
  end

  def populate_accessor
    super
    self.vote_minutes_m = vote_minutes
    return unless vote_minutes_m
    return unless vote_minutes_m > 59
    self.vote_hours_m = vote_minutes_m/60
    self.vote_minutes_m = vote_minutes_m%60
    return unless vote_hours_m > 23
    self.vote_days_m = vote_hours_m/24
    self.vote_hours_m = vote_hours_m%24
  end


  #se i minuti non vengono definiti direttamente (come in caso di copia) allora calcolali dai dati di input
  def populate_vote
    unless self.vote_minutes
      self.vote_minutes = vote_minutes_m.to_i + (vote_hours_m.to_i * 60) + (vote_days_m.to_i * 24 * 60)
      self.vote_minutes = nil if (vote_minutes == 0)
    end
    self.bad_score = good_score
  end

  def populate_vote!
    self.vote_minutes = vote_minutes_m.to_i + (vote_hours_m.to_i * 60) + (vote_days_m.to_i * 24 * 60)
    self.vote_minutes = nil if (vote_minutes == 0)
  end

  def or?
    raise Exception
  end

  def and?
    raise Exception
  end

  def time_fixed?
    true #new quora are all time fixed
  end

  def vote_time_set?
    self.t_vote_minutes == 's'
  end

  def vote_time_free?
    self.t_vote_minutes == 'f'
  end

  #text to show in the stop cursor of rank bar
  def end_desc
    I18n.l ends_at
  end


  #short description of time left to show in the rank bar and proposals list
  def time_left
    amount = ends_at - Time.now #left in seconds
    if amount > 0
      left = I18n.t('time.left.seconds', count: amount.to_i)
      if amount >= 60 #if more or equal than 60 seconds left give me minutes
        amount_min = amount/60
        left = I18n.t('time.left.minutes', count: amount_min.to_i)
        if amount_min >= 60 #if more or equal than 60 minutes left give me hours
          amount_hour = amount_min/60
          left = I18n.t('time.left.hours', count: amount_hour.to_i)
          if amount_hour > 24 #if more than 24 hours left give me days
            amount_days = amount_hour/24
            left = I18n.t('time.left.days', count: amount_days.to_i)
          end
        end
      end
      left.upcase
    else
      "STALLED" #todo:i18n
    end
  end

  #show the total time of votation
  def vote_time
    case t_vote_minutes
      when 'f'
        'free' #TODO:I18n
      when 's'
        min = vote_minutes if vote_minutes

        if min && min > 0
          if min > 59
            hours = min/60
            min = min%60
            if hours > 23
              days = hours/24
              hours = hours%24
              min = 0 if hours != 0
              if days > 30
                months = days/30
                days = days%30
                min = 0
              end
            end
          end
          ar = []
          ar << I18n.t('time.left.months', count: months) if (months && months > 0)
          ar << I18n.t('time.left.days', count: days) if (days && days > 0)
          ar << I18n.t('time.left.hours', count: hours) if (hours && hours > 0)
          ar << I18n.t('time.left.minutes', count: min) if (min && min > 0)
          retstr = ar.join(" #{I18n.t('words.and')} ")
        else
          retstr = nil
        end
        retstr
      when 'r'
        'ranged'
      else

    end

  end

  def check_phase(force_end=false)
    return unless force_end || (Time.now > ends_at) #skip if we have not passed the time yet

    vpassed = !valutations || (proposal.valutations >= valutations)
    if (proposal.rank >= good_score) && vpassed #and we passed the debate quorum
      if proposal.vote_defined #the user already chose the votation period! that's great, we can just sit along the river waiting for it to begin
        proposal.proposal_state_id = ProposalState::WAIT
        #automatically create
        if proposal.vote_event_id
          @event = Event.find(proposal.vote_event_id)
        else
          event_p = {
              event_type_id: EventType::VOTAZIONE,
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

          #fai partire il timer per far scadere la proposta
          EventsWorker.perform_at(@event.starttime, {action: EventsWorker::STARTVOTATION, event_id: @event.id})
          EventsWorker.perform_at(@event.endtime, {action: EventsWorker::ENDVOTATION, event_id: @event.id})
        end
        proposal.vote_period = @event
      else
        proposal.proposal_state_id = ProposalState::WAIT_DATE #we passed the debate, we are now waiting for someone to choose the vote date
        NotificationProposalReadyForVote.perform_async(proposal.id)
      end
      proposal.save
      #remove the timer if is still there
      #Resque.remove_delayed(ProposalsWorker, {action: ProposalsWorker::ENDTIME, proposal_id: proposal.id}) if minutes #TODO remove job
    else
      proposal.abandon
    end
    proposal.reload
  end

  def close_vote_phase
    if proposal.is_schulze?
      vote_data_schulze = proposal.schulze_votes
      Proposal.transaction do
        votesstring = ""; #this is the string to pass to schulze library to calculate the score
        vote_data_schulze.each do |vote|
          #each row is composed by the vote string and, if more then one, the number of votes of that kind
          vote.count > 1 ? votesstring += "#{vote.count}=#{vote.preferences}\n" : votesstring += "#{vote.preferences}\n"
        end
        num_solutions = proposal.solutions.count
        vs = SchulzeBasic.do votesstring, num_solutions
        solutions_sorted = proposal.solutions.sort { |a, b| a.id <=> b.id } #order the solutions by the id (as the plugin output the results)
        solutions_sorted.each_with_index do |c, i|
          c.schulze_score = vs.ranks[i].to_i #save the result in the solution
          c.save!
        end
        votes = proposal.schulze_votes.sum(:count)
        proposal.proposal_state_id = (votes >= vote_valutations) ? ProposalState::ACCEPTED : ProposalState::REJECTED
      end #end of transaction
    else
      vote_data = proposal.vote
      positive = vote_data.positive
      negative = vote_data.negative
      neutral = vote_data.neutral
      votes = positive + negative + neutral
      if ((positive+negative) > 0) && ((positive.to_f / (positive+negative).to_f) > (vote_good_score.to_f / 100)) && (votes >= vote_valutations) #se ha avuto più voti positivi allora diventa ACCETTATA
        proposal.proposal_state_id = ProposalState::ACCEPTED
      else #se ne ha di più negativi allora diventa RESPINTA
        proposal.proposal_state_id = ProposalState::REJECTED
      end
    end
    proposal.save!
    NotificationProposalVoteClosed.perform_async(proposal.id)
  end


  def has_bad_score?
    false #new quora does not have bad score
  end


  def debate_progress
    minimum = [Time.now, self.ends_at].min
    minimum = ((minimum - self.started_at)/60)
    percentagetime = minimum.to_f/self.minutes.to_f
    percentagetime *= 100
  end

  protected

  def min_participants_pop
    return 1 unless percentage

    count = 1
    if group
      count = (percentage.to_f * 0.01 * group.scoped_participants(GroupAction::PROPOSAL_PARTICIPATION).count) #todo group areas
    else
      count = (percentage.to_f * 0.001 * User.count)
    end
    [count, 1].max.floor + 1 #we always add +1 in new quora
  end

  def min_vote_participants_pop
    return 1 unless vote_percentage

    count = 1
    if group
      count = (vote_percentage.to_f * 0.01 * group.scoped_participants(GroupAction::PROPOSAL_VOTE).count) #todo group areas
    else
      count = (vote_percentage.to_f * 0.001 * User.count)
    end
    [count, 1].max.floor + 1 #we always add +1 in new quora
  end

  def explanation_pop
    conditions = []
    ret = ''
    if assigned? #explain a quorum assigned to a proposal
      if proposal_life.present? || proposal.abandoned?
        ret = terminated_explanation_pop
      else
        ret = assigned_explanation_pop
      end
    else
      ret = unassigned_explanation_pop #it a non assigned quorum
    end

    ret += "."
    ret.html_safe
  end


  #TODO we need to refactor this part of code but at least now is more clear
  #explain a quorum when assigned to a proposal in it's current state
  def assigned_explanation_pop
    ret = ''
    time = "<b>#{self.time}</b> "
    time +=I18n.t('models.quorum.until_date', date: I18n.l(self.ends_at))
    ret = I18n.translate('models.quorum.time_condition_1', time: time) #display the time left for discussion
    ret += "<br/>"
    participants = I18n.t('models.quorum.participants', count: self.valutations)
    ret += I18n.translate('models.best_quorum.good_score_condition', good_score: self.good_score, participants: participants)
    ret
  end

  #explain a quorum in a proposal that has terminated her life cycle
  def terminated_explanation_pop
    ret = ''
    time = "<b>#{self.time(true)}</b> " #show total time if the quorum is terminated
    time +=I18n.t('models.quorum.until_date', date: I18n.l(self.ends_at))
    ret = I18n.translate('models.quorum.time_condition_1_past', time: time) #display the time left for discussion
    ret += "<br/>"
    participants = I18n.t('models.quorum.participants_past', count: self.valutations)
    ret += I18n.translate('models.best_quorum.good_score_condition_past', good_score: self.good_score, participants: participants)
    ret
  end

  #explain a non assigned quorum
  def unassigned_explanation_pop
    ret = ''
    time = "<b>#{self.time}</b> "
    ret = I18n.translate('models.quorum.time_condition_1', time: time) #display the time left for discussion
    ret += "<br/>"
    participants = I18n.t('models.quorum.participants', count: self.min_participants)
    ret += I18n.translate('models.best_quorum.good_score_condition', good_score: self.good_score, participants: participants)
    ret
  end
end
