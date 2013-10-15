module ProposalsModule
  include GroupsHelper, NotificationHelper, ProposalsHelper


  #check if we have to close the dabate and pass to votation phase
  def check_phase(proposal)
    return unless proposal.in_valutation? #if the proposal already passed this phase skip this check
    quorum = proposal.quorum
    passed = false
    timepassed = (!quorum.ends_at || Time.now > quorum.ends_at)
    vpassed = (!quorum.valutations || proposal.valutations >= quorum.valutations)
    #if both parameters were defined
    if quorum.ends_at && quorum.valutations
      if quorum.or?
        passed = (timepassed || vpassed)
      else quorum.and?
        passed = (timepassed && vpassed)
      end
    else #we just need one of two (one will be certainly true)
      passed = (timepassed && vpassed)
    end

    if passed #if we have to move one
      if proposal.rank >= quorum.good_score #and we passed the debate quorum
        if proposal.vote_period #the user already choosed the votation period! that's great, we can just sit along the river waiting for it to begin
          proposal.proposal_state_id = ProposalState::WAIT
        else
          proposal.proposal_state_id = ProposalState::WAIT_DATE #we passed the debate, we are now waiting for someone to choose the vote date
          proposal.private? ?
              notify_proposal_ready_for_vote(proposal,proposal.presentation_groups.first) :
              notify_proposal_ready_for_vote(proposal)

        end

        #remove the timer if is still there
        if quorum.minutes
          Resque.remove_delayed(ProposalsWorker, {:action => ProposalsWorker::ENDTIME, :proposal_id => proposal.id})
        end
      elsif proposal.rank < quorum.bad_score #if we have not passed the debate quorum abandon it
        abandon(proposal)

        proposal.private? ?
          notify_proposal_abandoned(proposal,proposal.presentation_groups.first) :
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
    proposal.proposal_type = ProposalType.find_by_name(ProposalType::SIMPLE)
    proposal.proposal_votation_type_id = ProposalVotationType::STANDARD
  end

  def standard_new(proposal)
    @problems = proposal.sections.build(title: t('pages.proposals.new.standard.problems_title'), seq: 1)
    @problems.paragraphs.build(content:'', seq:1)
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
    @problems.paragraphs.build(content:'', seq:1)
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
    @problems.paragraphs.build(content:'', seq:1)
    proposal.proposal_type = ProposalType.find_by_name(ProposalType::EVENT)
    proposal.proposal_votation_type_id = ProposalVotationType::STANDARD
  end


  def event_create(proposal)
    seq = 1
    proposal.sections.build(title: t('pages.proposals.new.event.paragraph.similar_experiences'), seq: seq+=1).paragraphs.build(content:'', seq:1)
    proposal.sections.build(title: t('pages.proposals.new.event.paragraph.stakeholders'), seq: seq+=1).paragraphs.build(content:'', seq:1)
    proposal.sections.build(title: t('pages.proposals.new.event.paragraph.desired_characteristics'), seq: seq+=1).paragraphs.build(content:'', seq:1)

    solution = event_solution
    solution.seq = 1
    proposal.solutions << solution
  end

  def press_new(proposal)
    @problems = proposal.sections.build(title: t('pages.proposals.new.press.problems_title'), seq: 1)
    @problems.paragraphs.build(content:'', seq:1)
    proposal.proposal_type = ProposalType.find_by_name(ProposalType::PRESS)
    proposal.proposal_votation_type_id = ProposalVotationType::STANDARD
  end

  def press_create(proposal)
    seq = 1
    proposal.sections.build(title: t('pages.proposals.new.press.paragraph.target'), seq: seq+=1).paragraphs.build(content:'', seq:1)

    solution = press_solution
    solution.seq = 1
    proposal.solutions << solution
  end


  def rule_book_new(proposal)
    @problems = proposal.sections.build(title: t('pages.proposals.new.rule_book.problems_title'), seq: 1)
    @problems.paragraphs.build(content:'', seq:1)

    proposal.proposal_type = ProposalType.find_by_name(ProposalType::RULE_BOOK)
    proposal.proposal_votation_type_id = ProposalVotationType::STANDARD
  end

  def rule_book_create(proposal)
    seq = 1
    proposal.sections.build(title: t('pages.proposals.new.rule_book.paragraph.inspire'), seq: seq+=1).paragraphs.build(content:'', seq:1)
    proposal.sections.build(title: t('pages.proposals.new.rule_book.stakeholders'), seq: seq+=1).paragraphs.build(content:'', seq:1)
    proposal.sections.build(title: t('pages.proposals.new.rule_book.paragraph.requirements'), seq: seq+=1).paragraphs.build(content:'', seq:1)

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
    @problems = proposal.sections.build(title: t('pages.proposals.new.candidates.paragraph.election_type'), seq: 1)
    @problems.paragraphs.build(content:'', seq:1)
  end

  def candidates_create(proposal)
    solution = candidates_solution
    solution.seq = 1
    proposal.solutions << solution
  end
end
