class Tag < ApplicationRecord
  has_many :proposal_tags
  has_many :proposals, through: :proposal_tags
  has_many :blog_post_tags
  has_many :blog_posts, through: :blog_post_tags
  has_many :tag_counters

  scope :most_used, ->(territory, limit = 10) { very_used(territory, limit).order(Arel.sql('random()')) }

  scope :most_groups, ->(territory, limit = 40) { used_in_groups(territory).limit(limit) }

  scope :most_blogs, ->(territory, limit = 40) { used_in_blogs(territory).limit(limit) }

  scope :for_twitter, -> { pluck(:text).map { |t| "##{t}" }.join(', ') }

  before_save :escape_text

  def as_json(_options = {})
    { id: text, name: text }
  end

  def nearest
    query = ActiveRecord::Base.send(:sanitize_sql_array, ["select tt3.id, tt3.text
                from tags tt3 where
                tt3.id in (
                SELECT t2p2.tag_id
                FROM (SELECT proposal_id FROM tags t1
                  JOIN proposal_tags
                  ON t1.id = proposal_tags.tag_id
                  WHERE t1.text = ? LIMIT 10
                  ) AS t2p1
                JOIN proposal_tags t2p2
                ON t2p1.proposal_id = t2p2.proposal_id
                JOIN tags t2
                ON t2p2.tag_id = t2.id
                GROUP BY t2p2.tag_id LIMIT 11)
                and tt3.text != ?", text, text])
    Tag.find_by_sql query
  end

  def self.territory_filter(territory)
    tag_counters_t = TagCounter.arel_table
    arel_conditions = tag_counters_t[:territory_id].eq(territory.id).
                      and(tag_counters_t[:territory_type].eq(territory.class.name))
    if territory.is_a?(Continent)
      arel_conditions = arel_conditions.or(tag_counters_t[:territory_id].in(territory.countries.pluck(:id)).
                                             and(tag_counters_t[:territory_type].eq(Country.class_name)))
    end
    arel_conditions
  end

  def self.very_used(territory, limit = 40)
    joins(:tag_counters).
      where(territory_filter(territory)).
      where('(blog_posts_count + proposals_count + groups_count) > ?', limit).
      select('tags.*, blog_posts_count, proposals_count, groups_count')
  end

  def self.used_in_groups(territory)
    used_in(territory, :groups_count)
  end

  def self.used_in_blogs(territory)
    used_in(territory, :blog_posts_count)
  end

  def self.used_in(territory, object_name)
    joins(:tag_counters).
      where(territory_filter(territory)).
      where(TagCounter.arel_table[object_name].gt(0)).
      order(TagCounter.arel_table[object_name].desc).
      select("tags.*, #{object_name}")
  end

  protected

  def escape_text
    self.text = text.strip.downcase.delete('.').delete("'").delete('/')
  end
end
