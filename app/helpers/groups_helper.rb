module GroupsHelper

  def group_link_to(name, path, options={})
    link_to name, path, options

  end

  def group_proposals_path(group)
    group.certified && request.subdomain == group.subdomain ?
        proposals_path :
        super
  end

  def group_events_path(group)
    group.certified && request.subdomain == group.subdomain ?
        events_path :
        super
  end

  def group_documents_path(group)
    group.certified && request.subdomain == group.subdomain ?
        documents_path :
        super
  end

end
