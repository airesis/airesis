class SearchProposal < ActiveRecord::Base
  belongs_to :group
  belongs_to :user
  belongs_to :group_area
  belongs_to :proposal_category
  belongs_to :proposal_type
  belongs_to :tag
  belongs_to :interest_border

  attr_accessor :order_id, :time_type, :order_dir

  def results
    @results = Proposal
    if self.proposal_category_id
      @results = @results.in_category(self.proposal_category_id)
    end
    if self.proposal_type_id
      @results = @results.where(:proposal_type_id =>  self.proposal_type_id)
    end
    if self.created_at_from
      ends = self.created_at_to || Time.now
      @results = @results.where(['proposals.created_at > :from AND proposals.created_at <= :to',{from: self.created_at_from, to: ends}])
    end
    if self.proposal_state_id
      if self.proposal_state_id == ProposalState::TAB_VOTATION
        @results = @results.in_votation
      elsif self.proposal_state_id == ProposalState::TAB_VOTED
        @results = @results.voted
      elsif self.proposal_state_id == ProposalState::TAB_REVISION
        @results = @results.revision
      else
        @results = @results.in_valutation
      end
    end
    if self.group_id
      #include in the results all public proposals supported by the group and all the group public proposals
      conditions = " ((proposal_supports.group_id = #{self.group_id} and proposals.private = 'f') or (group_proposals.group_id = #{self.group_id} and proposals.visible_outside = 't')"
      if user.can? :view_proposal, Group.find(self.group_id)
        conditions += " or (group_proposals.group_id = #{self.group_id} and proposals.private = 't')"
      end
      conditions += ")"
      @results = @results.includes(:proposal_supports, :group_proposals, :quorum).where(conditions)

      if self.group_area_id
        @results = @results.in_group_area(self.group_area_id)
      else
        if self.user_id
          @results = @results.joins('left join area_proposals on proposals.id = area_proposals.proposal_id').where("area_proposals.group_area_id is null or (area_proposals.group_area_id in (#{self.user.scoped_areas(self.group, GroupAction::PROPOSAL_VIEW).select('group_areas.id').to_sql})  or proposals.visible_outside = 't')")
        end
      end
      unless self.user_id
        @results = @results.where("proposals.private = 'f' or (proposals.private = 't' and proposals.visible_outside = 't')")
      end
    else
      @results = @results.public
    end

    @results.order(self.order)
  end

  def order
    order_s = ""
    dir = (self.order_dir == 'a') ? 'asc' : 'desc'
    if self.order_id == ORDER_BY_RANK
      order_s << " proposals.rank #{dir}, proposals.created_at #{dir}"
    elsif self.order_id == ORDER_BY_VOTES
      order_s << " proposals.valutations #{dir}, proposals.created_at #{dir}"
    elsif self.order_id == ORDER_BY_END
      order_s << " quorums.ends_at #{dir}, proposals.valutations #{dir}"
    else
      order_s << "proposals.updated_at #{dir}, proposals.created_at #{dir}"
    end
    order_s
  end
end
