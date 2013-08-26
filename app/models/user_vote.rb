class UserVote < ActiveRecord::Base
  belongs_to :user, :class_name => 'User', :foreign_key => :user_id
  belongs_to :proposal, :class_name => 'Proposal', :foreign_key => :proposal_id
  belongs_to :vote_type, :class_name => 'VoteType', :foreign_key => :vote_type_id
  validates :user_id, :uniqueness => {:scope => :proposal_id}


  #TODO
  def desc_vote_schulze
    #ids = self.vote_schulze.split(/;|,/).map{|a| a.to_i}
    #titles = Solution.where(['id in (?)',ids]).pluck(:title)
    #@u.vote_schulze.gsub(/\d/,'').split('')
    #titles.join(',')
    self.vote_schulze
  end
end
