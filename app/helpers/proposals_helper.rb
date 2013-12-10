#encoding: utf-8
module ProposalsHelper


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
  def parsed_paragraph(content)
    sanitize(content).gsub(/<.{1,3}>/,'').blank? ?
        "<p><span class=\"fake_content\">#{t('pages.proposals.show.generic_fake_content')}</span></p>".html_safe :
        sanitize(content)
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
    solution = Solution.new(title: t('pages.proposals.new.simple.solution.title'))
    solution.sections.build(title: t('pages.proposals.new.simple.solution.description'), seq: seq+=1).paragraphs.build(content: '', seq: 1)
    solution
  end


#create a solution for a standard proposal
  def standard_solution
    seq = 0
    solution = Solution.new(title: t('pages.proposals.new.standard.solution.title'))
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
    solution = Solution.new(title: t('pages.proposals.new.candidates.solution.name'))
    solution.sections.build(title: t('pages.proposals.new.candidates.solution.data'), seq: seq+=1).paragraphs.build(content: '', seq: 1)
    solution.sections.build(title: t('pages.proposals.new.candidates.solution.curriculum'), seq: seq+=1).paragraphs.build(content: '', seq: 1)

    #solution.sections.build(title: t('pages.proposals.new.candidates.solution.curriculum'), seq: seq+=1).paragraphs.build(content: '', seq: 1)
    #solution.sections.build(title: t('pages.proposals.new.candidates.solution.available'), seq: seq+=1).paragraphs.build(content: '', seq: 1)
    solution
  end

  def rule_book_solution
    seq = 0
    solution = Solution.new(title: t('pages.proposals.new.rule_book.solution.title'))
    4.times do
      solution.sections.build(title: t('pages.proposals.new.rule_book.solution.article', num: seq+=1), seq: seq).paragraphs.build(content: '', seq: 1)
    end
    solution.sections.build(title: t('pages.proposals.new.rule_book.solution.pros'), seq: seq+=1).paragraphs.build(content: '', seq: 1)
    solution.sections.build(title: t('pages.proposals.new.rule_book.solution.cons'), seq: seq+=1).paragraphs.build(content: '', seq: 1)
    solution
  end

  def press_solution
    seq = 0
    solution = Solution.new(title: t('pages.proposals.new.press.solution.title'))
    solution.sections.build(title: t('pages.proposals.new.press.solution.maintitle'), seq: seq+=1).paragraphs.build(content: '', seq: 1)
    solution.sections.build(title: t('pages.proposals.new.press.solution.subtitle'), seq: seq+=1).paragraphs.build(content: '', seq: 1)
    solution.sections.build(title: t('pages.proposals.new.press.solution.incipit'), seq: seq+=1).paragraphs.build(content: '', seq: 1)
    solution.sections.build(title: t('pages.proposals.new.press.solution.body'), seq: seq+=1).paragraphs.build(content: '', seq: 1)
    solution.sections.build(title: t('pages.proposals.new.press.solution.conclusion'), seq: seq+=1).paragraphs.build(content: '', seq: 1)
    solution.sections.build(title: t('pages.proposals.new.press.solution.deep'), seq: seq+=1).paragraphs.build(content: '', seq: 1)
    solution
  end

  def event_solution
    seq = 0
    solution = Solution.new(title: t('pages.proposals.new.event.solution.title'))
    solution.sections.build(title: t('pages.proposals.new.event.solution.description'), seq: seq+=1).paragraphs.build(content: '', seq: 1)
    solution.sections.build(title: t('pages.proposals.new.event.solution.program'), seq: seq+=1).paragraphs.build(content: '', seq: 1)
    solution.sections.build(title: t('pages.proposals.new.event.solution.place'), seq: seq+=1).paragraphs.build(content: '', seq: 1)
    solution.sections.build(title: t('pages.proposals.new.event.solution.organization'), seq: seq+=1).paragraphs.build(content: '', seq: 1)
    solution.sections.build(title: t('pages.proposals.new.event.solution.resources'), seq: seq+=1).paragraphs.build(content: '', seq: 1)
    #solution.sections.build(title: t('pages.proposals.new.event.solution.pros'), seq: seq+=1).paragraphs.build(content: '', seq: 1)
    #solution.sections.build(title: t('pages.proposals.new.event.solution.cons'), seq: seq+=1).paragraphs.build(content: '', seq: 1)
    solution
  end

  def estimate_solution
    seq = 0
    solution = Solution.new(title: t('pages.proposals.new.estimate.solution.title'))
    solution.sections.build(title: t('pages.proposals.new.estimate.solution.cost'), seq: seq+=1).paragraphs.build(content: '', seq: 1)
    solution.sections.build(title: t('pages.proposals.new.estimate.solution.problems'), seq: seq+=1).paragraphs.build(content: '', seq: 1)
    solution.sections.build(title: t('pages.proposals.new.estimate.solution.dumentation'), seq: seq+=1).paragraphs.build(content: '', seq: 1)
    solution
  end

  def agenda_solution
    seq = 0
    solution = Solution.new(title: t('pages.proposals.new.agenda.solution.title'))
    solution.sections.build(title: t('pages.proposals.new.agenda.solution.description'), seq: seq+=1).paragraphs.build(content: '', seq: 1)
    solution.sections.build(title: t('pages.proposals.new.agenda.solution.links'), seq: seq+=1).paragraphs.build(content: '', seq: 1)
    solution.sections.build(title: t('pages.proposals.new.agenda.solution.priorities'), seq: seq+=1).paragraphs.build(content: '', seq: 1)
    solution.sections.build(title: t('pages.proposals.new.agenda.solution.estimated_time'), seq: seq+=1).paragraphs.build(content: '', seq: 1)
    solution
  end

end
