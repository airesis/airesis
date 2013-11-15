module ProposalsModule
  include GroupsHelper, NotificationHelper, ProposalsHelper


  #check if we have to close the dabate and pass to votation phase
  #accept to parameters: the proposal and a force end parameter to close the debate in any case
  def check_phase(proposal, force_end=false)
    return unless proposal.in_valutation? #if the proposal already passed this phase skip this check
    quorum = proposal.quorum
    passed = false
    timepassed = (!quorum.ends_at || Time.now > quorum.ends_at)
    vpassed = (!quorum.valutations || proposal.valutations >= quorum.valutations)
                                          #if both parameters were defined
    if quorum.ends_at && quorum.valutations
      if quorum.or?
        passed = (timepassed || vpassed)
      else
        quorum.and?
        passed = (timepassed && vpassed)
      end
    else #we just need one of two (one will be certainly true)
      passed = (timepassed && vpassed)
    end
    passed = passed || force_end #maybe we want to force the end of the proposal

    if passed #if we have to move one
      if proposal.rank >= quorum.good_score #and we passed the debate quorum
        if proposal.vote_defined #the user already choosed the votation period! that's great, we can just sit along the river waiting for it to begin
          proposal.proposal_state_id = ProposalState::WAIT
          #automatically create
          if proposal.vote_event_id
            @event = Event.find(proposal.vote_event_id)
          else
            event_p = {
                event_type_id: EventType::VOTAZIONE,
                title: "Votazione #{proposal.title}",
                starttime: proposal.vote_starts_at,
                endtime: proposal.vote_ends_at,
                description: "Votazione #{proposal.title}"
            }
            if proposal.private?
              @event = proposal.presentation_groups.first.events.create!(event_p)
            else
              @event = Event.create!(event_p)
            end

            #fai partire il timer per far scadere la proposta
            Resque.enqueue_at(@event.starttime, EventsWorker, {:action => EventsWorker::STARTVOTATION, :event_id => @event.id})
            Resque.enqueue_at(@event.endtime, EventsWorker, {:action => EventsWorker::ENDVOTATION, :event_id => @event.id})
          end
          proposal.vote_period = @event
        else
          proposal.proposal_state_id = ProposalState::WAIT_DATE #we passed the debate, we are now waiting for someone to choose the vote date
          proposal.private? ?
              notify_proposal_ready_for_vote(proposal, proposal.presentation_groups.first) :
              notify_proposal_ready_for_vote(proposal)

        end

        #remove the timer if is still there
        if quorum.minutes
          Resque.remove_delayed(ProposalsWorker, {:action => ProposalsWorker::ENDTIME, :proposal_id => proposal.id})
        end
      elsif proposal.rank < quorum.bad_score #if we have not passed the debate quorum abandon it
        abandon(proposal)

        proposal.private? ?
            notify_proposal_abandoned(proposal, proposal.presentation_groups.first) :
            notify_proposal_abandoned(proposal)

        #remove the timer if is still there
        if quorum.minutes
          Resque.remove_delayed(ProposalsWorker, {:action => ProposalsWorker::ENDTIME, :proposal_id => proposal.id})
        end
      else #if we are between bad and good score just do nothing...continue the debate

      end

      proposal.save
      proposal.reload
    end
  end


  def close_vote_phase(proposal)
    if proposal.is_schulze?
      vote_data_schulze = proposal.schulze_votes
      Proposal.transaction do
        votesstring = ""; #stringa da passare alla libreria schulze_vote per calcolare il punteggio
        vote_data_schulze.each do |vote|
          #in ogni riga inserisco la mappa del voto ed eventualmente il numero se più di un utente ha espresso la stessa preferenza
          vote.count > 1 ? votesstring += "#{vote.count}=#{vote.preferences}\n" : votesstring += "#{vote.preferences}\n"
        end
        num_solutions = proposal.solutions.count
        vs = SchulzeBasic.do votesstring, num_solutions
        solutions_sorted = proposal.solutions.sort { |a, b| a.id <=> b.id } #ordino le soluzioni secondo l'id crescente (così come vengono restituiti dalla libreria)
        solutions_sorted.each_with_index do |c, i|
          c.schulze_score = vs.ranks[i].to_i
          c.save!
        end
        proposal.proposal_state_id = ProposalState::ACCEPTED
      end #fine transazione
    else
      vote_data = proposal.vote
      positive = vote_data.positive
      negative = vote_data.negative
      neutral = vote_data.neutral
      votes = positive + negative + neutral
      if positive > negative #se ha avuto più voti positivi allora diventa ACCETTATA
        proposal.proposal_state_id = ProposalState::ACCEPTED
      elsif positive <= negative #se ne ha di più negativi allora diventa RESPINTA
        proposal.proposal_state_id = ProposalState::REJECTED
      end
    end
    proposal.save!
    proposal.private ?
        notify_proposal_voted(proposal, proposal.presentation_groups.first, proposal.presentation_areas.first) :
        notify_proposal_voted(proposal)
  end


  def abandon(proposal)
    proposal.proposal_state_id = ProposalState::ABANDONED
    life = proposal.proposal_lives.create(quorum_id: proposal.quorum_id, valutations: proposal.valutations, rank: proposal.rank, seq: ((proposal.proposal_lives.maximum(:seq) || 0) + 1))
    #save old authors
    proposal.users.each do |user|
      life.users << user
    end
    life.save!
    #delete old data
    proposal.valutations = 0
    proposal.rank = 0
    #proposal.quorum_id = nil

    #and authors
    proposal.proposal_presentations.destroy_all
    proposal.rankings.destroy_all
    #proposal.save!
  end

  def simple_new(proposal)
    @problems = proposal.sections.build(title: t('pages.proposals.new.simple.problems_title'), seq: 1)
    @problems.paragraphs.build(content: '', seq: 1)
    proposal.proposal_type = ProposalType.find_by_name(ProposalType::SIMPLE)
    proposal.proposal_votation_type_id = ProposalVotationType::STANDARD
  end

  def standard_new(proposal)
    @problems = proposal.sections.build(title: t('pages.proposals.new.standard.problems_title'), seq: 1)
    @problems.paragraphs.build(content: '', seq: 1)
    proposal.proposal_type = ProposalType.find_by_name(ProposalType::STANDARD)
    proposal.proposal_votation_type_id = ProposalVotationType::STANDARD
  end


  def simple_create(proposal)
    seq = 1
    solution = simple_solution
    solution.seq = 1
    proposal.solutions << solution
  end

  def standard_create(proposal)
    seq = 1
    proposal.sections.build(title: 'Esperienze simili', seq: seq+=1).paragraphs.build(content: '', seq: 1) #TODO:I18n
    proposal.sections.build(title: 'Stakeholders (persone coinvolte)', seq: seq+=1).paragraphs.build(content: '', seq: 1)
    proposal.sections.build(title: 'Requisiti della soluzione', seq: seq+=1).paragraphs.build(content: '', seq: 1)

    solution = standard_solution
    solution.seq = 1
    proposal.solutions << solution
  end

  def agenda_new(proposal)
    @problems = proposal.sections.build(title: t('pages.proposals.new.agenda.problems_title'), seq: 1)
    @problems.paragraphs.build(content: '', seq: 1)
    proposal.proposal_type = ProposalType.find_by_name(ProposalType::AGENDA)
    proposal.proposal_votation_type_id = ProposalVotationType::STANDARD
  end

  def agenda_create(proposal)
    seq = 1
    proposal.sections.build(title: t('pages.proposals.new.agenda.paragraph.date_time'), seq: seq+=1).paragraphs.build(content: '', seq: 1)
    proposal.sections.build(title: t('pages.proposals.new.agenda.paragraph.place'), seq: seq+=1).paragraphs.build(content: '', seq: 1)

    solution = agenda_solution
    solution.seq = 1
    proposal.solutions << solution
  end

  def estimate_new(proposal)
    @problems = proposal.sections.build(title: t('pages.proposals.new.estimate.problems_title'), seq: 1)
    @problems.paragraphs.build(content: '', seq: 1)
    proposal.proposal_type = ProposalType.find_by_name(ProposalType::ESTIMATE)
    proposal.proposal_votation_type_id = ProposalVotationType::STANDARD
  end

  def estimate_create(proposal)
    seq = 1
    proposal.sections.build(title: t('pages.proposals.new.estimate.paragraph.technical_constrains'), seq: seq+=1).paragraphs.build(content: '', seq: 1)
    proposal.sections.build(title: t('pages.proposals.new.estimate.paragraph.temporal_constrains'), seq: seq+=1).paragraphs.build(content: '', seq: 1)
    proposal.sections.build(title: t('pages.proposals.new.estimate.paragraph.other_constrains'), seq: seq+=1).paragraphs.build(content: '', seq: 1)
    proposal.sections.build(title: t('pages.proposals.new.estimate.paragraph.budget'), seq: seq+=1).paragraphs.build(content: '', seq: 1)
    proposal.sections.build(title: t('pages.proposals.new.estimate.paragraph.recipient_budget'), seq: seq+=1).paragraphs.build(content: '', seq: 1)

    solution = estimate_solution
    solution.seq = 1
    proposal.solutions << solution
  end

  def event_new(proposal)
    @problems = proposal.sections.build(title: t('pages.proposals.new.event.problems_title'), seq: 1)
    @problems.paragraphs.build(content: '', seq: 1)
    proposal.proposal_type = ProposalType.find_by_name(ProposalType::EVENT)
    proposal.proposal_votation_type_id = ProposalVotationType::STANDARD
  end


  def event_create(proposal)
    seq = 1
    proposal.sections.build(title: t('pages.proposals.new.event.paragraph.similar_experiences'), seq: seq+=1).paragraphs.build(content: '', seq: 1)
    proposal.sections.build(title: t('pages.proposals.new.event.paragraph.stakeholders'), seq: seq+=1).paragraphs.build(content: '', seq: 1)
    proposal.sections.build(title: t('pages.proposals.new.event.paragraph.desired_characteristics'), seq: seq+=1).paragraphs.build(content: '', seq: 1)

    solution = event_solution
    solution.seq = 1
    proposal.solutions << solution
  end

  def press_new(proposal)
    @problems = proposal.sections.build(title: t('pages.proposals.new.press.problems_title'), seq: 1)
    @problems.paragraphs.build(content: '', seq: 1)
    proposal.proposal_type = ProposalType.find_by_name(ProposalType::PRESS)
    proposal.proposal_votation_type_id = ProposalVotationType::STANDARD
  end

  def press_create(proposal)
    seq = 1
    proposal.sections.build(title: t('pages.proposals.new.press.paragraph.target'), seq: seq+=1).paragraphs.build(content: '', seq: 1)

    solution = press_solution
    solution.seq = 1
    proposal.solutions << solution
  end


  def rule_book_new(proposal)
    @problems = proposal.sections.build(title: t('pages.proposals.new.rule_book.problems_title'), seq: 1)
    @problems.paragraphs.build(content: '', seq: 1)

    proposal.proposal_type = ProposalType.find_by_name(ProposalType::RULE_BOOK)
    proposal.proposal_votation_type_id = ProposalVotationType::STANDARD
  end

  def rule_book_create(proposal)
    seq = 1
    proposal.sections.build(title: t('pages.proposals.new.rule_book.paragraph.inspire'), seq: seq+=1).paragraphs.build(content: '', seq: 1)
    proposal.sections.build(title: t('pages.proposals.new.rule_book.stakeholders'), seq: seq+=1).paragraphs.build(content: '', seq: 1)
    proposal.sections.build(title: t('pages.proposals.new.rule_book.paragraph.requirements'), seq: seq+=1).paragraphs.build(content: '', seq: 1)

    solution = rule_book_solution
    solution.seq = 1
    proposal.solutions << solution
  end


  def poll_new(proposal)
    @text = proposal.sections.build(title: 'Testo del sondaggio', seq: 1)
    @solution_a = proposal.solutions.build(seq: 1)
    @solution_b = proposal.solutions.build(seq: 2)
    @solution_c = proposal.solutions.build(seq: 3)
    proposal.proposal_type_id = ProposalType::POLL
    proposal.proposal_votation_type_id = ProposalVotationType::SCHULZE

    @solution_a_section = @solution_a.sections.build(title: 'Opzione 1', seq: 1)
    @solution_b_section = @solution_b.sections.build(title: 'Opzione 2', seq: 1)
    @solution_c_section = @solution_c.sections.build(title: 'Opzione 3', seq: 1)
  end


  def candidates_new(proposal)
    @problems = proposal.sections.build(title: t('pages.proposals.new.candidates.paragraph.role'), seq: 1)
    @problems.paragraphs.build(content: '', seq: 1)
  end

  def candidates_create(proposal)
    seq = 1
    proposal.sections.build(title: t('pages.proposals.new.candidates.paragraph.requirements'), seq: seq+1).paragraphs.build(content: '', seq: 1)
    solution = candidates_solution
    solution.seq = 1
    proposal.solutions << solution
  end
end
