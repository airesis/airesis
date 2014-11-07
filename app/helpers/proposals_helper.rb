#encoding: utf-8
module ProposalsHelper


  def navigator_actions(args={})
    classes = "action #{args[:classes]}"
    (link_to '#', onclick: 'return false', class: "#{classes} move_up" do
      '<i class="fa fa-arrow-up"></i>'.html_safe
    end) +
        (link_to '#', onclick: 'return false', class: "#{classes} move_down" do
          '<i class="fa fa-arrow-down"></i>'.html_safe
        end) +
        (link_to '#', onclick: 'return false', class: "#{classes} remove" do
          '<i class="fa fa-trash"></i>'.html_safe
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
    auto_link(scanned.gsub(/\n/, '<br/>'), html: {target: '_blank'}, sanitize: false) do |text|
      truncate(text, length: 15)
    end.html_safe
  end


  def proposal_tag(proposal, options={})
    ret = "<div class='proposal_tag'>"
    ret += link_to_proposal(proposal)
    ret += "</div>"
    ret.html_safe
  end

  def link_to_proposal(proposal, options={})
    group = proposal.groups.first
    link_to proposal.title,
            (group ?
                group_proposal_url(group, proposal) :
                proposal_url(proposal, subdomain: false)),
            options
  end
end
