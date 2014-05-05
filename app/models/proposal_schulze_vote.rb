class ProposalSchulzeVote < ActiveRecord::Base
  belongs_to :proposal, class_name: 'Proposal', foreign_key: :proposal_id

  def description
    desc = ""
    #ids is an array of two. each element with his previous delimiter
    solution_ids = self.proposal.solutions.pluck(:id)
    ids = self.preferences.scan(/(;|,|)(\d+)/).map{|d,n| [d,n.to_i]}.each do |d,n|
      desc += (d == ',' ? ' , ' : ' </br>') unless d.empty?
      desc +=  I18n.t("pages.proposals.edit.new_solution_title.#{self.proposal.proposal_type.name.downcase}",num: solution_ids.index(n)+1) + Solution.where(id: n).pluck(:title).first.to_s #bugfix if no title defined
    end
    desc.html_safe
  end
end
