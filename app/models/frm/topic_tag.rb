module Frm
  class TopicTag < Frm::FrmTable
    belongs_to :forum, foreign_key: 'frm_forum_id'
    belongs_to :tag

    after_create :increment_counter_cache
    after_destroy :decrement_counter_cache

    private

    def decrement_counter_cache
      tag.frm_topics_count = tag.frm_topics_count - 1
      tag.save
    end

    def increment_counter_cache
      tag.frm_topics_count = tag.frm_topics_count + 1
      tag.save
    end
  end
end
