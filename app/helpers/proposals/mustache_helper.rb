module Proposals
  module MustacheHelper
    def proposal_for_mustache(proposal)
      ret = {
        mustache: {
          now: (l Time.now),
          proposal: {
            good_score: (proposal.quorum.good_score),
            'voted?' => proposal.voted?,
            'voting_or_voted?' => proposal.voting? || proposal.voted?,
            rank: proposal.rank,
            percentage: proposal.percentage,
            'show_rank_bar?' => (proposal.percentage >= 1),
            'show_current_cursor?' => (proposal.percentage <= 98)
          },
          texts: {
            rank_bar: {
              creation: t('pages.proposals.new_rank_bar.creation', time_ago: time_ago_in_words(proposal.created_at).upcase, date: (l proposal.created_at, format: :long).upcase),
              end: t('pages.proposals.new_rank_bar.end', date: proposal.quorum.end_desc.upcase),
              now: t('pages.proposals.new_rank_bar.now', left: proposal.quorum.time_left).upcase,
              good_score: t('pages.proposals.new_rank_bar.good_score', score: proposal.quorum.good_score)
            }
          }
        }
      }
      if proposal.voting? || proposal.voted?
        ret[:mustache][:texts][:vote_bar] = {
          start: "INIZIO VOTAZIONE:<br/>#{(l proposal.vote_period.starttime).upcase}",
          end: "TERMINE VOTAZIONE:<br/>#{proposal.vote_period.endtime}".upcase
        }
        ret[:mustache][:proposal][:vote_percentage] = [((Time.now - proposal.vote_period.starttime) / proposal.vote_period.duration.to_f) * 100, 100].min
        ret[:mustache][:proposal][:voters_percentage] = (proposal.user_votes_count.to_f / proposal.eligible_voters_count) * 100
      end
      ret
    end

    def proposal_list_element_for_mustache(proposal)
      ret = proposal_for_mustache(proposal)
      ret[:mustache][:proposal].merge!(id: proposal.id,
                                       time_left: (proposal.quorum.time_left.upcase if proposal.in_valutation?),
                                       vote_time_left: (proposal.vote_period.time_left.upcase if proposal.voting?),
                                       'in_valutation?' => proposal.in_valutation?,
                                       'voting?' => proposal.voting?,
                                       voters: "#{proposal.user_votes_count}/#{proposal.eligible_voters_count}",
                                       participants: proposal.participants_count,
                                       contributes_count: proposal.proposal_contributes_count,
                                       'has_interest_borders?' => proposal.interest_borders.any?,
                                       interest_border: (proposal.interest_borders.first.territory.description if proposal.interest_borders.any?),
                                       type_description: proposal.proposal_type.description.upcase,
                                       group_image_tag: proposal_group_image_tag(proposal),
                                       status: proposal_status(proposal),
                                       short_content: proposal.short_content,
                                       vote_url: (proposal.private ? group_proposal_url(proposal.groups.first, proposal) : proposal_url(proposal)),
                                       title_link: link_to_proposal(proposal, style: (proposal.rejected? ? 'text-decoration: line-through;' : ''), title: proposal.title))
      ret[:mustache][:images] = {
        time_description: (image_tag 'plist/stopwatch.png'),
        group_participants: (image_tag 'group_participants.png'),
        group_proposals: (image_tag 'group_proposals.png'),
        rank: (image_tag 'plist/gradimento.png'),
        place: (image_tag 'place.png')
      }
      ret[:mustache][:texts].merge!(
        conditions_left: t('pages.proposals.list.condition_left').upcase,
        time_left: t('pages.proposals.list.time_left').upcase,
        voters: t('pages.proposals.index.voters'),
        rank: t('pages.proposals.index.rank'),
        participants_number: t('pages.proposals.index.participants_number'),
        contributes_number: t('pages.proposals.index.contributes_number'),
        vote: t('pages.proposals.list.vote')
      )
      ret[:mustache][:current_user] = {
        'signed_in?' => signed_in?,
        'can_vote?' => (can? :vote, proposal),
        notifications: proposal.alerts_count,
        'show_alerts?' => (proposal.alerts_count > 0),
        valutation_image: (user_valutation_image(current_user, proposal) if current_user)
      }
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
  end
end
