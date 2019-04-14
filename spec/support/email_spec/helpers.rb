module EmailSpec
  module Helpers
    def links_in_email(email)
      part = email.default_part
      if %r{text/html}.match?(part.content_type)
        Nokogiri::HTML::Document.parse(part.body.to_s).search('a').map { |a| a[:href] }
      else
        URI.extract(part.body.to_s, %w[http https])
      end
    end
  end
end
