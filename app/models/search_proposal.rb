class SearchProposal < ActiveRecord::Base
  belongs_to :group
  belongs_to :user
  belongs_to :group_area
  belongs_to :proposal_category
  belongs_to :proposal_type
  belongs_to :tag
  belongs_to :interest_border


  attr_accessor :order_id, :time_type, :order_dir, :page, :per_page, :text, :or, :proposal_id

  ORDER_RANDOM="1"
  ORDER_BY_DATE="2"
  ORDER_BY_RANK="3"
  ORDER_BY_VOTES="4" #order by number of valutations
  ORDER_BY_END="5"
  ORDER_BY_VOTATION_END="6"
  ORDER_BY_VOTES_NUMBER="7" #orde by number of votes
  ORDER_ASC="a"
  ORDER_DESC="d"


  def results
    @search = Proposal.search(include: [:category, :quorum, {users: [:image]}, :vote_period, :groups, :supporting_groups, :interest_borders]) do

      fulltext self.text, minimum_match: self.or if self.text
      all_of do
        if self.proposal_state_id
          if self.proposal_state_id == ProposalState::TAB_VOTATION
            @states = [ProposalState::WAIT, ProposalState::WAIT_DATE, ProposalState::VOTING]
          elsif self.proposal_state_id == ProposalState::TAB_VOTED
            @states = [ProposalState::ACCEPTED, ProposalState::REJECTED]
          elsif self.proposal_state_id == ProposalState::TAB_REVISION
            @states = [ProposalState::ABANDONED]
          else
            @states = [ProposalState::VALUTATION]
          end
          with(:proposal_state_id, @states) #search for specific state if defined
        end

        with(:proposal_category_id, self.proposal_category_id) if self.proposal_category_id

        with(:proposal_type_id, self.proposal_type_id) if self.proposal_type_id
        without(:proposal_type_id, 11) #TODO removed petitions

        if self.created_at_from
          ends = self.created_at_to || Time.now
          with(:created_at).between(self.created_at_from..ends)
        end

        #sicurezza - replicare nelle ricerche
        if self.group_id #if we are searching in groups
          any_of do #the proposal should satisfy one of the following
            all_of do #should be public and supported by the group
              with(:private, false)
              with(:supporting_group_ids, self.group_id)
            end
            all_of do #or inside the group but visible outside
              with(:visible_outside, true)
              with(:group_ids, self.group_id)
            end
            if self.user && (self.user.can? :view_proposal, Group.find(self.group_id)) #if the user is logged in and can view group private proposals
              all_of do #show also group private proposals
                with(:private, true)
                with(:group_ids, self.group_id)
              end
            end
          end
          areas = self.user ? self.user.scoped_areas(self.group, GroupAction::PROPOSAL_VIEW).pluck('group_areas.id') : [] #get all areas ids the user ca view
          any_of do
            with(:presentation_area_ids, nil)
            with(:presentation_area_ids, areas) unless areas.empty?
          end #the proposals should not be in an area or the user must be authorized to view them

          with(:presentation_area_ids, self.group_area_id) if self.group_area_id #only proposals in the group area if required

        else #open space proposals
          any_of do
            with(:private, false)
            with(:visible_outside, true)
          end
        end
      end

      dir = (self.order_dir == 'a') ? :asc : :desc
      if self.order_id == SearchProposal::ORDER_BY_RANK
        order_by :rank, dir
        order_by :created_at, dir
      elsif self.order_id == SearchProposal::ORDER_BY_VOTES
        order_by :valutations, dir
        order_by :created_at, dir
      elsif self.order_id == SearchProposal::ORDER_BY_END
        order_by :quorum_ends_at, dir
        order_by :valutations, dir
      elsif self.order_id == SearchProposal::ORDER_BY_VOTATION_END
        order_by :votation_ends_at, dir
        order_by :votes, dir
      elsif self.order_id == SearchProposal::ORDER_BY_VOTES_NUMBER
        order_by :votes, dir
        order_by :votation_ends_at, dir
      else
        order_by :updated_at, dir
        order_by :created_at, dir
      end

      paginate page: self.page, per_page: self.per_page if self.page && self.per_page
    end

    @proposals = @search.results

  end


  def similar
    search = Proposal.search do
      fulltext(self.text, minimum_match: 1) do
        fields(:title, :content, :tags_list)
        boost(10.0) { with(:group_ids, self.user.groups.pluck(:id)) } if self.user
      end
      secure_retrieve(self)
      paginate page: 1, per_page: 10
    end
    search.results
  end


  def secure_retrieve(sunspot)
    sunspot.instance_eval do
      #sicurezza - replicare nelle ricerche
      if self.group_id #if we are searching in groups
        any_of do #the proposal should satisfy one of the following
          all_of do #should be public and supported by the group
            with(:private, false)
            with(:supporting_group_ids, self.group_id)
          end
          all_of do #or inside the group but visible outside
            with(:visible_outside, true)
            with(:group_ids, self.group_id)
          end
          if self.user && (self.user.can? :view_proposal, Group.find(self.group_id)) #if the user is logged in and can view group private proposals
            all_of do #show also group private proposals
              with(:private, true)
              with(:group_ids, self.group_id)
            end
          end
        end
        areas = self.user ? self.user.scoped_areas(self.group, GroupAction::PROPOSAL_VIEW).pluck('group_areas.id') : [] #get all areas ids the user ca view
        any_of do
          with(:presentation_area_ids, nil)
          with(:presentation_area_ids, areas) unless areas.empty?
        end #the proposals should not be in an area or the user must be authorized to view them

        with(:presentation_area_ids, self.group_area_id) if self.group_area_id #only proposals in the group area if required
      else #open space proposals
        any_of do
          with(:private, false)
          with(:visible_outside, true)
          if self.user
            all_of do #show also group private proposals
              with(:private, true)
              with(:group_ids, self.user.groups.pluck(:id))
            end
          end
        end
      end
    end
  end


  def order
    order_s = ""
    dir = (self.order_dir == 'a') ? 'asc' : 'desc'
    if self.order_id == SearchProposal::ORDER_BY_RANK
      order_s << " proposals.rank #{dir}, proposals.created_at #{dir}"
    elsif self.order_id == SearchProposal::ORDER_BY_VOTES
      order_s << " proposals.valutations #{dir}, proposals.created_at #{dir}"
    elsif self.order_id == SearchProposal::ORDER_BY_END
      order_s << " quorums.ends_at #{dir}, proposals.valutations #{dir}"
    else
      order_s << "proposals.updated_at #{dir}, proposals.created_at #{dir}"
    end
    order_s
  end

end
