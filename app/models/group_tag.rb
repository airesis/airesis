class GroupTag < ActiveRecord::Base

	belongs_to :group
	belongs_to :tag


  after_create  :increment_counter_cache
  after_destroy :decrement_counter_cache

  private
  def decrement_counter_cache
    tag.groups_count = tag.groups_count - 1
    tag.save
  end

  def increment_counter_cache
    tag.groups_count = tag.groups_count + 1
    tag.save
  end
end