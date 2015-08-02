module Frm
  class CategoryTag < Frm::FrmTable
    belongs_to :category, foreign_key: 'frm_category_id'
    belongs_to :tag

    after_create :increment_counter_cache
    after_destroy :decrement_counter_cache

    private

    def decrement_counter_cache
      tag.frm_categories_count = tag.frm_categories_count - 1
      tag.save
    end

    def increment_counter_cache
      tag.frm_categories_count = tag.frm_categories_count + 1
      tag.save
    end
  end
end
