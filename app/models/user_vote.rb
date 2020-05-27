class UserVote < ApplicationRecord
  belongs_to :user
  belongs_to :proposal, counter_cache: true
  belongs_to :vote_type, optional: true
  validates :user_id, uniqueness: { scope: :proposal_id }

  def desc_vote_schulze
    desc = ''
    # ids is an array of two. each element with his previous delimiter
    solution_ids = proposal.solutions.pluck(:id)
    vote_schulze.scan(/(;|,|)(\d+)/).map { |d, n| [d, n.to_i] }.each do |d, n|
      desc += (d == ',' ? ' , ' : ' </br>') unless d.empty?
      desc += I18n.t("pages.proposals.edit.new_solution_title.#{proposal.proposal_type.name.downcase}",
                     num: solution_ids.index(n) + 1) + Solution.where(id: n).pluck(:title).first.to_s
    end
    desc.html_safe
  end
end
