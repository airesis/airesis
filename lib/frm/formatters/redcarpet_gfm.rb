require 'redcarpet'

module Frm
  module Formatters
    class RedcarpetGfm
      def self.format(text)
        formatter = ::Redcarpet::Markdown.new(::Redcarpet::Render::HTML,
          :no_intra_emphasis => true, :fenced_code_blocks => true,
          :autolink => true, :lax_html_blocks => true)
        formatter.render(ERB::Util.h(text)).html_safe
      end


      def self.blockquote(text)
        text.split("\n").map do |line|
          "> " + line
        end.join("\n")
      end
    end
  end
end
