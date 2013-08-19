module GroupsHelper

  def group_url(group,option={})
    group.certified? ?
      root_url(:subdomain => group.subdomain) :
      super
  end

  def group_candidates_url(group, options={})
    (in_subdomain? group) ?
        candidates_url(options) :
        super
  end

  def group_proposals_url(group, options={})
    (in_subdomain? group) ?
        proposals_url(options) :
        super
  end

  def group_proposal_url(group,proposal, options={})
    (in_subdomain? group) ?
        proposal_url(proposal) :
        super
  end

  def edit_group_proposal_url(group,proposal,option={})
    (in_subdomain? group) ?
        edit_proposal_url(proposal) :
        super
  end


  def group_events_url(group, options={})
    (in_subdomain? group) ?
        events_url :
        super
  end

  def group_documents_url(group, options={})
    (in_subdomain? group) ?
        documents_url :
        super
  end

  private

  def in_subdomain?(group)
    group.certified && (request.subdomain == group.subdomain)
  end
end
