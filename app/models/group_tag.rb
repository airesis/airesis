class GroupTag < ActiveRecord::Base
  belongs_to :group
  belongs_to :tag

  after_create :increment_counter_cache
  after_destroy :decrement_counter_cache

  private

  def decrement_counter_cache
    territory = group.interest_border.is_continente? ? group.interest_border : group.interest_border.country
    tag.tag_counters.find_or_create_by(territory: territory) do |tag_counter|
      tag_counter.groups_count = tag_counter.groups_count - 1
    end
  end

  def increment_counter_cache
    territory = group.interest_border.is_continente? ? group.interest_border : group.interest_border.country
    tag.tag_counters.find_or_create_by(territory: territory) do |tag_counter|
      tag_counter.groups_count = tag_counter.groups_count + 1
    end
  end
end
