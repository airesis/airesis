module Concerns
  module ProposalBuildable
    extend ActiveSupport::Concern

    included do
      before_validation :create_sections, on: :create
    end

    def build_sections
      send "#{self.proposal_type.name.downcase}_new" #execute specific method to build sections
    end

    def create_sections
      send "#{self.proposal_type.name.downcase}_create" #execute specific method to build sections
    end

    def build_solution
      solution = send(self.proposal_type.name.downcase + '_solution')
    end

    def simple_new
      problems = self.sections.build(title: I18n.t('pages.proposals.new.simple.problems_title'), question: I18n.t('pages.proposals.new.simple.problems_question'), seq: 1)
      problems.suggestion = I18n.t('pages.proposals.new.standard.suggestion_html')
      problems.paragraphs.build(content: '', seq: 1)
      self.proposal_type = ProposalType.find_by_name(ProposalType::SIMPLE)
      self.proposal_votation_type_id = ProposalVotationType::STANDARD
    end

    def simple_create
      seq = 1
      solution = simple_solution
      solution.seq = 1
      self.solutions << solution
    end

    #create a solution for a standard proposal
    def simple_solution
      seq = 0
      solution = Solution.new
      solution.sections.build(title: I18n.t('pages.proposals.new.simple.solution.description'), question: I18n.t('pages.proposals.new.simple.question.solution.description'), seq: seq+=1).paragraphs.build(content: '', seq: 1)
      solution
    end

    def standard_new
      problems = self.sections.build(title: I18n.t('pages.proposals.new.standard.problems_title'), question: I18n.t('pages.proposals.new.standard.problems_question'), seq: 1)
      problems.suggestion = I18n.t('pages.proposals.new.standard.suggestion_html')
      problems.paragraphs.build(content: '', seq: 1)
      self.proposal_type = ProposalType.find_by_name(ProposalType::STANDARD)
      self.proposal_votation_type_id = ProposalVotationType::STANDARD
    end

    def standard_create
      seq = 1
      self.sections.build(title: I18n.t('pages.proposals.new.standard.paragraph.similar'), question: I18n.t('pages.proposals.new.standard.question.paragraph.similar'), seq: seq+=1).paragraphs.build(content: '', seq: 1) #TODO:I18n
      self.sections.build(title: I18n.t('pages.proposals.new.standard.paragraph.stakeholders'), question: I18n.t('pages.proposals.new.standard.question.paragraph.stakeholders'), seq: seq+=1).paragraphs.build(content: '', seq: 1)
      self.sections.build(title: I18n.t('pages.proposals.new.standard.paragraph.requirements'), question: I18n.t('pages.proposals.new.standard.question.paragraph.requirements'), seq: seq+=1).paragraphs.build(content: '', seq: 1)

      solution = standard_solution
      solution.seq = 1
      self.solutions << solution
    end

