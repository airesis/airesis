module ProposalCommentsHelper
  def link_to_rankup(proposal, proposal_comment)
    link_to_rank(rankup_proposal_proposal_comment_path(proposal, proposal_comment),
                 proposal_comment.id,
                 'icon-smile-change',
                 t('pages.proposals.show.voteup'))
  end

  def link_to_ranknil(proposal, proposal_comment)
    link_to_rank(ranknil_proposal_proposal_comment_path(proposal, proposal_comment),
                 proposal_comment.id,
                 'icon-baffled-change',
                 t('pages.proposals.show.votenil'))
  end

  def link_to_rankdown(proposal, proposal_comment)
    link_to_rank(rankdown_proposal_proposal_comment_path(proposal, proposal_comment),
                 proposal_comment.id,
                 'icon-sad-change',
                 t('pages.proposals.show.votedown'))
  end

  def link_to_rank(url, comment_id, klass, title)
    link_to '',
            url,
            remote: true, method: :put,
            data: { id: comment_id },
            class: "#{klass} vote_comment",
            title: title
  end
end
