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


  # return a parsed section
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
    auto_link(scanned.gsub(/\n/, '<br/>'), html: {target: '_blank'}, sanitize: false) do |text|
      truncate(text, length: 15)
    end.html_safe
  end

  def proposal_group_image_tag(proposal)
    if @group || !proposal.group
      proposal_category_image_tag(proposal)
    else
      image_tag(proposal.group.image, title: proposal.group.name, data: {qtip: ''})
    end
  end

  def proposal_category_image_tag(proposal)
    image_tag("proposal_categories/#{proposal.proposal_category_id}.png", alt: proposal.category.description, title: proposal.category.description)
  end

  def proposal_status(proposal)
    if proposal.in_valutation?
      t('pages.proposals.list.last_update', time_ago: time_in_words(proposal.updated_at))
    elsif proposal.waiting_date?
      t('pages.proposals.list.waiting_date')
    elsif proposal.waiting?
      t('pages.proposals.list.voting_from_to', from: (l proposal.vote_period.starttime), to: (l proposal.vote_period.endtime))
    elsif proposal.voting?
      t('pages.proposals.list.voting_until', date: (l proposal.vote_period.endtime, format: :two_rows))
    elsif proposal.voted?
      if proposal.is_schulze?
        t('pages.proposals.list.votation_finished', time_ago: time_in_words(proposal.vote_period.endtime))
      else
        if proposal.rejected?
          t('pages.proposals.list.votation_finished_rejected', time_ago: time_ago_in_words(proposal.vote_period.endtime), date: (l proposal.vote_period.endtime, format: :two_rows))
        else
          t('pages.proposals.list.votation_finished_approved', date: (l proposal.vote_period.endtime, format: :two_rows))
        end
      end
    elsif proposal.abandoned?
      t('pages.proposals.list.last_update', time_ago: time_in_words(proposal.updated_at))
    end
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

  # return an array of nicknames for the proposal, in json format
  def json_nicknames(proposal)
    if proposal.is_anonima?
      proposal.proposal_nicknames.collect(&:to_json).to_json.gsub('"', '\'')
    else
      '[]'
    end.html_safe
  end
end
