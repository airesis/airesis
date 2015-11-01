class SearchProposal < ActiveRecord::Base
  belongs_to :group
  belongs_to :user
  belongs_to :group_area
  belongs_to :proposal_category
  belongs_to :proposal_type
  belongs_to :tag
  belongs_to :interest_border

  attr_accessor :order_id, :time_type, :order_dir, :page, :per_page, :text, :or, :proposal_id

  ORDER_RANDOM = '1'
  ORDER_BY_DATE = '2'
  ORDER_BY_RANK = '3'
  ORDER_BY_VOTES = '4' # order by number of valutations
  ORDER_BY_END = '5'
  ORDER_BY_VOTATION_END = '6'
  ORDER_BY_VOTES_NUMBER = '7' # orde by number of votes
  ORDER_ASC = 'a'
  ORDER_DESC = 'd'

  def results
    @search = Proposal.search(include: [:category, :quorum, { users: [:image] }, :vote_period, :groups, :supporting_groups, :interest_borders]) do
      fulltext text, minimum_match: self.or if text
      all_of do
        if proposal_state_id
          if proposal_state_id == ProposalState::TAB_VOTATION
            @states = [ProposalState::WAIT, ProposalState::WAIT_DATE, ProposalState::VOTING]
          elsif proposal_state_id == ProposalState::TAB_VOTED
            @states = [ProposalState::ACCEPTED, ProposalState::REJECTED]
          elsif proposal_state_id == ProposalState::TAB_REVISION
            @states = [ProposalState::ABANDONED]
          else
            @states = [ProposalState::VALUTATION]
          end
          with(:proposal_state_id, @states) # search for specific state if defined
        end

        with(:proposal_category_id, proposal_category_id) if proposal_category_id

        with(:proposal_type_id, proposal_type_id) if proposal_type_id
        without(:proposal_type_id, 11) # TODO: removed petitions

        if created_at_from
          ends = created_at_to || Time.now
          with(:created_at).between(created_at_from..ends)
        end

        # sicurezza - replicare nelle ricerche
        if group_id # if we are searching in groups
          any_of do # the proposal should satisfy one of the following
            all_of do # should be public and supported by the group
              with(:private, false)
              with(:supporting_group_ids, group_id)
            end
            all_of do # or inside the group but visible outside
              with(:visible_outside, true)
              with(:group_ids, group_id)
            end
            if user && (user.can? :view_proposal, Group.find(group_id)) # if the user is logged in and can view group private proposals
              all_of do # show also group private proposals
                with(:private, true)
                with(:group_ids, group_id)
              end
            end
          end
          areas = user ? user.scoped_areas(group_id, GroupAction::PROPOSAL_VIEW).pluck('group_areas.id') : [] # get all areas ids the user ca view
          any_of do
            with(:presentation_area_ids, nil)
            with(:presentation_area_ids, areas) unless areas.empty?
            with(:visible_outside, true)
          end # the proposals should not be in an area or the user must be authorized to view them

          with(:presentation_area_ids, group_area_id) if group_area_id # only proposals in the group area if required

        else # open space proposals
          any_of do
            with(:private, false)
            with(:visible_outside, true)
          end
          with(interest_border.solr_search_field, interest_border.territory.id) if interest_border.present?
        end
      end

      dir = (order_dir == 'a') ? :asc : :desc
      if order_id == SearchProposal::ORDER_BY_RANK
        order_by :rank, dir
        order_by :created_at, dir
      elsif order_id == SearchProposal::ORDER_BY_VOTES
        order_by :valutations, dir
        order_by :created_at, dir
      elsif order_id == SearchProposal::ORDER_BY_END
        order_by :quorum_ends_at, dir
        order_by :valutations, dir
      elsif order_id == SearchProposal::ORDER_BY_VOTATION_END
        order_by :votation_ends_at, dir
        order_by :votes, dir
      elsif order_id == SearchProposal::ORDER_BY_VOTES_NUMBER
        order_by :votes, dir
        order_by :votation_ends_at, dir
      else
        order_by :updated_at, dir
        order_by :created_at, dir
      end
      paginate page: page, per_page: per_page if page && per_page
    end
    @proposals = @search.results
  end

  def similar
    search = Proposal.search do
      fulltext(text, minimum_match: 1) do
        fields(:title, :content, :tags_list)
        boost(10.0) { with(:group_ids, user.groups.pluck(:id)) } if user
      end
      secure_retrieve(self)
      paginate page: 1, per_page: 10
    end
    search.results
  end

  def secure_retrieve(sunspot)
    sunspot.instance_eval do
      # sicurezza - replicare nelle ricerche
      if group_id # if we are searching in groups
        any_of do # the proposal should satisfy one of the following
          all_of do # should be public and supported by the group
            with(:private, false)
            with(:supporting_group_ids, group_id)
          end
          all_of do # or inside the group but visible outside
            with(:visible_outside, true)
            with(:group_ids, group_id)
          end
          if user && (user.can? :view_proposal, Group.find(group_id)) # if the user is logged in and can view group private proposals
            all_of do # show also group private proposals
              with(:private, true)
              with(:group_ids, group_id)
            end
          end
        end
        areas = user ? user.scoped_areas(group_id, GroupAction::PROPOSAL_VIEW).pluck('group_areas.id') : [] # get all areas ids the user ca view
        any_of do
          with(:presentation_area_ids, nil)
          with(:presentation_area_ids, areas) unless areas.empty?
          with(:visible_outside, true)
        end # the proposals should not be in an area or the user must be authorized to view them

        with(:presentation_area_ids, group_area_id) if group_area_id # only proposals in the group area if required
      else # open space proposals
        any_of do
          with(:private, false)
          with(:visible_outside, true)
          if user
            all_of do # show also group private proposals
              with(:private, true)
              with(:group_ids, user.groups.pluck(:id))
            end
          end
        end
      end
    end
  end

  def order
    order_s = ''
    dir = (order_dir == 'a') ? 'asc' : 'desc'
    if order_id == SearchProposal::ORDER_BY_RANK
      order_s << " proposals.rank #{dir}, proposals.created_at #{dir}"
    elsif order_id == SearchProposal::ORDER_BY_VOTES
      order_s << " proposals.valutations #{dir}, proposals.created_at #{dir}"
    elsif order_id == SearchProposal::ORDER_BY_END
      order_s << " quorums.ends_at #{dir}, proposals.valutations #{dir}"
    else
      order_s << "proposals.updated_at #{dir}, proposals.created_at #{dir}"
    end
    order_s
  end
end
