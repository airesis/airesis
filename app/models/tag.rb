class Tag < ActiveRecord::Base
  
  has_many :proposal_tags, class_name: 'ProposalTag'
  has_many :proposals, through: :proposal_tags, class_name: 'Proposal'
  
  has_many :blog_post_tags, class_name: 'BlogPostTag'

  has_many :blog_posts, through: :blog_post_tags, class_name: 'BlogPost'

  scope :most_used, -> {where('(blog_posts_count + blogs_count + proposals_count + groups_count) > 10').order('random()')}


  scope :most_groups, -> {where('groups_count > 0').order('groups_count desc').limit(40)}
  scope :most_blogs, -> {where('blog_posts_count > 0').order('blog_posts_count desc').limit(40)}  #todo use blog_post for now

  scope :for_twitter, -> { pluck(:text).map{|t| "##{t}"}.join(', ')}

  def as_json(options={})    
   { id: self.text, name: self.text }
  end

  def nearest
   query =  ActiveRecord::Base.send(:sanitize_sql_array, ["select tt3.id, tt3.text
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
                and tt3.text != ?", self.text,self.text])
    Tag.find_by_sql query
  end


end
