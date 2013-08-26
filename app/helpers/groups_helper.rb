module GroupsHelper

  def group_url(group, options={})
    if group.certified?
      root_url(:subdomain => group.subdomain)
    else
      options[:subdomain] = false
      super
    end
  end

  def edit_group_url(group, options={})
    (group_in_subdomain? group) ?
        '/edit' :
        super
  end

  def partecipation_request_confirm_group_url(group, options={})
    if (group_in_subdomain? group)
      ret = '/partecipation_request_confirm'
      query = options.to_query
      ret += "?#{query}" unless query.empty?
    else
      super
    end
  end

  def partecipation_request_decline_group_url(group, options={})
    if (group_in_subdomain? group)
      ret = '/partecipation_request_decline'
      query = options.to_query
      ret += "?#{query}" unless query.empty?
    else
      super
    end
  end

  def edit_permissions_group_url(group, options={})
    (group_in_subdomain? group) ?
        '/edit_permissions' :
        super
  end

  def edit_proposals_group_url(group, options={})
    (group_in_subdomain? group) ?
        '/edit_proposals' :
        super
  end

  def permissions_list_group_path(group, options={})
    (group_in_subdomain? group) ?
        '/permissions_list' :
        super
  end

  def ask_for_partecipation_group_url(group, options={})
    (group_in_subdomain? group) ?
        '/ask_for_partecipation' :
        super
  end


  def group_group_areas_url(group, options={})
    (group_in_subdomain? group) ?
        group_areas_url(options) :
        super
  end

  def group_group_partecipations_url(group, options={})
    (group_in_subdomain? group) ?
        group_partecipations_url(options) :
        super
  end



  def group_candidates_url(group, options={})
    (group_in_subdomain? group) ?
        candidates_url(options) :
        super
  end

  def group_proposals_url(group, options={})
    if group_in_subdomain? group
      proposals_url(options)
    else
      options[:subdomain] = false
      super
    end
  end

  def group_proposal_url(group, proposal, options={})
    (group_in_subdomain? group) ?
        proposal_url(proposal) :
        super
  end

  def edit_group_proposal_url(group, proposal, option={})
    (group_in_subdomain? group) ?
        edit_proposal_url(proposal) :
        super
  end


  def group_events_url(group, options={})
    if group_in_subdomain? group
      events_url
    else
      options[:subdomain] = false
      super
    end
  end

  def group_documents_url(group, options={})
    (group_in_subdomain? group) ?
        documents_url :
        super
  end

  def new_group_candidate_url(group, options={})
    (group_in_subdomain? group) ?
        new_candidate_url(options) :
        super
  end


  def new_group_event_url(group, options={})
    (group_in_subdomain? group) ?
        new_event_url(options) :
        super
  end


  private

  def group_in_subdomain?(group)
    group.certified && (request.subdomain == group.subdomain)
  end
end
