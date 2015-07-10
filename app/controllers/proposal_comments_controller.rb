class ProposalCommentsController < ApplicationController

  before_filter :save_post_and_authenticate_user, only: [:create]

  load_and_authorize_resource :proposal
  load_and_authorize_resource through: :proposal, collection: [:list, :left_list, :edit_list, :show_all_replies]
  before_filter :already_ranked, only: [:rankup, :rankdown, :ranknil]

  layout :choose_layout

  #retrieve contributes list
  def index
    respond_to do |format|
      format.html { @proposal_comment_search  = ProposalCommentSearch.new({all: true, disable_limit: true}, @proposal)}
      format.js { @proposal_comment_search = ProposalCommentSearch.new(params, @proposal, current_user)}
    end
  end

  def list
    index
  end

  def left_list
    index
  end

  def edit_list
    index
  end

  def show
  end

  def history
  end

  #mostra tutti i commenti dati ad un contributo
  def show_all_replies
    @proposal_comment = ProposalComment.find_by_id(params[:id])
    @replies = ProposalComment.where('parent_proposal_comment_id=?', params[:id]).order('created_at ASC')[0..-(params[:showed].to_i+1)]
  end

  def new
    @proposal_comment = @proposal.proposal_comments.build
  end


  def edit
  end


  def create
    parent_id = params[:proposal_comment][:parent_proposal_comment_id]
    @is_reply = parent_id != nil
    post_contribute

    respond_to do |format|
      @my_nickname = current_user.proposal_nicknames.find_by(proposal_id: @proposal.id)
      @proposal_comment.collapsed = true
      format.html { redirect_to @proposal }
      format.js
      format.json { head :ok }
    end

  rescue Exception => e
    respond_to do |format|
      flash[:error] = @proposal_comment.errors.messages.values.join(" e ")
      format.js { render 'layouts/error' }
      format.json {
        render json: @proposal_comment.try(:errors) || {error: true}, status: :unprocessable_entity
      }
    end
  end


  def update
    respond_to do |format|
      if @proposal_comment.update(proposal_comment_update_params)
        flash[:notice] = t('info.proposal.updated_comment')
        format.html { redirect_to(@proposal) }
        format.js
      else
        format.html { render action: "edit" }
      end
    end
  end

  def destroy
    authorize! :destroy, @proposal_comment

    @proposal_comment.destroy

    respond_to do |format|
      flash[:notice] = t('info.proposal.comment_deleted')
      format.html { redirect_to @proposal }
      format.js
    end
  end

  #allow a user to tell the proposal author that his contribute has not been integrated well
  def unintegrate
    authorize! :unintegrate, @proposal_comment
    @proposal_comment.unintegrate
    redirect_to @proposal
  end

  def rankup
    rank 1
  end

  def ranknil
    rank 2
  end

  def rankdown
    rank 3
  end

  def report
    ProposalCommentReport.transaction do
      report = @proposal_comment.reports.find_by_user_id(current_user.id)
      report.destroy if report
      report = @proposal_comment.reports.create(user_id: current_user.id, proposal_comment_report_type_id: params[:reason])

    end
    flash[:notice] = t('info.proposal.contribute_reported')

  rescue Exception => e
    #log_error(e)
    respond_to do |format|
      flash[:error] = t('error.proposals.contribute_report')
      format.js { render 'layouts/error' }
    end
  end


  def noise
  end

  def manage_noise
  end

  #the editor marked some contributes as unuseful
  def mark_noise
    return unless current_user.is_my_proposal? @proposal

    active = params[:comments][:active]
    inactive = params[:comments][:inactive]

    active = active.split(/,\s*/)
    inactive = inactive.split(/,\s*/)

    to_active = @proposal.contributes.where(["id in (?) and soft_reports_count >= ?", active, CONTRIBUTE_MARKS])
    to_inactive = @proposal.contributes.where(id: inactive)

    to_active.update_all(noise: false)
    to_inactive.update_all(noise: true)

    respond_to do |format|
      format.html { redirect_to @proposal }
      format.js { render nothing: true }
    end
  end


  protected

  def proposal_comment_update_params
    params.require(:proposal_comment).permit(:content)
  end

  def proposal_comment_params
    params.require(:proposal_comment).permit(:content, :parent_proposal_comment_id, :section_id)
  end

  def save_post_and_authenticate_user
    return if current_user
    session[:proposal_comment] = params[:proposal_comment]
    session[:proposal_id] = params[:proposal_id]
    flash[:info] = t('info.proposal.login_to_contribute')
  end


  def rank(rank_type)
    @my_ranking = ProposalCommentRanking.find_by_user_id_and_proposal_comment_id(current_user.id, @proposal_comment.id)
    if @my_ranking
      @ranking = @my_ranking
    else
      @ranking = ProposalCommentRanking.new
      @ranking.user_id = current_user.id
      @ranking.proposal_comment_id = params[:id]
    end
    @ranking.ranking_type_id = rank_type

    respond_to do |format|
      if @ranking.save
        @proposal_comment.reload
        flash[:notice] = t('info.proposal.rank_recorderd')
        format.html { redirect_to @proposal }
        format.js { render 'rank' }
      else
        flash[:notice] = t(:error_on_proposal_comment_rank)
        format.html { redirect_to @proposal }
        format.js { render 'layouts/error' }
      end
    end
  end


  #check if the user can valutate again a contribute. that can happen only if the contribute received a suggestion after the previous valutation
  def already_ranked
    return true if current_user.can_rank_again_comment?(@proposal_comment)

    flash[:notice] = t('info.proposal.comment_already_ranked')
    respond_to do |format|
      format.js { render 'layouts/error' }
      format.html {
        redirect_to proposal_path(params[:proposal_id])
      }
    end
  end

  def choose_layout
    @group ? "groups" : "open_space"
  end

end
