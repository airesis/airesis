module Frm
  module FormattingHelper
    # override with desired markup formatter, e.g. textile or markdown
    def as_formatted_html(text)
      simple_format(h(text))
    end

    def as_quoted_text(text)
      "<p><blockquote>#{(h(text))}</blockquote></p><p></p>".html_safe
    end

    def as_sanitized_text(text)
        sanitize(text, :tags=>%W(p, img), :attributes=>['src'])
    end
  end
end
