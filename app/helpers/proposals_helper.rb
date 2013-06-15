module ProposalsHelper

  def link_to_proposal(proposal, options={})
    raise "Invalid proposal" unless proposal
    link_to proposal.title, proposal.url, options
  end

  #create a solution for a standard proposal
  def standard_solution
    seq = 0
    solution = Solution.new
    solution.sections.build(title: t('pages.proposals.new.standard.solution.title'), seq: seq+=1).paragraphs.build(content: '', seq: 1)
    solution.sections.build(title: t('pages.proposals.new.standard.solution.description'), seq: seq+=1).paragraphs.build(content: '', seq: 1)
    solution.sections.build(title: t('pages.proposals.new.standard.solution.time'), seq: seq+=1).paragraphs.build(content: '', seq: 1)
    solution.sections.build(title: t('pages.proposals.new.standard.solution.subject'), seq: seq+=1).paragraphs.build(content: '', seq: 1)
    solution.sections.build(title: t('pages.proposals.new.standard.solution.resources'), seq: seq+=1).paragraphs.build(content: '', seq: 1)
    solution.sections.build(title: t('pages.proposals.new.standard.solution.aspects'), seq: seq+=1).paragraphs.build(content: '', seq: 1)
    solution.sections.build(title: t('pages.proposals.new.standard.solution.documents'), seq: seq+=1).paragraphs.build(content: '', seq: 1)
    solution.sections.build(title: t('pages.proposals.new.standard.solution.pros'), seq: seq+=1).paragraphs.build(content: '', seq: 1)
    solution.sections.build(title: t('pages.proposals.new.standard.solution.cons'), seq: seq+=1).paragraphs.build(content: '', seq: 1)
    solution
  end

  def candidates_solution
    seq = 0
    solution = Solution.new
    solution.sections.build(title: t('pages.proposals.new.candidates.solution.name'), seq: seq+=1).paragraphs.build(content: '', seq: 1)
    solution.sections.build(title: t('pages.proposals.new.candidates.solution.data'), seq: seq+=1).paragraphs.build(content: '', seq: 1)
    solution.sections.build(title: t('pages.proposals.new.candidates.solution.curriculum'), seq: seq+=1).paragraphs.build(content: '', seq: 1)
    solution.sections.build(title: t('pages.proposals.new.candidates.solution.available'), seq: seq+=1).paragraphs.build(content: '', seq: 1)
    solution
  end

  def rule_book_solution
    seq = 0
    solution = Solution.new
    solution.sections.build(title: t('pages.proposals.new.rule_book.solution.title'), seq: seq+=1).paragraphs.build(content: '', seq: 1)
    4.times do
      solution.sections.build(title: t('pages.proposals.new.rule_book.solution.article',num: seq), seq: seq+=1).paragraphs.build(content: '', seq: 1)
    end
    solution.sections.build(title: t('pages.proposals.new.rule_book.solution.pros'), seq: seq+=1).paragraphs.build(content: '', seq: 1)
    solution.sections.build(title: t('pages.proposals.new.rule_book.solution.cons'), seq: seq+=1).paragraphs.build(content: '', seq: 1)
    solution
  end

  def press_solution
    seq = 0
    solution = Solution.new
    solution.sections.build(title: t('pages.proposals.new.press.solution.title'), seq: seq+=1).paragraphs.build(content: '', seq: 1)
    solution.sections.build(title: t('pages.proposals.new.press.solution.subtitle'), seq: seq+=1).paragraphs.build(content: '', seq: 1)
    solution.sections.build(title: t('pages.proposals.new.press.solution.incipit'), seq: seq+=1).paragraphs.build(content: '', seq: 1)
    solution.sections.build(title: t('pages.proposals.new.press.solution.body'), seq: seq+=1).paragraphs.build(content: '', seq: 1)
    solution.sections.build(title: t('pages.proposals.new.press.solution.conclusion'), seq: seq+=1).paragraphs.build(content: '', seq: 1)
    solution.sections.build(title: t('pages.proposals.new.press.solution.deep'), seq: seq+=1).paragraphs.build(content: '', seq: 1)
    solution
  end

  def event_solution
    seq = 0
    solution = Solution.new
    solution.sections.build(title: t('pages.proposals.new.event.solution.title'), seq: seq+=1).paragraphs.build(content: '', seq: 1)
    solution.sections.build(title: t('pages.proposals.new.event.solution.description'), seq: seq+=1).paragraphs.build(content: '', seq: 1)
    solution.sections.build(title: t('pages.proposals.new.event.solution.program'), seq: seq+=1).paragraphs.build(content: '', seq: 1)
    solution.sections.build(title: t('pages.proposals.new.event.solution.place'), seq: seq+=1).paragraphs.build(content: '', seq: 1)
    solution.sections.build(title: t('pages.proposals.new.event.solution.organization'), seq: seq+=1).paragraphs.build(content: '', seq: 1)
    solution.sections.build(title: t('pages.proposals.new.event.solution.resources'), seq: seq+=1).paragraphs.build(content: '', seq: 1)
    solution.sections.build(title: t('pages.proposals.new.event.solution.pros'), seq: seq+=1).paragraphs.build(content: '', seq: 1)
    solution.sections.build(title: t('pages.proposals.new.event.solution.cons'), seq: seq+=1).paragraphs.build(content: '', seq: 1)
    solution
  end

  def estimate_solution
    seq = 0
    solution = Solution.new
    solution.sections.build(title: t('pages.proposals.new.estimate.solution.title'), seq: seq+=1).paragraphs.build(content: '', seq: 1)
    solution.sections.build(title: t('pages.proposals.new.estimate.solution.cost'), seq: seq+=1).paragraphs.build(content: '', seq: 1)
    solution.sections.build(title: t('pages.proposals.new.estimate.solution.problems'), seq: seq+=1).paragraphs.build(content: '', seq: 1)
    solution.sections.build(title: t('pages.proposals.new.estimate.solution.dumentation'), seq: seq+=1).paragraphs.build(content: '', seq: 1)
    solution
  end

  def agenda_solution
    seq = 0
    solution = Solution.new
    solution.sections.build(title: t('pages.proposals.new.agenda.solution.title'), seq: seq+=1).paragraphs.build(content: '', seq: 1)
    solution.sections.build(title: t('pages.proposals.new.agenda.solution.points'), seq: seq+=1).paragraphs.build(content: '', seq: 1)
    solution.sections.build(title: t('pages.proposals.new.agenda.solution.priorities'), seq: seq+=1).paragraphs.build(content: '', seq: 1)
    solution.sections.build(title: t('pages.proposals.new.agenda.solution.links'), seq: seq+=1).paragraphs.build(content: '', seq: 1)
    solution
  end

end
