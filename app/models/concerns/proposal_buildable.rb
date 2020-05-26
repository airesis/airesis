module ProposalBuildable
  extend ActiveSupport::Concern

  included do
    before_validation :create_sections, on: :create
  end

  def build_sections
    send "#{proposal_type.name.downcase}_new" # execute specific method to build sections
  end

  def create_sections
    send "#{proposal_type.name.downcase}_create" # execute specific method to build sections
  end

  def build_solution
    send(proposal_type.name.downcase + '_solution')
  end

  def build_section(element, section_title, section_question, section_seq)
    element.sections.build(title: section_title,
                           question: section_question,
                           seq: section_seq).
        paragraphs.build(content: '', seq: 1)
  end

  def build_solution_section(solution, section_title, section_question, section_seq)
    build_section(solution, section_title, section_question, section_seq)
  end

  def simple_new
    problems = sections.build(title: I18n.t('pages.proposals.new.simple.problems_title'),
                              question: I18n.t('pages.proposals.new.simple.problems_question'), seq: 1)
    problems.suggestion = I18n.t('pages.proposals.new.standard.suggestion_html')
    problems.paragraphs.build(content: '', seq: 1)
    self.proposal_type = ProposalType.find_by_name(ProposalType::SIMPLE)
    self.proposal_votation_type_id = :standard
  end

  def standard_new
    problems = sections.build(title: I18n.t('pages.proposals.new.standard.problems_title'),
                              question: I18n.t('pages.proposals.new.standard.problems_question'),
                              seq: 1)
    problems.suggestion = I18n.t('pages.proposals.new.standard.suggestion_html')
    problems.paragraphs.build(content: '', seq: 1)
    self.proposal_type = ProposalType.find_by_name(ProposalType::STANDARD)
    self.proposal_votation_type_id = :standard
  end

  def agenda_new
    problems = sections.build(title: I18n.t('pages.proposals.new.agenda.problems_title'),
                              question: I18n.t('pages.proposals.new.agenda.problems_question'),
                              seq: 1)
    problems.suggestion = I18n.t('pages.proposals.new.agenda.suggestion_html')
    problems.paragraphs.build(content: '', seq: 1)
    self.proposal_type = ProposalType.find_by_name(ProposalType::AGENDA)
    self.proposal_votation_type_id = :standard
  end

  def estimate_new
    problems = sections.build(title: I18n.t('pages.proposals.new.estimate.problems_title'),
                              question: I18n.t('pages.proposals.new.estimate.problems_question'),
                              seq: 1)
    problems.suggestion = I18n.t('pages.proposals.new.estimate.suggestion_html')
    problems.paragraphs.build(content: '', seq: 1)
    self.proposal_type = ProposalType.find_by_name(ProposalType::ESTIMATE)
    self.proposal_votation_type_id = :standard
  end

  def event_new
    problems = sections.build(title: I18n.t('pages.proposals.new.event.problems_title'),
                              question: I18n.t('pages.proposals.new.event.problems_question'),
                              seq: 1)
    problems.suggestion = I18n.t('pages.proposals.new.event.suggestion_html')
    problems.paragraphs.build(content: '', seq: 1)
    self.proposal_type = ProposalType.find_by_name(ProposalType::EVENT)
    self.proposal_votation_type_id = :standard
  end

  def press_new
    problems = sections.build(title: I18n.t('pages.proposals.new.press.problems_title'),
                              question: I18n.t('pages.proposals.new.press.problems_question'),
                              seq: 1)
    problems.suggestion = I18n.t('pages.proposals.new.press.suggestion_html')
    problems.paragraphs.build(content: '', seq: 1)
    self.proposal_type = ProposalType.find_by_name(ProposalType::PRESS)
    self.proposal_votation_type_id = :standard
  end

  def rule_book_new
    problems = sections.build(title: I18n.t('pages.proposals.new.rule_book.problems_title'),
                              question: I18n.t('pages.proposals.new.rule_book.problems_question'),
                              seq: 1)
    problems.suggestion = I18n.t('pages.proposals.new.rule_book.suggestion_html')
    problems.paragraphs.build(content: '', seq: 1)

    self.proposal_type = ProposalType.find_by_name(ProposalType::RULE_BOOK)
    self.proposal_votation_type_id = :standard
  end

  def poll_new
    @text = sections.build(title: 'Testo del sondaggio', seq: 1)
    @solution_a = solutions.build(seq: 1)
    @solution_b = solutions.build(seq: 2)
    @solution_c = solutions.build(seq: 3)
    @solution_a_section = @solution_a.sections.build(title: 'Opzione 1', seq: 1)
    @solution_b_section = @solution_b.sections.build(title: 'Opzione 2', seq: 1)
    @solution_c_section = @solution_c.sections.build(title: 'Opzione 3', seq: 1)

    self.proposal_type_id = ProposalType::POLL
    self.proposal_votation_type_id = :schulze
  end

  def candidates_new
    problems = sections.build(title: I18n.t('pages.proposals.new.candidates.paragraph.role'),
                              question: I18n.t('pages.proposals.new.candidates.question.paragraph.role'),
                              seq: 1)
    problems.suggestion = I18n.t('pages.proposals.new.candidates.suggestion_html')
    problems.paragraphs.build(content: '', seq: 1)
  end

  def petition_new
    problems = sections.build(title: I18n.t('pages.proposals.new.petition.paragraph.text'),
                              question: I18n.t('pages.proposals.new.petition.question.paragraph.text'),
                              seq: 1)
    problems.suggestion = I18n.t('pages.proposals.new.petition.suggestion_html')
    problems.paragraphs.build(content: '', seq: 1)
  end

  def simple_create
    solution = simple_solution
    solution.seq = 1
    solutions << solution
  end

  def paragraphs_builder(model, paragraphs)
    seq = 1
    paragraphs.each do |paragraph_name|
      sections.build(title: I18n.t("pages.proposals.new.#{model}.paragraph.#{paragraph_name}"),
                     question: I18n.t("pages.proposals.new.#{model}.question.paragraph.#{paragraph_name}"),
                     seq: seq += 1).paragraphs.build(content: '', seq: 1)
    end
  end

  def standard_create
    paragraphs_builder('standard', %w(similar stakeholders requirements))
    solution = standard_solution
    solution.seq = 1
    solutions << solution
  end

  def agenda_create
    paragraphs_builder('agenda', %w(date_time place))
    solution = agenda_solution
    solution.seq = 1
    solutions << solution
  end

  def estimate_create
    paragraphs_builder('estimate',
                       %w(technical_constrains temporal_constrains other_constrains budget recipient_budget))
    solution = estimate_solution
    solution.seq = 1
    solutions << solution
  end

  def event_create
    paragraphs_builder('event', %w(similar_experiences stakeholders desired_characteristics))
    solution = event_solution
    solution.seq = 1
    solutions << solution
  end

  def press_create
    paragraphs_builder('press', %w(target))
    solution = press_solution
    solution.seq = 1
    solutions << solution
  end

  def rule_book_create
    paragraphs_builder('rule_book', %w(inspire stakeholders requirements))
    solution = rule_book_solution
    solution.seq = 1
    solutions << solution
  end

  def candidates_create
    paragraphs_builder('candidates', %w(requirements))
    solution = candidates_solution
    solution.seq = 1
    solutions << solution
  end

  def petition_create(_proposal) end

  def solution_builder(model, paragraphs)
    seq = 0
    solution = Solution.new
    paragraphs.each do |section_name|
      build_solution_section(solution,
                             I18n.t("pages.proposals.new.#{model}.solution.#{section_name}"),
                             I18n.t("pages.proposals.new.#{model}.question.solution.#{section_name}"),
                             seq += 1)
    end
    solution
  end

  # create a solution for a standard proposal
  def simple_solution
    solution_builder('simple', ['description'])
  end

  # create a solution for a standard proposal
  def standard_solution
    solution_builder('standard', %w(description time subject resources aspects documents pros cons))
  end

  def candidates_solution
    solution_builder('candidates', %w(data curriculum))
  end

  def rule_book_solution
    seq = 0
    solution = Solution.new
    4.times do
      seq += 1
      build_solution_section(solution,
                             I18n.t('pages.proposals.new.rule_book.solution.article', num: seq),
                             I18n.t('pages.proposals.new.rule_book.question.solution.article', num: seq),
                             seq)
    end

    %w(pros cons).each do |section_name|
      build_solution_section(solution,
                             I18n.t("pages.proposals.new.rule_book.solution.#{section_name}"),
                             I18n.t("pages.proposals.new.rule_book.question.solution.#{section_name}"),
                             seq += 1)
    end
    solution
  end

  def press_solution
    solution_builder('press', %w(maintitle subtitle incipit body conclusion deep))
  end

  def event_solution
    solution_builder('event', %w(description program place organization resources))
  end

  def estimate_solution
    solution_builder('estimate', %w(cost problems dumentation))
  end

  def agenda_solution
    solution_builder('agenda', %w(description links priorities estimated_time))
  end
end
