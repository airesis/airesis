class GroupTag < ApplicationRecord
  belongs_to :group
  belongs_to :tag

  after_create :increment_counter_cache
  after_destroy :decrement_counter_cache

  private

  def decrement_counter_cache
    territory = group.interest_border.is_continent? ? group.interest_border : group.interest_border.country
    tag_counter = tag.tag_counters.find_or_create_by(territory: territory)
    tag_counter.decrement!(:groups_count)
  end

  def increment_counter_cache
    territory = group.interest_border.is_continent? ? group.interest_border : group.interest_border.country
    tag_counter = tag.tag_counters.find_or_create_by(territory: territory)
    tag_counter.increment!(:groups_count)
  end
end
