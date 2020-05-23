module Taggable
  extend ActiveSupport::Concern

  included do
    before_save :save_tags, if: :not_resaving?
  end

  def tags_list
    @tags_list ||= tags.map(&:text).join(', ')
  end

  def tags_list_json
    @tags_list ||= tags.map(&:text).join(', ')
  end

  def tags_data
    tags.map { |t| { id: t.text, name: t.text } }.to_json
  end

  attr_writer :tags_list

  def tags_with_links
    tags.collect { |t| "<a href=\"/tags/#{t.text.strip}\">#{t.text.strip}</a>" }.join(', ')
  end

  def save_tags
    return unless @tags_list
    tids = []
    @tags_list.split(/,/).each do |tag|
      stripped = tag.strip.downcase.delete('.')
      t = Tag.find_or_create_by(text: stripped)
      tids << t.id
    end
    self.tag_ids = tids
  end

  def not_resaving?
    !@resaving
  end
end
