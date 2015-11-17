module ProposalsHelper
  def navigator_actions(args = {})
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
    ret = 'toastr.options = {tapToDismiss: false, extendedTimeOut: 0, timeOut: 0};'
    ret += "toastr.info('<div id=\"reload_proposal\">"
    ret += 'This page is outdate.<br/>Please reload the page.'
    ret += '<br/>'
    ret += '<a href="" class="btn" style="color: #444">Reload</a>'
    ret += "</div>');"
    ret.html_safe
  end

  # return a parsed section
  def parsed_section(section)
    sanitize(section.paragraphs.first.content).gsub(/<.{1,3}>/, '').blank? ?
      "<p><span class=\"fake_content\">#{section.question || t('pages.proposals.show.generic_fake_content')}</span></p>".html_safe :
      sanitize(section.paragraphs.first.content)
  end

  def parsed_content(proposal_comment, anonimous = true)
    scanned = CGI.escapeHTML(proposal_comment.content).gsub(/(@)\[\[(\d+):([\w\s\.\-]+):([\w\s@\.,-\/#!$%\^&\*;:{}=\-_`~()]+)\]\]/) do |_match|
      nick = ProposalNickname.find(Regexp.last_match(2))
      anonimous ?
        "<span class='cite nickname'>#{nick.nickname}</span>" :
        "<span class='cite nickname'>#{link_to nick.user.fullname, nick.user}</span>"
    end
    auto_link(scanned.gsub(/\n/, '<br/>'), html: { target: '_blank' }, sanitize: false) do |text|
      truncate(text, length: 15)
    end.html_safe
  end

  def proposal_group_image_tag(proposal)
    if @group || !proposal.group
      proposal_category_image_tag(proposal)
    else
      image_tag(proposal.group.image, title: proposal.group.name, data: { qtip: '' })
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

  def proposal_list_element_for_mustache(proposal)
    ret = {
      mustache: {
        now: (l Time.now),
        proposal: {
          id: proposal.id,
          time_left: (proposal.quorum.time_left.upcase if proposal.in_valutation?),
          good_score: (proposal.quorum.good_score),
          vote_time_left: (proposal.vote_period.time_left.upcase if proposal.voting?),
          'in_valutation?' => proposal.in_valutation?,
          'voting?' => proposal.voting?,
          'voted?' => proposal.voted?,
          'voting_or_voted?' => proposal.voting? || proposal.voted?,
          voters: "#{proposal.user_votes_count}/#{proposal.eligible_voters_count}",
          participants: proposal.participants_count,
          rank: proposal.rank,
          percentage: proposal.percentage,
          user_tags: proposal.users.map { |user| user_tag_mini(user) }.join,
          anonymous_user_tags: proposal.users.map { |user| user_tag_mini(user, proposal) }.join,
          contributes_count: proposal.contributes.count,
          'has_interest_borders?' => proposal.interest_borders.any?,
          interest_border: (proposal.interest_borders.first.territory.description if proposal.interest_borders.any?),
          'show_rank_bar?' => (proposal.percentage >= 1),
          'show_current_cursor?' => (proposal.percentage <= 98),
          type_description: proposal.proposal_type.description.upcase,
          group_image_tag: proposal_group_image_tag(proposal),
          status: proposal_status(proposal),
          short_content: proposal.short_content,
          vote_url: (proposal.private ? group_proposal_url(proposal.groups.first, proposal) : proposal_url(proposal, subdomain: false)),
          title_link: link_to_proposal(proposal, style: (proposal.rejected? ? 'text-decoration: line-through;' : ''), title: proposal.title)
        },
        images: {
          time_description: (image_tag 'plist/stopwatch.png'),
          group_participants: (image_tag 'group_participants.png'),
          group_proposals: (image_tag 'group_proposals.png'),
          rank: (image_tag 'plist/gradimento.png'),
          place: (image_tag 'place.png')
        },
        texts: {
          participants: t('pages.proposals.index.participants_number'),
          authors: t('pages.proposals.list.authors').upcase,
          conditions_left: t('pages.proposals.list.condition_left').upcase,
          time_left: t('pages.proposals.list.time_left').upcase,
          voters: t('pages.proposals.index.voters'),
          rank: t('pages.proposals.index.rank'),
          participants_number: t('pages.proposals.index.participants_number'),
          contributes_number: t('pages.proposals.index.contributes_number'),
          rank_bar: {
            creation: t('pages.proposals.new_rank_bar.creation', time_ago: time_ago_in_words(proposal.created_at).upcase, date: (l proposal.created_at, format: :long).upcase),
            end: t('pages.proposals.new_rank_bar.end', date: proposal.quorum.end_desc.upcase),
            now: t('pages.proposals.new_rank_bar.now', left: proposal.quorum.time_left).upcase,
            good_score: t('pages.proposals.new_rank_bar.good_score', score: proposal.quorum.good_score)
          },
          vote: t('pages.proposals.list.vote')
        },
        current_user: {
          'signed_in?' => signed_in?,
          'is_author?' => proposal.users.include?(current_user),
          'can_vote?' => (can? :vote, proposal),
          notifications: proposal.count_notifications(current_user.id),
          'show_alerts?' => (proposal.count_notifications(current_user.id) > 0),
          valutation_image: (user_valutation_image(current_user, proposal) if current_user)
        }
      }
    }
    if proposal.voting? || proposal.voted?
      ret[:mustache][:texts][:vote_bar]= {
        start: "INIZIO VOTAZIONE:<br/>#{(l proposal.vote_period.starttime).upcase}",
        end: "TERMINE VOTAZIONE:<br/>#{proposal.vote_period.endtime}".upcase
      }
      ret[:mustache][:proposal][:vote_percentage] = [((Time.now - proposal.vote_period.starttime)/proposal.vote_period.duration.to_f)*100, 100].min
      ret[:mustache][:proposal][:voters_percentage] = (proposal.user_votes_count.to_f/proposal.eligible_voters_count.to_f)*100
    end
    ret
  end

  def section_for_mustache(section, i)
    { mustache: {
      section: { id: i,
                 seq: section.seq,
                 removeSection: t('pages.proposals.edit.remove_section'),
                 title: section.title,
                 paragraphId: section.paragraph.id,
                 content: section.paragraph.content,
                 contentDirty: section.paragraph.content_dirty,
                 persisted: true } } }
  end

  def solution_for_mustache(solution, i)
    title_interpolation = "pages.proposals.edit.new_solution_title.#{solution.proposal.proposal_type.name.downcase}"
    placeholder_interpolation = "pages.proposals.edit.insert_title.#{solution.proposal.proposal_type.name.downcase}"
    { mustache: {
      solution: { id: i,
                  seq: solution.seq,
                  persisted: true,
                  title_placeholder: t(placeholder_interpolation),
                  solution_title: t(title_interpolation, num: i + 1),
                  title: solution.title,
                  removeSolution: t('pages.proposals.edit.remove_solution'),
                  addParagraph: t('pages.proposals.edit.add_paragraph_to_solution'),
                  sections: solution.sections.map.with_index do |section, j|
                    solution_section_for_mustache(section, i, j)[:mustache]
                  end } } }
  end

  def solution_section_for_mustache(section, i, j)
    { mustache: {
      section: { idx: j,
                 id: section.id,
                 data_id: (i + 1) * 100 + j,
                 seq: section.seq,
                 removeSection: t('pages.proposals.edit.remove_section'),
                 title: section.title,
                 paragraphId: section.paragraph.id,
                 content: section.paragraph.content,
                 contentDirty: section.paragraph.content_dirty,
                 persisted: true },
      solution: { id: i } } }
  end

  def proposal_tag(proposal, _options = {})
    ret = "<div class='proposal_tag'>"
    ret += link_to_proposal(proposal)
    ret += '</div>'
    ret.html_safe
  end

  def link_to_proposal(proposal, options = {})
    link_to proposal.title, url_for_proposal(proposal), options
  end

  def url_for_proposal(proposal, options = {})
    proposal.group ? group_proposal_url(proposal.group, proposal, options) : proposal_url(proposal, options)
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
