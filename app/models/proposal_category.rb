class ProposalCategory < ActiveRecord::Base
  has_many :proposals, class_name: 'Proposal'

  def description
    I18n.t("db.#{self.class.class_name.tableize}.#{name}.description")
  end

  # extract the list of proposal categories for the left menu.
  # in public space shows all categories. In groups shows only the categories which have at least one proposal
  def self.for_menu(group)
    if group
      joins = 'left join proposals on proposals.proposal_category_id = proposal_categories.id left join proposal_supports on proposals.id = proposal_supports.proposal_id  left join group_proposals on proposals.id = group_proposals.proposal_id'
      conditions = "((proposal_supports.group_id = #{group.id} and proposals.private = 'f') or (group_proposals.group_id = #{group.id} and proposals.private = 't'))"
      ProposalCategory.joins(joins).where(conditions).order('proposal_categories.seq desc').group(ProposalCategory.column_names.map { |col| "#{ProposalCategory.table_name}.#{col}" }.join(','))
    else
      ProposalCategory.order('proposal_categories.seq desc')
    end
  end
end
