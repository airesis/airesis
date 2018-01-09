class Search < ActiveRecord::Base
  attr_accessor :groups, :proposals, :user_id, :blogs

  def find
    user = User.find(user_id)
    ability = Ability.new user
    # groups_a = user.portavoce_groups.pluck(:id)
    # groups_b = user.groups.pluck(:id) - groups_a # don't boost for both

    self.groups = Group.search(q, true).accessible_by(ability).limit(5)

    # list_a = user.proposals.pluck('proposals.id')
    # list_b = user.partecipating_proposals.pluck('proposals.id') - list_a # don't boosts for both please

    self.proposals = Proposal.search(q).accessible_by(ability, :index, false).
                     select('proposals.*', "#{PgSearch::Configuration.alias('proposals')}.rank").limit(5)

    self.blogs = Blog.search(q, true).limit(5)
  end
end
