class SearchProposal < ActiveRecord::Base
  belongs_to :group
  belongs_to :user
  belongs_to :group_area
  belongs_to :proposal_category
  belongs_to :proposal_type
  belongs_to :tag
  belongs_to :interest_border

  attr_accessor :order_id, :time_type, :order_dir, :page, :per_page, :text, :or, :proposal_id, :proposal_state_tab

  ORDER_RANDOM = '1'
  ORDER_BY_DATE = '2'
  ORDER_BY_RANK = '3'
  ORDER_BY_VOTES = '4' # order by number of valutations
  ORDER_BY_END = '5'
  ORDER_BY_VOTATION_END = '6'
  ORDER_BY_VOTES_NUMBER = '7' # order by number of votes
  ORDER_ASC = 'a'
  ORDER_DESC = 'd'

  def counters
    ret = { ProposalState::TAB_VOTATION => 0,
            ProposalState::TAB_VOTED => 0,
            ProposalState::TAB_REVISION => 0,
            ProposalState::TAB_DEBATE => 0 }
    search.reorder(nil).group(:proposal_state_id).count.each do |state, count|
      if [ProposalState::WAIT, ProposalState::WAIT_DATE, ProposalState::VOTING].include? state
        ret[ProposalState::TAB_VOTATION] += count
      elsif [ProposalState::ACCEPTED, ProposalState::REJECTED].include? state
        ret[ProposalState::TAB_VOTED] += count
      elsif [ProposalState::ABANDONED].include? state
        ret[ProposalState::TAB_REVISION] += count
      else
        ret[ProposalState::TAB_DEBATE] += count
      end
    end
    ret
  end

  def search
    proposals = text ? Proposal.search(text) : Proposal.all

    proposals = proposals.where.not(proposal_type_id: 11) # TODO: removed petitions

    if created_at_from
      ends = created_at_to || Time.now
      proposals = proposals.where(created_at: created_at_from..ends)
    end

    if proposal_category_id
      proposals = proposals.where(proposal_category_id: proposal_category_id)
    end

    if proposal_type_id
      proposals = proposals.where(proposal_type_id: proposal_type_id)
    end

    proposals = proposals.accessible_by(Ability.new(user), :index, false)

    if group_id
      proposals = proposals.
                  joins('LEFT JOIN proposal_supports on proposal_supports.proposal_id = proposals.id')
      proposals = proposals.joins('LEFT JOIN group_proposals on group_proposals.proposal_id = proposals.id') unless user_id
      proposals = proposals.where('proposal_supports.group_id = ? or group_proposals.group_id = ?', group_id, group_id)
      if group_area_id
        proposals = proposals.joins('LEFT JOIN area_proposals on area_proposals.proposal_id = proposals.id') unless user_id
        proposals = proposals.where('area_proposals.group_area_id = ?', group_area_id)
      end
    else # only public
      proposals = proposals.where('proposals.private = false or proposals.visible_outside = true')
      if interest_border.present?
        proposals = proposals.by_interest_borders(interest_border.key)
      end
    end

    proposals
    # Proposal.search do
    #   fulltext text, minimum_match: self.or if text
    # end
  end

  def results
    proposals = search

    # filter by status
    if proposal_state_tab
      states = if proposal_state_tab == ProposalState::TAB_VOTATION
                 [ProposalState::WAIT, ProposalState::WAIT_DATE, ProposalState::VOTING]
               elsif proposal_state_tab == ProposalState::TAB_VOTED
                 [ProposalState::ACCEPTED, ProposalState::REJECTED]
               elsif proposal_state_tab == ProposalState::TAB_REVISION
                 [ProposalState::ABANDONED]
               else
                 [ProposalState::VALUTATION]
               end
      proposals = proposals.where(proposal_state_id: states)
    end

    # selected columns
    selected_columns = ['proposals.*',
                        Proposal.alerts_count_subquery(user_id).as('alerts_count').to_sql,
                        Proposal.ranking_subquery(user_id).as('ranking').to_sql]

    # ordering
    dir = (order_dir == 'a') ? :asc : :desc
    if order_id == SearchProposal::ORDER_BY_DATE
      proposals = proposals.reorder(updated_at: dir, created_at: dir)
    elsif order_id == SearchProposal::ORDER_BY_RANK
      proposals = proposals.reorder(rank: dir, created_at: dir)
    elsif order_id == SearchProposal::ORDER_BY_VOTES
      proposals = proposals.reorder(valutations: dir, created_at: dir)
    elsif order_id == SearchProposal::ORDER_BY_END
      proposals = proposals.joins(:quorum).reorder("quorums.ends_at #{dir}", valutations: dir)
    elsif order_id == SearchProposal::ORDER_BY_VOTATION_END
      proposals = proposals.joins(:vote_period).reorder("events.endtime #{dir}", user_votes_count: dir)
    elsif order_id == SearchProposal::ORDER_BY_VOTES_NUMBER
      proposals = proposals.joins(:vote_period).reorder({ user_votes_count: dir }, "events.endtime #{dir}")
    elsif text
      selected_columns << "#{PgSearch::Configuration.alias('proposals')}.rank"
    end

    # preloading, additional columns and pagination
    proposals = proposals.
                select(selected_columns).
                preload(:proposal_type, :user_votes, :category, :quorum, :groups, :interest_borders).
                page(page).per(per_page)

    proposals
  end

  def similar
    proposals = Proposal.current.search_similar(text).accessible_by(Ability.new(user), :index, false)
    if group_id
      proposals = proposals.
                  joins('LEFT JOIN proposal_supports on proposal_supports.proposal_id = proposals.id')
      unless user
        proposals = proposals.
                    joins('LEFT JOIN group_proposals on group_proposals.proposal_id = proposals.id')
      end
      proposals = proposals.
                  where('proposal_supports.group_id = ? or group_proposals.group_id = ?', group_id, group_id)
    end
    proposals.select('proposals.*', "#{PgSearch::Configuration.alias('proposals')}.rank").
      reorder('proposals.private desc', "#{PgSearch::Configuration.alias('proposals')}.rank desc").page(1).per(10)
  end
end
