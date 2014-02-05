class ProposalSchulzeVote < ActiveRecord::Base
  belongs_to :proposal, :class_name => 'Proposal', :foreign_key => :proposal_id

  def description
    desc = ""
    #ids is an array of two. each element with his previous delimiter
    ids = self.preferences.scan(/(;|,|)(\d+)/).map{|d,n| [d,n.to_i]}.each do |d,n|
      desc += (d == ',' ? ' , ' : ' </br>') unless d.empty?
      desc += Solution.where(:id => n).pluck(:title).first.to_s #bugfix if no title defined
    end
    desc.html_safe
  end
end
