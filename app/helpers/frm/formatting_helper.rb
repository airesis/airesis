module Frm
  module FormattingHelper
    # override with desired markup formatter, e.g. textile or markdown
    def as_formatted_html(text)
      if Frm.formatter
        Frm.formatter.format(as_sanitized_text(text))
      else
        simple_format(h(text))
      end
    end

    def as_quoted_text(text)
      if Frm.formatter && Frm.formatter.respond_to?(:blockquote)
        Frm.formatter.blockquote(as_sanitized_text(text)).html_safe
      else
         "<blockquote>#{(h(text))}</blockquote>\n\n".html_safe
      end
    end

    def as_sanitized_text(text)
      if Frm.formatter.respond_to?(:sanitize)
        Frm.formatter.sanitize(text)
      else
        sanitize(text, :tags=>%W(p, img), :attributes=>['src'])
      end
    end
  end
end
