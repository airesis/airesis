#encoding: utf-8
module ProposalsHelper


  def navigator_actions(args={})
    classes = "action #{args[:classes]}"
    (link_to '#', onclick: 'return false', class: "#{classes} move_up" do
      '<i class="fi-arrow-up"></i>'.html_safe
    end) +
    (link_to '#', onclick: 'return false', class: "#{classes} move_down" do
      '<i class="fi-arrow-down"></i>'.html_safe
    end) +
    (link_to '#', onclick: 'return false', class: "#{classes} remove" do
      '<i class="fi-x"></i>'.html_safe
    end)
  end

  def reload_message
    ret = "toastr.options = {tapToDismiss: false, extendedTimeOut: 0, timeOut: 0};"
    ret += "toastr.info('<div id=\"reload_proposal\">"
    ret += 'This page is outdate.<br/>Please reload the page.'
    ret += "<br/>"
    ret += '<a href="" class="btn" style="color: #444">Reload</a>'
    ret += "</div>');"
    ret.html_safe
  end

  #return a parsed paragraph
  #deprecated use parsed_section
  def parsed_paragraph(content)
    sanitize(content).gsub(/<.{1,3}>/, '').blank? ?
        "<p><span class=\"fake_content\">#{t('pages.proposals.show.generic_fake_content')}</span></p>".html_safe :
        sanitize(content)
  end

  #return a parsed section
  def parsed_section(section)
    sanitize(section.paragraphs.first.content).gsub(/<.{1,3}>/, '').blank? ?
        "<p><span class=\"fake_content\">#{ section.question || t('pages.proposals.show.generic_fake_content')}</span></p>".html_safe :
        sanitize(section.paragraphs.first.content)
  end


  def parsed_content(proposal_comment, anonimous=true)
    scanned = CGI.escapeHTML(proposal_comment.content).gsub(/(@)\[\[(\d+):([\w\s\.\-]+):([\w\s@\.,-\/#!$%\^&\*;:{}=\-_`~()]+)\]\]/) do |match|
      nick = ProposalNickname.find($2)
      anonimous ?
          "<span class='cite nickname'>#{nick.nickname}</span>" :
          "<span class='cite nickname'>#{link_to nick.user.fullname, nick.user}</span>"
    end
    scanned
    auto_link(scanned.gsub(/\n/, '<br/>'), :html => {:target => '_blank'}, :sanitize => false) do |text|
      truncate(text, :length => 15)
    end.html_safe
  end


  def proposal_tag(proposal, options={})
    ret = "<div class='proposal_tag'>"
    ret += link_to_proposal(proposal)
    ret += "</div>"
    ret.html_safe
  end

  def link_to_proposal(proposal, options={})
    raise "Invalid proposal" unless proposal
    #group proposals
    if proposal.private?
      group = proposal.presentation_groups.first
      link_to proposal.title, group_proposal_url(group, proposal), options
    else
      link_to proposal.title, proposal_url(proposal, subdomain: false), options
    end
  end

#create a solution for a standard proposal
  def simple_solution
    seq = 0
    solution = Solution.new
    solution.sections.build(title: t('pages.proposals.new.simple.solution.description'), question: t('pages.proposals.new.simple.question.solution.description'), seq: seq+=1).paragraphs.build(content: '', seq: 1)
    solution
  end


#create a solution for a standard proposal
  def standard_solution
    seq = 0
    solution = Solution.new
    solution.sections.build(title: t('pages.proposals.new.standard.solution.description'), question: t('pages.proposals.new.standard.question.solution.description'), seq: seq+=1).paragraphs.build(content: '', seq: 1)
    solution.sections.build(title: t('pages.proposals.new.standard.solution.time'), question: t('pages.proposals.new.standard.question.solution.time'), seq: seq+=1).paragraphs.build(content: '', seq: 1)
    solution.sections.build(title: t('pages.proposals.new.standard.solution.subject'), question: t('pages.proposals.new.standard.question.solution.subject'), seq: seq+=1).paragraphs.build(content: '', seq: 1)
    solution.sections.build(title: t('pages.proposals.new.standard.solution.resources'), question: t('pages.proposals.new.standard.question.solution.resources'), seq: seq+=1).paragraphs.build(content: '', seq: 1)
    solution.sections.build(title: t('pages.proposals.new.standard.solution.aspects'), question: t('pages.proposals.new.standard.question.solution.aspects'), seq: seq+=1).paragraphs.build(content: '', seq: 1)
    solution.sections.build(title: t('pages.proposals.new.standard.solution.documents'), question: t('pages.proposals.new.standard.question.solution.documents'), seq: seq+=1).paragraphs.build(content: '', seq: 1)
    solution.sections.build(title: t('pages.proposals.new.standard.solution.pros'), question: t('pages.proposals.new.standard.question.solution.pros'), seq: seq+=1).paragraphs.build(content: '', seq: 1)
    solution.sections.build(title: t('pages.proposals.new.standard.solution.cons'), question: t('pages.proposals.new.standard.question.solution.cons'), seq: seq+=1).paragraphs.build(content: '', seq: 1)
    solution
  end

  def candidates_solution
    seq = 0
    solution = Solution.new
    solution.sections.build(title: t('pages.proposals.new.candidates.solution.data'), question: t('pages.proposals.new.candidates.question.solution.data'), seq: seq+=1).paragraphs.build(content: '', seq: 1)
    solution.sections.build(title: t('pages.proposals.new.candidates.solution.curriculum'), question: t('pages.proposals.new.candidates.question.solution.curriculum'), seq: seq+=1).paragraphs.build(content: '', seq: 1)

    solution
  end

  def rule_book_solution
    seq = 0
    solution = Solution.new
    4.times do
      seq+=1
      solution.sections.build(title: t('pages.proposals.new.rule_book.solution.article', num: seq), question: t('pages.proposals.new.rule_book.question.solution.article', num: seq), seq: seq).paragraphs.build(content: '', seq: 1)
    end
    solution.sections.build(title: t('pages.proposals.new.rule_book.solution.pros'), question: t('pages.proposals.new.rule_book.question.solution.pros'), seq: seq+=1).paragraphs.build(content: '', seq: 1)
    solution.sections.build(title: t('pages.proposals.new.rule_book.solution.cons'), question: t('pages.proposals.new.rule_book.question.solution.cons'), seq: seq+=1).paragraphs.build(content: '', seq: 1)
    solution
  end

  def press_solution
    seq = 0
    solution = Solution.new
    solution.sections.build(title: t('pages.proposals.new.press.solution.maintitle'), question: t('pages.proposals.new.press.question.solution.maintitle'), seq: seq+=1).paragraphs.build(content: '', seq: 1)
    solution.sections.build(title: t('pages.proposals.new.press.solution.subtitle'), question: t('pages.proposals.new.press.question.solution.subtitle'), seq: seq+=1).paragraphs.build(content: '', seq: 1)
    solution.sections.build(title: t('pages.proposals.new.press.solution.incipit'), question: t('pages.proposals.new.press.question.solution.incipit'), seq: seq+=1).paragraphs.build(content: '', seq: 1)
    solution.sections.build(title: t('pages.proposals.new.press.solution.body'), question: t('pages.proposals.new.press.question.solution.body'), seq: seq+=1).paragraphs.build(content: '', seq: 1)
    solution.sections.build(title: t('pages.proposals.new.press.solution.conclusion'), question: t('pages.proposals.new.press.question.solution.conclusion'), seq: seq+=1).paragraphs.build(content: '', seq: 1)
    solution.sections.build(title: t('pages.proposals.new.press.solution.deep'), question: t('pages.proposals.new.press.question.solution.deep'), seq: seq+=1).paragraphs.build(content: '', seq: 1)
    solution
  end

  def event_solution
    seq = 0
    solution = Solution.new
    solution.sections.build(title: t('pages.proposals.new.event.solution.description'), question: t('pages.proposals.new.event.question.solution.description'), seq: seq+=1).paragraphs.build(content: '', seq: 1)
    solution.sections.build(title: t('pages.proposals.new.event.solution.program'), question: t('pages.proposals.new.event.question.solution.program'), seq: seq+=1).paragraphs.build(content: '', seq: 1)
    solution.sections.build(title: t('pages.proposals.new.event.solution.place'), question: t('pages.proposals.new.event.question.solution.place'), seq: seq+=1).paragraphs.build(content: '', seq: 1)
    solution.sections.build(title: t('pages.proposals.new.event.solution.organization'), question: t('pages.proposals.new.event.question.solution.organization'), seq: seq+=1).paragraphs.build(content: '', seq: 1)
    solution.sections.build(title: t('pages.proposals.new.event.solution.resources'), question: t('pages.proposals.new.event.question.solution.resources'), seq: seq+=1).paragraphs.build(content: '', seq: 1)
    #solution.sections.build(title: t('pages.proposals.new.event.solution.pros'), seq: seq+=1).paragraphs.build(content: '', seq: 1)
    #solution.sections.build(title: t('pages.proposals.new.event.solution.cons'), seq: seq+=1).paragraphs.build(content: '', seq: 1)
    solution
  end

  def estimate_solution
    seq = 0
    solution = Solution.new
    solution.sections.build(title: t('pages.proposals.new.estimate.solution.cost'), question: t('pages.proposals.new.estimate.question.solution.cost'), seq: seq+=1).paragraphs.build(content: '', seq: 1)
    solution.sections.build(title: t('pages.proposals.new.estimate.solution.problems'), question: t('pages.proposals.new.estimate.question.solution.problems'), seq: seq+=1).paragraphs.build(content: '', seq: 1)
    solution.sections.build(title: t('pages.proposals.new.estimate.solution.dumentation'), question: t('pages.proposals.new.estimate.question.solution.dumentation'), seq: seq+=1).paragraphs.build(content: '', seq: 1)
    solution
  end

  def agenda_solution
    seq = 0
    solution = Solution.new
    solution.sections.build(title: t('pages.proposals.new.agenda.solution.description'), question: t('pages.proposals.new.agenda.question.solution.description'), seq: seq+=1).paragraphs.build(content: '', seq: 1)
    solution.sections.build(title: t('pages.proposals.new.agenda.solution.links'), question: t('pages.proposals.new.agenda.question.solution.links'), seq: seq+=1).paragraphs.build(content: '', seq: 1)
    solution.sections.build(title: t('pages.proposals.new.agenda.solution.priorities'), question: t('pages.proposals.new.agenda.question.solution.priorities'), seq: seq+=1).paragraphs.build(content: '', seq: 1)
    solution.sections.build(title: t('pages.proposals.new.agenda.solution.estimated_time'), question: t('pages.proposals.new.agenda.question.solution.estimated_time'), seq: seq+=1).paragraphs.build(content: '', seq: 1)
    solution
  end

end
