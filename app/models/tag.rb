class Tag < ActiveRecord::Base
  
  has_many :proposal_tags, :class_name => 'ProposalTag'
  has_many :proposals, :through => :proposal_tags, :class_name => 'Proposal'
  
  has_many :blog_post_tags, :class_name => 'BlogPostTag'

  has_many :blog_posts, :through => :blog_post_tags, :class_name => 'BlogPost'
  
  def as_json(options={})    
   { :id => self.text, :name => self.text }
  end



  def nearest
   Tag.find_by_sql "select tt3.id, tt3.text
                from tags tt3 where
                tt3.id in (
                SELECT t2p2.tag_id
                FROM (SELECT proposal_id FROM tags t1
                  JOIN proposal_tags
                  ON t1.id = proposal_tags.tag_id
                  WHERE t1.text = '#{self.text}' LIMIT 10
                  ) AS t2p1
                JOIN proposal_tags t2p2
                ON t2p1.proposal_id = t2p2.proposal_id
                JOIN tags t2
                ON t2p2.tag_id = t2.id
                GROUP BY t2p2.tag_id LIMIT 11)
                and tt3.text != '#{self.text}'"
  end
end
