module ProposalsModule
  include NotificationHelper, ProposalsHelper
  #verifica se è necessario passare alla fase di votazione
  #una proposta attualmente in fase di valutazione e dibattito
  def check_phase(proposal)
    return unless proposal.in_valutation? #if the proposal already passed this phase skip this check
    quorum = proposal.quorum
    passed = false
    timepassed = (!quorum.ends_at || Time.now > quorum.ends_at)
    vpassed = (!quorum.valutations || proposal.valutations >= quorum.valutations)
    #se erano definiti entrambi i parametri
    if quorum.ends_at && quorum.valutations

      if quorum.or?
        passed = (timepassed || vpassed)
      else quorum.and?
        passed = (timepassed && vpassed)
      end
    else #altrimenti era definito solo uno dei due, una delle due variabili
      passed = (timepassed && vpassed)
    end


    if passed
      if proposal.rank >= quorum.good_score
        proposal.proposal_state_id = ProposalState::WAIT_DATE #metti la proposta in attesa di una data per la votazione
        proposal.private? ?
          notify_proposal_ready_for_vote(proposal,proposal.presentation_groups.first) :
          notify_proposal_ready_for_vote(proposal)

        #elimina il timer se vi è ancora associato
        if quorum.minutes
          Resque.remove_delayed(ProposalsWorker, {:action => ProposalsWorker::ENDTIME, :proposal_id => proposal.id})
        end
      elsif proposal.rank < quorum.bad_score
        abandon(proposal)

        proposal.private? ?
          notify_proposal_abandoned(proposal,proposal.presentation_groups.first) :
          notify_proposal_abandoned(proposal)

        #elimina il timer se vi è ancora associato
        if quorum.minutes
          Resque.remove_delayed(ProposalsWorker, {:action => ProposalsWorker::ENDTIME, :proposal_id => proposal.id})
        end
      end

      proposal.save
      proposal.reload
    end
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
    @problems.paragraphs.build(content:'', seq:1)
    proposal.proposal_type = ProposalType.find_by_short_name(ProposalType::SIMPLE)
    proposal.proposal_votation_type_id = ProposalVotationType::STANDARD
  end

  def standard_new(proposal)
    @problems = proposal.sections.build(title: t('pages.proposals.new.standard.problems_title'), seq: 1)
    @problems.paragraphs.build(content:'', seq:1)
    proposal.proposal_type = ProposalType.find_by_short_name(ProposalType::STANDARD)
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
    proposal.sections.build(title: 'Esperienze simili', seq: seq+=1).paragraphs.build(content: '', seq: 1)
    proposal.sections.build(title: 'Stakeholders (persone coinvolte)', seq: seq+=1).paragraphs.build(content: '', seq: 1)
    proposal.sections.build(title: 'Requisiti della soluzione', seq: seq+=1).paragraphs.build(content: '', seq: 1)

    solution = standard_solution
    solution.seq = 1
    proposal.solutions << solution
  end

  def agenda_new(proposal)
    @problems = proposal.sections.build(title: t('pages.proposals.new.agenda.problems_title'), seq: 1)
    @problems.paragraphs.build(content:'', seq:1)
    proposal.proposal_type = ProposalType.find_by_short_name(ProposalType::AGENDA)
    proposal.proposal_votation_type_id = ProposalVotationType::STANDARD
  end

  def agenda_create(proposal)
    seq = 1
    proposal.sections.build(title: 'Data e orario', seq: seq+=1).paragraphs.build(content: '', seq: 1)
    proposal.sections.build(title: 'Luogo', seq: seq+=1).paragraphs.build(content: '', seq: 1)

    solution = agenda_solution
    solution.seq = 1
    proposal.solutions << solution
  end

  def estimate_new(proposal)
    @problems = proposal.sections.build(title: t('pages.proposals.new.estimate.problems_title'), seq: 1)
    @problems.paragraphs.build(content:'', seq:1)
    proposal.proposal_type = ProposalType.find_by_short_name(ProposalType::ESTIMATE)
    proposal.proposal_votation_type_id = ProposalVotationType::STANDARD
  end

  def estimate_create(proposal)
    seq = 1
    proposal.sections.build(title: 'Vincoli tecnici', seq: seq+=1).paragraphs.build(content: '', seq: 1)
    proposal.sections.build(title: 'Vincoli temporali', seq: seq+=1).paragraphs.build(content: '', seq: 1)
    proposal.sections.build(title: 'Vincoli ambientali, etici, normativi', seq: seq+=1).paragraphs.build(content: '', seq: 1)
    proposal.sections.build(title: 'Spesa massima', seq: seq+=1).paragraphs.build(content: '', seq: 1)
    proposal.sections.build(title: 'Destinatari richiesta di preventivo', seq: seq+=1).paragraphs.build(content: '', seq: 1)

    solution = estimate_solution
    solution.seq = 1
    proposal.solutions << solution
  end

  def event_new(proposal)
    @problems = proposal.sections.build(title: t('pages.proposals.new.event.problems_title'), seq: 1)
    @problems.paragraphs.build(content:'', seq:1)
    proposal.proposal_type = ProposalType.find_by_short_name(ProposalType::EVENT)
    proposal.proposal_votation_type_id = ProposalVotationType::STANDARD
  end


  def event_create(proposal)
    seq = 1
    proposal.sections.build(title: 'Esperienze simili', seq: seq+=1).paragraphs.build(content:'', seq:1)
    proposal.sections.build(title: 'Stakeholders (persone coinvolte)', seq: seq+=1).paragraphs.build(content:'', seq:1)
    proposal.sections.build(title: 'Caratteristiche desiderate', seq: seq+=1).paragraphs.build(content:'', seq:1)

    solution = event_solution
    solution.seq = 1
    proposal.solutions << solution
  end

  def press_new(proposal)
    @problems = proposal.sections.build(title: t('pages.proposals.new.press.problems_title'), seq: 1)
    @problems.paragraphs.build(content:'', seq:1)
    proposal.proposal_type = ProposalType.find_by_short_name(ProposalType::PRESS)
    proposal.proposal_votation_type_id = ProposalVotationType::STANDARD
  end

  def press_create(proposal)
    seq = 1
    proposal.sections.build(title: 'Destinatari/Target', seq: seq+=1).paragraphs.build(content:'', seq:1)

    solution = press_solution
    solution.seq = 1
    proposal.solutions << solution
  end


  def rule_book_new(proposal)
    @problems = proposal.sections.build(title: t('proposal_types.rule_book.problems_title'), seq: 1)
    @problems.paragraphs.build(content:'', seq:1)

    proposal.proposal_type = ProposalType.find_by_short_name(ProposalType::RULE_BOOK)
    proposal.proposal_votation_type_id = ProposalVotationType::STANDARD
  end

  def rule_book_create(proposal)
    seq = 1
    proposal.sections.build(title: t('proposal_types.rule_book.sections.inspire'), seq: seq+=1).paragraphs.build(content:'', seq:1)
    proposal.sections.build(title: t('proposal_types.rule_book.sections.stackeholders'), seq: seq+=1).paragraphs.build(content:'', seq:1)
    proposal.sections.build(title: t('proposal_types.rule_book.sections.requisiti'), seq: seq+=1).paragraphs.build(content:'', seq:1)

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
    @problems = proposal.sections.build(title: t('proposal_types.candidates.sections.description'), seq: 1)
    @problems.paragraphs.build(content:'', seq:1)
  end

  def candidates_create(proposal)
    solution = candidates_solution
    solution.seq = 1
    proposal.solutions << solution
  end
end
