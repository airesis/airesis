module ProposalsModule
  include NotificationHelper
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
        proposal.proposal_state_id = PROP_WAIT_DATE  #metti la proposta in attesa di una data per la votazione
        proposal.private? ?
          notify_proposal_ready_for_vote(proposal,proposal.presentation_groups.first) :
          notify_proposal_ready_for_vote(proposal)
      elsif proposal.rank < quorum.bad_score
        proposal.proposal_state_id = PROP_RESP
        notify_proposal_rejected(proposal)
      end 
      proposal.save
      proposal.reload
    end
  end



  def standard_new(proposal)
    @problems = proposal.sections.build(title: t('pages.proposals.new.standard.problems_title'), seq: 1)
    # @objectives = @proposal.sections.build(title: t('pages.proposals.new.objectives_title'), seq: 2)
    #@solution = proposal.solutions.build(seq: 1)
    #@solution_section = @solution.sections.build(title: t('pages.proposals.new.standard.first_solution_title'), seq: 1)

  end

  def standard_create(proposal)
    @solution = proposal.solutions.build(seq: 1)
    @solution_section = @solution.sections.build(title: t('pages.proposals.new.standard.first_solution_title'), seq: 1)
    @solution_section.paragraphs.build(content: '', seq: 1)
  end

  def agenda_new(proposal)
    @problems = proposal.sections.build(title: t('pages.proposals.new.agenda.problems_title'), seq: 1)
    # @objectives = @proposal.sections.build(title: t('pages.proposals.new.objectives_title'), seq: 2)
    @solution = proposal.solutions.build(seq: 1)
    @solution_section = @solution.sections.build(title: t('pages.proposals.new.agenda.first_solution_title'), seq: 1)
    proposal.proposal_type = ProposalType.find_by_short_name(ProposalType::STANDARD)
    proposal.proposal_votation_type_id = ProposalVotationType::STANDARD
  end

  def estimate_new(proposal)
    @problems = proposal.sections.build(title: t('pages.proposals.new.estimate.problems_title'), seq: 1)
    # @objectives = @proposal.sections.build(title: t('pages.proposals.new.objectives_title'), seq: 2)
    @solution = proposal.solutions.build(seq: 1)
    @solution_section = @solution.sections.build(title: t('pages.proposals.new.first_solution_title'), seq: 1)
    proposal.proposal_type = ProposalType.find_by_short_name(ProposalType::STANDARD)
    proposal.proposal_votation_type_id = ProposalVotationType::STANDARD
  end

  def event_new(proposal)
    @problems = proposal.sections.build(title: t('pages.proposals.new.event.problems_title'), seq: 1)
  end


  def event_create(proposal)
    #@problems = proposal.sections.build(title: t('pages.proposals.new.event.problems_title'), seq: 1)
    simili = proposal.sections.build(title: 'Esperienze simili', seq: 2)
    simili.paragraphs.build(content:'', seq:1)
    solution = proposal.solutions.build(seq: 1)
    tit = solution.sections.build(title: 'Titolo', seq: 1)
    tit.paragraphs.build(content: '', seq: 1)
  end

  def press_new(proposal)
    @problems = proposal.sections.build(title: t('pages.proposals.new.press.problems_title'), seq: 1)
    # @objectives = @proposal.sections.build(title: t('pages.proposals.new.objectives_title'), seq: 2)
    @solution = proposal.solutions.build(seq: 1)
    @solution_section = @solution.sections.build(title: t('pages.proposals.new.first_solution_title'), seq: 1)
    proposal.proposal_type = ProposalType.find_by_short_name(ProposalType::STANDARD)
    proposal.proposal_votation_type_id = ProposalVotationType::STANDARD
  end


  def rule_book_new(proposal)
    @problems = proposal.sections.build(title: t('proposal_types.rule_book.problems_title'), seq: 1)
    # @objectives = @proposal.sections.build(title: t('pages.proposals.new.objectives_title'), seq: 2)
    @solution = proposal.solutions.build(seq: 1)
    @solution_section = @solution.sections.build(title: t('pages.proposals.new.first_solution_title'), seq: 1)
    proposal.proposal_type = ProposalType.find_by_short_name(ProposalType::STANDARD)
    proposal.proposal_votation_type_id = ProposalVotationType::STANDARD
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
    @problems = proposal.sections.build(title: t('pages.proposals.new.problems_title'), seq: 1)

  end
end
