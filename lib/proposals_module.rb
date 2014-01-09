module ProposalsModule
  include GroupsHelper, NotificationHelper, ProposalsHelper


  #check if we have to close the dabate and pass to votation phase
  #accept to parameters: the proposal and a force end parameter to close the debate in any case
  def check_phase(proposal, force_end=false)
    return unless proposal.in_valutation? #if the proposal already passed this phase skip this check
    quorum = proposal.quorum
    quorum.check_phase(force_end)
  end

  def close_vote_phase(proposal)
    quorum = proposal.quorum
    quorum.close_vote_phase

  end



  def simple_new(proposal)
    @problems = proposal.sections.build(title: t('pages.proposals.new.simple.problems_title'),question: t('pages.proposals.new.simple.problems_question'), seq: 1)
    @problems.suggestion = t('pages.proposals.new.standard.suggestion_html')
    @problems.paragraphs.build(content: '', seq: 1)
    proposal.proposal_type = ProposalType.find_by_name(ProposalType::SIMPLE)
    proposal.proposal_votation_type_id = ProposalVotationType::STANDARD
  end

  def simple_create(proposal)
    seq = 1
    solution = simple_solution
    solution.seq = 1
    proposal.solutions << solution
  end

  def standard_new(proposal)
    @problems = proposal.sections.build(title: t('pages.proposals.new.standard.problems_title'), question: t('pages.proposals.new.standard.problems_question'), seq: 1)
    @problems.suggestion = t('pages.proposals.new.standard.suggestion_html')
    @problems.paragraphs.build(content: '', seq: 1)
    proposal.proposal_type = ProposalType.find_by_name(ProposalType::STANDARD)
    proposal.proposal_votation_type_id = ProposalVotationType::STANDARD
  end

  def standard_create(proposal)
    seq = 1
    proposal.sections.build(title: t('pages.proposals.new.standard.paragraph.similar'),question: t('pages.proposals.new.standard.question.paragraph.similar'), seq: seq+=1).paragraphs.build(content: '', seq: 1) #TODO:I18n
    proposal.sections.build(title: t('pages.proposals.new.standard.paragraph.stakeholders'),question: t('pages.proposals.new.standard.question.paragraph.stakeholders'), seq: seq+=1).paragraphs.build(content: '', seq: 1)
    proposal.sections.build(title: t('pages.proposals.new.standard.paragraph.requirements'),question: t('pages.proposals.new.standard.question.paragraph.requirements'), seq: seq+=1).paragraphs.build(content: '', seq: 1)

    solution = standard_solution
    solution.seq = 1
    proposal.solutions << solution
  end

  def agenda_new(proposal)
    @problems = proposal.sections.build(title: t('pages.proposals.new.agenda.problems_title'), question: t('pages.proposals.new.agenda.problems_question'), seq: 1)
    @problems.suggestion = t('pages.proposals.new.agenda.suggestion_html')
    @problems.paragraphs.build(content: '', seq: 1)
    proposal.proposal_type = ProposalType.find_by_name(ProposalType::AGENDA)
    proposal.proposal_votation_type_id = ProposalVotationType::STANDARD
  end

  def agenda_create(proposal)
    seq = 1
    proposal.sections.build(title: t('pages.proposals.new.agenda.paragraph.date_time'),question: t('pages.proposals.new.agenda.question.paragraph.date_time'), seq: seq+=1).paragraphs.build(content: '', seq: 1)
    proposal.sections.build(title: t('pages.proposals.new.agenda.paragraph.place'),question: t('pages.proposals.new.agenda.question.paragraph.place'), seq: seq+=1).paragraphs.build(content: '', seq: 1)

    solution = agenda_solution
    solution.seq = 1
    proposal.solutions << solution
  end

  def estimate_new(proposal)
    @problems = proposal.sections.build(title: t('pages.proposals.new.estimate.problems_title'),question: t('pages.proposals.new.estimate.problems_question'), seq: 1)
    @problems.suggestion = t('pages.proposals.new.estimate.suggestion_html')
    @problems.paragraphs.build(content: '', seq: 1)
    proposal.proposal_type = ProposalType.find_by_name(ProposalType::ESTIMATE)
    proposal.proposal_votation_type_id = ProposalVotationType::STANDARD
  end

  def estimate_create(proposal)
    seq = 1
    proposal.sections.build(title: t('pages.proposals.new.estimate.paragraph.technical_constrains'),title: t('pages.proposals.new.estimate.question.paragraph.technical_constrains'), seq: seq+=1).paragraphs.build(content: '', seq: 1)
    proposal.sections.build(title: t('pages.proposals.new.estimate.paragraph.temporal_constrains'),title: t('pages.proposals.new.estimate.question.paragraph.temporal_constrains'), seq: seq+=1).paragraphs.build(content: '', seq: 1)
    proposal.sections.build(title: t('pages.proposals.new.estimate.paragraph.other_constrains'),title: t('pages.proposals.new.estimate.question.paragraph.other_constrains'), seq: seq+=1).paragraphs.build(content: '', seq: 1)
    proposal.sections.build(title: t('pages.proposals.new.estimate.paragraph.budget'),title: t('pages.proposals.new.estimate.question.paragraph.budget'), seq: seq+=1).paragraphs.build(content: '', seq: 1)
    proposal.sections.build(title: t('pages.proposals.new.estimate.paragraph.recipient_budget'),title: t('pages.proposals.new.estimate.question.paragraph.recipient_budget'), seq: seq+=1).paragraphs.build(content: '', seq: 1)

    solution = estimate_solution
    solution.seq = 1
    proposal.solutions << solution
  end

  def event_new(proposal)
    @problems = proposal.sections.build(title: t('pages.proposals.new.event.problems_title'),question: t('pages.proposals.new.event.problems_question'), seq: 1)
    @problems.suggestion = t('pages.proposals.new.event.suggestion_html')
    @problems.paragraphs.build(content: '', seq: 1)
    proposal.proposal_type = ProposalType.find_by_name(ProposalType::EVENT)
    proposal.proposal_votation_type_id = ProposalVotationType::STANDARD
  end


  def event_create(proposal)
    seq = 1
    proposal.sections.build(title: t('pages.proposals.new.event.paragraph.similar_experiences'),question: t('pages.proposals.new.event.question.paragraph.similar_experiences'), seq: seq+=1).paragraphs.build(content: '', seq: 1)
    proposal.sections.build(title: t('pages.proposals.new.event.paragraph.stakeholders'),question: t('pages.proposals.new.event.question.paragraph.stakeholders'), seq: seq+=1).paragraphs.build(content: '', seq: 1)
    proposal.sections.build(title: t('pages.proposals.new.event.paragraph.desired_characteristics'),question: t('pages.proposals.new.event.question.paragraph.desired_characteristics'), seq: seq+=1).paragraphs.build(content: '', seq: 1)

    solution = event_solution
    solution.seq = 1
    proposal.solutions << solution
  end

  def press_new(proposal)
    @problems = proposal.sections.build(title: t('pages.proposals.new.press.problems_title'),question: t('pages.proposals.new.press.problems_question'), seq: 1)
    @problems.suggestion = t('pages.proposals.new.press.suggestion_html')
    @problems.paragraphs.build(content: '', seq: 1)
    proposal.proposal_type = ProposalType.find_by_name(ProposalType::PRESS)
    proposal.proposal_votation_type_id = ProposalVotationType::STANDARD
  end

  def press_create(proposal)
    seq = 1
    proposal.sections.build(title: t('pages.proposals.new.press.paragraph.target'),title: t('pages.proposals.new.press.question.paragraph.target'), seq: seq+=1).paragraphs.build(content: '', seq: 1)

    solution = press_solution
    solution.seq = 1
    proposal.solutions << solution
  end


  def rule_book_new(proposal)
    @problems = proposal.sections.build(title: t('pages.proposals.new.rule_book.problems_title'),question: t('pages.proposals.new.rule_book.problems_question'), seq: 1)
    @problems.suggestion = t('pages.proposals.new.rule_book.suggestion_html')
    @problems.paragraphs.build(content: '', seq: 1)

    proposal.proposal_type = ProposalType.find_by_name(ProposalType::RULE_BOOK)
    proposal.proposal_votation_type_id = ProposalVotationType::STANDARD
  end

  def rule_book_create(proposal)
    seq = 1
    proposal.sections.build(title: t('pages.proposals.new.rule_book.paragraph.inspire'),question: t('pages.proposals.new.rule_book.question.paragraph.inspire'), seq: seq+=1).paragraphs.build(content: '', seq: 1)
    proposal.sections.build(title: t('pages.proposals.new.rule_book.paragraph.stakeholders'),question: t('pages.proposals.new.rule_book.question.paragraph.stakeholders'), seq: seq+=1).paragraphs.build(content: '', seq: 1)
    proposal.sections.build(title: t('pages.proposals.new.rule_book.paragraph.requirements'),question: t('pages.proposals.new.rule_book.question.paragraph.requirements'), seq: seq+=1).paragraphs.build(content: '', seq: 1)

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
    @problems = proposal.sections.build(title: t('pages.proposals.new.candidates.paragraph.role'),question: t('pages.proposals.new.candidates.question.paragraph.role'), seq: 1)
    @problems.suggestion = t('pages.proposals.new.candidates.suggestion_html')
    @problems.paragraphs.build(content: '', seq: 1)
  end

  def candidates_create(proposal)
    seq = 1
    proposal.sections.build(title: t('pages.proposals.new.candidates.paragraph.requirements'),question: t('pages.proposals.new.candidates.question.paragraph.requirements'), seq: seq+1).paragraphs.build(content: '', seq: 1)
    solution = candidates_solution
    solution.seq = 1
    proposal.solutions << solution
  end
end
