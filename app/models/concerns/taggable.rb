module Concerns
  module Taggable
    extend ActiveSupport::Concern

    included do
      before_save :save_tags, if: :not_resaving?
      attr_accessible :tags_list
    end

    def tags_list
      @tags_list ||= self.tags.map(&:text).join(', ')
    end

    def tags_list_json
      @tags_list ||= self.tags.map(&:text).join(', ')
    end

    def tags_data
      self.tags.map{|t| {id: t.text, name: t.text}}.to_json
    end

    def tags_list=(tags_list)
      @tags_list = tags_list
    end

    def tags_with_links
      html = self.tags.collect { |t| "<a href=\"/tags/#{t.text.strip}\">#{t.text.strip}</a>" }.join(', ')
      return html
    end

    def save_tags
      if @tags_list
        tids = []
        @tags_list.split(/,/).each do |tag|
          stripped = tag.strip.downcase.gsub('.', '')
          t = Tag.find_or_create_by(text: stripped)
          tids << t.id
        end
        self.tag_ids = tids
      end
    end

    def not_resaving?
      !@resaving
    end
  end
end