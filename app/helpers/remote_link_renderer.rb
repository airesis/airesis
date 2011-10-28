class RemoteLinkRenderer < WillPaginate::LinkRenderer
  def initialize(collection, options, template)
    @remote = options.delete(:remote)
    super
  end

  def page_link_or_span(page, span_class = 'current', text = nil)
    text ||= page.to_s
    if page and page != current_page
      @template.link_to_remote(text, {:url => url_options(page), :method => :get}.merge(@remote))
    else
      @template.content_tag :span, text, :class => span_class
    end
  end
end