#create a solution for a standard proposal
    def standard_solution
      seq = 0
      solution = Solution.new
      solution.sections.build(title: I18n.t('pages.proposals.new.standard.solution.description'), question: I18n.t('pages.proposals.new.standard.question.solution.description'), seq: seq+=1).paragraphs.build(content: '', seq: 1)
      solution.sections.build(title: I18n.t('pages.proposals.new.standard.solution.time'), question: I18n.t('pages.proposals.new.standard.question.solution.time'), seq: seq+=1).paragraphs.build(content: '', seq: 1)
      solution.sections.build(title: I18n.t('pages.proposals.new.standard.solution.subject'), question: I18n.t('pages.proposals.new.standard.question.solution.subject'), seq: seq+=1).paragraphs.build(content: '', seq: 1)
      solution.sections.build(title: I18n.t('pages.proposals.new.standard.solution.resources'), question: I18n.t('pages.proposals.new.standard.question.solution.resources'), seq: seq+=1).paragraphs.build(content: '', seq: 1)
      solution.sections.build(title: I18n.t('pages.proposals.new.standard.solution.aspects'), question: I18n.t('pages.proposals.new.standard.question.solution.aspects'), seq: seq+=1).paragraphs.build(content: '', seq: 1)
      solution.sections.build(title: I18n.t('pages.proposals.new.standard.solution.documents'), question: I18n.t('pages.proposals.new.standard.question.solution.documents'), seq: seq+=1).paragraphs.build(content: '', seq: 1)
      solution.sections.build(title: I18n.t('pages.proposals.new.standard.solution.pros'), question: I18n.t('pages.proposals.new.standard.question.solution.pros'), seq: seq+=1).paragraphs.build(content: '', seq: 1)
      solution.sections.build(title: I18n.t('pages.proposals.new.standard.solution.cons'), question: I18n.t('pages.proposals.new.standard.question.solution.cons'), seq: seq+=1).paragraphs.build(content: '', seq: 1)
      solution
    end


    def agenda_new
      problems = self.sections.build(title: I18n.t('pages.proposals.new.agenda.problems_title'), question: I18n.t('pages.proposals.new.agenda.problems_question'), seq: 1)
      problems.suggestion = I18n.t('pages.proposals.new.agenda.suggestion_html')
      problems.paragraphs.build(content: '', seq: 1)
      self.proposal_type = ProposalType.find_by_name(ProposalType::AGENDA)
      self.proposal_votation_type_id = ProposalVotationType::STANDARD
    end

    def agenda_create
      seq = 1
      self.sections.build(title: I18n.t('pages.proposals.new.agenda.paragraph.date_time'), question: I18n.t('pages.proposals.new.agenda.question.paragraph.date_time'), seq: seq+=1).paragraphs.build(content: '', seq: 1)
      self.sections.build(title: I18n.t('pages.proposals.new.agenda.paragraph.place'), question: I18n.t('pages.proposals.new.agenda.question.paragraph.place'), seq: seq+=1).paragraphs.build(content: '', seq: 1)

      solution = agenda_solution
      solution.seq = 1
      self.solutions << solution
    end

    def estimate_new
      problems = self.sections.build(title: I18n.t('pages.proposals.new.estimate.problems_title'), question: I18n.t('pages.proposals.new.estimate.problems_question'), seq: 1)
      problems.suggestion = I18n.t('pages.proposals.new.estimate.suggestion_html')
      problems.paragraphs.build(content: '', seq: 1)
      self.proposal_type = ProposalType.find_by_name(ProposalType::ESTIMATE)
      self.proposal_votation_type_id = ProposalVotationType::STANDARD
    end

    def estimate_create
      seq = 1
      self.sections.build(title: I18n.t('pages.proposals.new.estimate.paragraph.technical_constrains'), question: I18n.t('pages.proposals.new.estimate.question.paragraph.technical_constrains'), seq: seq+=1).paragraphs.build(content: '', seq: 1)
      self.sections.build(title: I18n.t('pages.proposals.new.estimate.paragraph.temporal_constrains'), question: I18n.t('pages.proposals.new.estimate.question.paragraph.temporal_constrains'), seq: seq+=1).paragraphs.build(content: '', seq: 1)
      self.sections.build(title: I18n.t('pages.proposals.new.estimate.paragraph.other_constrains'), question: I18n.t('pages.proposals.new.estimate.question.paragraph.other_constrains'), seq: seq+=1).paragraphs.build(content: '', seq: 1)
      self.sections.build(title: I18n.t('pages.proposals.new.estimate.paragraph.budget'), question: I18n.t('pages.proposals.new.estimate.question.paragraph.budget'), seq: seq+=1).paragraphs.build(content: '', seq: 1)
      self.sections.build(title: I18n.t('pages.proposals.new.estimate.paragraph.recipient_budget'), question: I18n.t('pages.proposals.new.estimate.question.paragraph.recipient_budget'), seq: seq+=1).paragraphs.build(content: '', seq: 1)

      solution = estimate_solution
      solution.seq = 1
      self.solutions << solution
    end

    def event_new
      problems = self.sections.build(title: I18n.t('pages.proposals.new.event.problems_title'), question: I18n.t('pages.proposals.new.event.problems_question'), seq: 1)
      problems.suggestion = I18n.t('pages.proposals.new.event.suggestion_html')
      problems.paragraphs.build(content: '', seq: 1)
      self.proposal_type = ProposalType.find_by_name(ProposalType::EVENT)
      self.proposal_votation_type_id = ProposalVotationType::STANDARD
    end


    def event_create
      seq = 1
      self.sections.build(title: I18n.t('pages.proposals.new.event.paragraph.similar_experiences'), question: I18n.t('pages.proposals.new.event.question.paragraph.similar_experiences'), seq: seq+=1).paragraphs.build(content: '', seq: 1)
      self.sections.build(title: I18n.t('pages.proposals.new.event.paragraph.stakeholders'), question: I18n.t('pages.proposals.new.event.question.paragraph.stakeholders'), seq: seq+=1).paragraphs.build(content: '', seq: 1)
      self.sections.build(title: I18n.t('pages.proposals.new.event.paragraph.desired_characteristics'), question: I18n.t('pages.proposals.new.event.question.paragraph.desired_characteristics'), seq: seq+=1).paragraphs.build(content: '', seq: 1)

      solution = event_solution
      solution.seq = 1
      self.solutions << solution
    end

    def press_new
      problems = self.sections.build(title: I18n.t('pages.proposals.new.press.problems_title'), question: I18n.t('pages.proposals.new.press.problems_question'), seq: 1)
      problems.suggestion = I18n.t('pages.proposals.new.press.suggestion_html')
      problems.paragraphs.build(content: '', seq: 1)
      self.proposal_type = ProposalType.find_by_name(ProposalType::PRESS)
      self.proposal_votation_type_id = ProposalVotationType::STANDARD
    end

    def press_create
      seq = 1
      self.sections.build(title: I18n.t('pages.proposals.new.press.paragraph.target'), question: I18n.t('pages.proposals.new.press.question.paragraph.target'), seq: seq+=1).paragraphs.build(content: '', seq: 1)

      solution = press_solution
      solution.seq = 1
      self.solutions << solution
    end


    def rule_book_new
      problems = self.sections.build(title: I18n.t('pages.proposals.new.rule_book.problems_title'), question: I18n.t('pages.proposals.new.rule_book.problems_question'), seq: 1)
      problems.suggestion = I18n.t('pages.proposals.new.rule_book.suggestion_html')
      problems.paragraphs.build(content: '', seq: 1)

      self.proposal_type = ProposalType.find_by_name(ProposalType::RULE_BOOK)
      self.proposal_votation_type_id = ProposalVotationType::STANDARD
    end

    def rule_book_create
      seq = 1
      self.sections.build(title: I18n.t('pages.proposals.new.rule_book.paragraph.inspire'), question: I18n.t('pages.proposals.new.rule_book.question.paragraph.inspire'), seq: seq+=1).paragraphs.build(content: '', seq: 1)
      self.sections.build(title: I18n.t('pages.proposals.new.rule_book.paragraph.stakeholders'), question: I18n.t('pages.proposals.new.rule_book.question.paragraph.stakeholders'), seq: seq+=1).paragraphs.build(content: '', seq: 1)
      self.sections.build(title: I18n.t('pages.proposals.new.rule_book.paragraph.requirements'), question: I18n.t('pages.proposals.new.rule_book.question.paragraph.requirements'), seq: seq+=1).paragraphs.build(content: '', seq: 1)

      solution = rule_book_solution
      solution.seq = 1
      self.solutions << solution
    end


    def poll_new
      @text = self.sections.build(title: 'Testo del sondaggio', seq: 1)
      @solution_a = self.solutions.build(seq: 1)
      @solution_b = self.solutions.build(seq: 2)
      @solution_c = self.solutions.build(seq: 3)
      self.proposal_type_id = ProposalType::POLL
      self.proposal_votation_type_id = ProposalVotationType::SCHULZE

      @solution_a_section = @solution_a.sections.build(title: 'Opzione 1', seq: 1)
      @solution_b_section = @solution_b.sections.build(title: 'Opzione 2', seq: 1)
      @solution_c_section = @solution_c.sections.build(title: 'Opzione 3', seq: 1)
    end


    def candidates_new
      problems = self.sections.build(title: I18n.t('pages.proposals.new.candidates.paragraph.role'), question: I18n.t('pages.proposals.new.candidates.question.paragraph.role'), seq: 1)
      problems.suggestion = I18n.t('pages.proposals.new.candidates.suggestion_html')
      problems.paragraphs.build(content: '', seq: 1)
    end

    def candidates_create
      seq = 1
      self.sections.build(title: I18n.t('pages.proposals.new.candidates.paragraph.requirements'), question: I18n.t('pages.proposals.new.candidates.question.paragraph.requirements'), seq: seq+1).paragraphs.build(content: '', seq: 1)
      solution = candidates_solution
      solution.seq = 1
      self.solutions << solution
    end

    def petition_new
      problems = self.sections.build(title: I18n.t('pages.proposals.new.petition.paragraph.text'), question: I18n.t('pages.proposals.new.petition.question.paragraph.text'), seq: 1)
      problems.suggestion = I18n.t('pages.proposals.new.petition.suggestion_html')
      problems.paragraphs.build(content: '', seq: 1)
    end

    def petition_create(proposal)

    end


    def candidates_solution
      seq = 0
      solution = Solution.new
      solution.sections.build(title: I18n.t('pages.proposals.new.candidates.solution.data'), question: I18n.t('pages.proposals.new.candidates.question.solution.data'), seq: seq+=1).paragraphs.build(content: '', seq: 1)
      solution.sections.build(title: I18n.t('pages.proposals.new.candidates.solution.curriculum'), question: I18n.t('pages.proposals.new.candidates.question.solution.curriculum'), seq: seq+=1).paragraphs.build(content: '', seq: 1)

      solution
    end

    def rule_book_solution
      seq = 0
      solution = Solution.new
      4.times do
        seq+=1
        solution.sections.build(title: I18n.t('pages.proposals.new.rule_book.solution.article', num: seq), question: I18n.t('pages.proposals.new.rule_book.question.solution.article', num: seq), seq: seq).paragraphs.build(content: '', seq: 1)
      end
      solution.sections.build(title: I18n.t('pages.proposals.new.rule_book.solution.pros'), question: I18n.t('pages.proposals.new.rule_book.question.solution.pros'), seq: seq+=1).paragraphs.build(content: '', seq: 1)
      solution.sections.build(title: I18n.t('pages.proposals.new.rule_book.solution.cons'), question: I18n.t('pages.proposals.new.rule_book.question.solution.cons'), seq: seq+=1).paragraphs.build(content: '', seq: 1)
      solution
    end

    def press_solution
      seq = 0
      solution = Solution.new
      solution.sections.build(title: I18n.t('pages.proposals.new.press.solution.maintitle'), question: I18n.t('pages.proposals.new.press.question.solution.maintitle'), seq: seq+=1).paragraphs.build(content: '', seq: 1)
      solution.sections.build(title: I18n.t('pages.proposals.new.press.solution.subtitle'), question: I18n.t('pages.proposals.new.press.question.solution.subtitle'), seq: seq+=1).paragraphs.build(content: '', seq: 1)
      solution.sections.build(title: I18n.t('pages.proposals.new.press.solution.incipit'), question: I18n.t('pages.proposals.new.press.question.solution.incipit'), seq: seq+=1).paragraphs.build(content: '', seq: 1)
      solution.sections.build(title: I18n.t('pages.proposals.new.press.solution.body'), question: I18n.t('pages.proposals.new.press.question.solution.body'), seq: seq+=1).paragraphs.build(content: '', seq: 1)
      solution.sections.build(title: I18n.t('pages.proposals.new.press.solution.conclusion'), question: I18n.t('pages.proposals.new.press.question.solution.conclusion'), seq: seq+=1).paragraphs.build(content: '', seq: 1)
      solution.sections.build(title: I18n.t('pages.proposals.new.press.solution.deep'), question: I18n.t('pages.proposals.new.press.question.solution.deep'), seq: seq+=1).paragraphs.build(content: '', seq: 1)
      solution
    end

    def event_solution
      seq = 0
      solution = Solution.new
      solution.sections.build(title: I18n.t('pages.proposals.new.event.solution.description'), question: I18n.t('pages.proposals.new.event.question.solution.description'), seq: seq+=1).paragraphs.build(content: '', seq: 1)
      solution.sections.build(title: I18n.t('pages.proposals.new.event.solution.program'), question: I18n.t('pages.proposals.new.event.question.solution.program'), seq: seq+=1).paragraphs.build(content: '', seq: 1)
      solution.sections.build(title: I18n.t('pages.proposals.new.event.solution.place'), question: I18n.t('pages.proposals.new.event.question.solution.place'), seq: seq+=1).paragraphs.build(content: '', seq: 1)
      solution.sections.build(title: I18n.t('pages.proposals.new.event.solution.organization'), question: I18n.t('pages.proposals.new.event.question.solution.organization'), seq: seq+=1).paragraphs.build(content: '', seq: 1)
      solution.sections.build(title: I18n.t('pages.proposals.new.event.solution.resources'), question: I18n.t('pages.proposals.new.event.question.solution.resources'), seq: seq+=1).paragraphs.build(content: '', seq: 1)
      #solution.sections.build(title: I18n.t('pages.proposals.new.event.solution.pros'), seq: seq+=1).paragraphs.build(content: '', seq: 1)
      #solution.sections.build(title: I18n.t('pages.proposals.new.event.solution.cons'), seq: seq+=1).paragraphs.build(content: '', seq: 1)
      solution
    end

    def estimate_solution
      seq = 0
      solution = Solution.new
      solution.sections.build(title: I18n.t('pages.proposals.new.estimate.solution.cost'), question: I18n.t('pages.proposals.new.estimate.question.solution.cost'), seq: seq+=1).paragraphs.build(content: '', seq: 1)
      solution.sections.build(title: I18n.t('pages.proposals.new.estimate.solution.problems'), question: I18n.t('pages.proposals.new.estimate.question.solution.problems'), seq: seq+=1).paragraphs.build(content: '', seq: 1)
      solution.sections.build(title: I18n.t('pages.proposals.new.estimate.solution.dumentation'), question: I18n.t('pages.proposals.new.estimate.question.solution.dumentation'), seq: seq+=1).paragraphs.build(content: '', seq: 1)
      solution
    end

    def agenda_solution
      seq = 0
      solution = Solution.new
      solution.sections.build(title: I18n.t('pages.proposals.new.agenda.solution.description'), question: I18n.t('pages.proposals.new.agenda.question.solution.description'), seq: seq+=1).paragraphs.build(content: '', seq: 1)
      solution.sections.build(title: I18n.t('pages.proposals.new.agenda.solution.links'), question: I18n.t('pages.proposals.new.agenda.question.solution.links'), seq: seq+=1).paragraphs.build(content: '', seq: 1)
      solution.sections.build(title: I18n.t('pages.proposals.new.agenda.solution.priorities'), question: I18n.t('pages.proposals.new.agenda.question.solution.priorities'), seq: seq+=1).paragraphs.build(content: '', seq: 1)
      solution.sections.build(title: I18n.t('pages.proposals.new.agenda.solution.estimated_time'), question: I18n.t('pages.proposals.new.agenda.question.solution.estimated_time'), seq: seq+=1).paragraphs.build(content: '', seq: 1)
      solution
    end
  end
end
