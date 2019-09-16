class ProposalCommentSearch
  attr_reader :section

  def initialize(params, proposal, current_user = nil)
    @proposal = proposal
    @all = params[:all]
    @view = params[:view]
    @page = params[:page]
    @comment_id = params[:comment_id].to_i
    @section_id = params[:section_id]
    @section = Section.find(@section_id) if @section_id.present?
    @contributes = params[:contributes]
    @limit = params[:disable_limit] ? 9_999_999 : COMMENTS_PER_PAGE
    @current_user = current_user
  end

  def random_order?
    @view == SearchProposal::ORDER_RANDOM
  end

  def rank_order?
    @view == SearchProposal::ORDER_BY_RANK
  end

  def show_more?
    @total_pages > @current_page
  end

  # return a list of ids of already evaluated contributes by the current_user
  def evaluated_ids
    return @evaluated_ids if @evaluated_ids
    @evaluated_ids = if @current_user
                       ProposalComment.joins(:rankings).
                         where(proposal_comment_rankings: { user_id: @current_user.id },
                               proposal_comments: { proposal_id: @proposal.id }).distinct.pluck(:id)
                     else
                       []
                     end
    @evaluated_ids.delete(@comment_id) if @comment_id
    @evaluated_ids
  end

  def order_clause
    'random()' unless @comment_id
    "CASE proposal_comments.id
      WHEN #{@comment_id.to_i} THEN 1 ELSE 5 END, random()"
  end

  def proposal_comments
    return @proposal_comments if @proposal_comments

    proposal_comments_t = ProposalComment.arel_table

    if @section.present?
      paragraphs_ids = @section.paragraph_ids
      conditions_arel = proposal_comments_t[:paragraph_id].in(paragraphs_ids)
    elsif @all.present?
      conditions_arel = Arel::Nodes::SqlLiteral.new('1').eq(1)
    else
      conditions_arel = proposal_comments_t[:paragraph_id].eq(nil)
    end

    if random_order?
      # remove already shown contributes
      conditions_arel = conditions_arel.and(proposal_comments_t[:id].not_in @contributes) if @contributes
      left = @limit
      tmp_comments = []

      # extract not evaluated contributes
      tmp_comments += @proposal.contributes.listable.
        where(conditions_arel.and(proposal_comments_t[:id].not_in(evaluated_ids))).
        order(Arel.sql(order_clause)).take(left)

      left -= tmp_comments.count

      if left > 0 && !evaluated_ids.empty?
        # extract the evaluated ones
        tmp_comments += @proposal.contributes.listable.
          where(conditions_arel.and(proposal_comments_t[:id].in(evaluated_ids))).
          order('rank desc').take(left)
      end
      @proposal_comments = tmp_comments
      @total_pages = (@proposal.contributes.listable.where(conditions_arel).count.to_f / COMMENTS_PER_PAGE).ceil
      @current_page = (@page || 1).to_i
    else
      order = if rank_order?
                [proposal_comments_t[:j_value].desc, proposal_comments_t[:id].desc]
              else
                proposal_comments_t[:updated_at].desc
              end
      @proposal_comments = @proposal.contributes.listable.where(conditions_arel).order(order).page(@page).per(@limit)
      @total_pages = @proposal_comments.total_pages
      @current_page = @proposal_comments.current_page
    end
    @proposal_comments
  end
end
