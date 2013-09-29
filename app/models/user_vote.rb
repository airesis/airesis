class UserVote < ActiveRecord::Base
  belongs_to :user, :class_name => 'User', :foreign_key => :user_id
  belongs_to :proposal, :class_name => 'Proposal', :foreign_key => :proposal_id
  belongs_to :vote_type, :class_name => 'VoteType', :foreign_key => :vote_type_id
  validates :user_id, :uniqueness => {:scope => :proposal_id}


  #TODO
  def desc_vote_schulze
    desc = ""
    #ids is an array of two. each element with his previous delimiter
    ids = self.vote_schulze.scan(/(;|,|)(\d+)/).map{|d,n| [d,n.to_i]}.each do |d,n|
      desc += (d == ',' ? ' , ' : ' </br>') unless d.empty?
      desc += Solution.where(:id => n).pluck(:title).first
    end
    desc.html_safe
  end
end
