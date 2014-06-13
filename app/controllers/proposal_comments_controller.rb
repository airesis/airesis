#encoding: utf-8
class ProposalCommentsController < ApplicationController


#l'utente deve aver fatto login
  before_filter :authenticate_user!, only: [:edit, :update, :new, :report, :mark_noise]

  before_filter :save_post_and_authenticate_user, only: [:create]
  before_filter :check_author, only: [:edit, :update]
  before_filter :already_ranked, only: [:rankup, :rankdown, :ranknil]

  load_and_authorize_resource :proposal
  load_and_authorize_resource through: :proposal, collection: [:list, :left_list, :edit_list]

  layout :choose_layout

  #retrieve contributes list
  def index
    order = ""
    conditions = " 1 = 1 "

    if params[:section_id]
      @section = Section.find(params[:section_id])
      paragraphs_ids = @section.paragraph_ids
      conditions += " AND proposal_comments.paragraph_id in (#{paragraphs_ids.join(',')})"
    elsif params[:all]
      conditions += ''
    else
      conditions += " AND proposal_comments.paragraph_id is null"
    end

    if params[:view] == SearchProposal::ORDER_RANDOM
      #remove already shown contributes
      conditions << " AND proposal_comments.id not in (#{params[:contributes].join(',')})" if params[:contributes]
      left = params[:disable_limit] ? 9999999 : COMMENTS_PER_PAGE
      tmp_comments = []
      #retrieve contributes with alerts TODO
      #alerted = Alert.joins({notification: :notification_data}).where(['notification_data.name = ? and notification_data.value = ? and notifications.notification_type_id in (?) and alerts.user_id = ?','proposal_id', @proposal.id.to_s,[NotificationType::NEW_CONTRIBUTES,NotificationType::NEW_CONTRIBUTES_MINE],current_user.id]).pluck('distinct (notification_data.value)')
      #unread_cond = conditions + " AND proposal_comments.id in "
      #tmp_comments += @proposal.contributes.listable.all(conditions: unread_cond).map { |c| c.id }

      if left > 0
        #extract evaluated ids
        valuated_cond = conditions + " AND proposal_comment_rankings.user_id = #{current_user.id}"
        valuated_ids = @proposal.contributes.listable.joins(:rankings).where(valuated_cond).select('distinct(proposal_comments.id)').map { |c| c.id }

        #extract not evaluated contributes
        non_valuated_cond = conditions
        non_valuated_cond += " AND proposal_comments.id not in (#{valuated_ids.join(',')})" unless valuated_ids.empty?
        tmp_comments += @proposal.contributes.listable.where(non_valuated_cond).order('random()').limit(left).load
        left -= tmp_comments.size

        if left > 0 && !valuated_ids.empty?
          #extract the evaluated ones
          valuated_cond = conditions
          valuated_cond += " AND proposal_comments.id in (#{valuated_ids.join(',')})"
          tmp_comments += @proposal.contributes.listable.where(valuated_cond).order('rank desc').limit(left).load
        end
      end
      @proposal_comments = tmp_comments
      @total_pages = (@proposal.contributes.listable.count.to_f / COMMENTS_PER_PAGE.to_f).ceil
      @current_page = (params[:page] || 1).to_i
    else
      if params[:view] == SearchProposal::ORDER_BY_RANK
        order << " proposal_comments.j_value desc, proposal_comments.id desc"
      else
        order << "proposal_comments.updated_at desc"
      end
      @proposal_comments = @proposal.contributes.listable.where(conditions).order(order).page(params[:page]).per(COMMENTS_PER_PAGE)
      @total_pages = @proposal_comments.total_pages
      @current_page = @proposal_comments.current_page
    end


    respond_to do |format|
      format.js
      format.html
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
    @parent_id = params[:proposal_comment][:parent_proposal_comment_id]
    @is_reply = @parent_id != nil
    post_contribute

    respond_to do |format|
      @my_nickname = current_user.proposal_nicknames.find_by_proposal_id(@proposal.id)
      @proposal_comment.collapsed = true
      format.js
      format.json { head :ok }
      format.html { redirect_to @proposal }
    end

  rescue Exception => e
    respond_to do |format|
      puts e
      flash[:error] = @proposal_comment.errors.messages.values.join(" e ")
      format.js { render 'proposal_comments/errors/create' }
      format.json {
        render json: @proposal_comment.try(:errors) || {error: true}, status: :unprocessable_entity
      }
    end
  end


  def update
    respond_to do |format|
      @proposal_comment.content = params[:proposal_comment][:content]
      if @proposal_comment.content_changed?
        if @proposal_comment.save
          NotificationProposalCommentUpdate.perform_async(@proposal_comment.id)
          flash[:notice] = t('info.proposal.updated_comment')
          format.js
          format.html { redirect_to(@proposal) }

        else
          format.html { render action: "edit" }
        end
      else
        format.js
        format.html { redirect_to(@proposal) }
      end

    end
  end

  def destroy
    authorize! :destroy, @proposal_comment

    @proposal_comment.destroy

    respond_to do |format|
      flash[:notice] = t('info.proposal.comment_deleted')
      format.js
      format.html { redirect_to @proposal }
    end
  end

  #allow a user to tell the proposal author that his contribute has not been integrated well
  def unintegrate
    authorize! :unintegrate, @proposal_comment
    ProposalComment.transaction do
      @proposal_comment.integrated_contribute.destroy
      @proposal_comment.update_attribute(:integrated, false)
      notify_user_unintegrated_contribute(@proposal_comment)
    end

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
      format.js { render :update do |page|
        page.replace_html "flash_messages", partial: 'layouts/flash', locals: {flash: flash}
      end
      }
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
      format.js { render nothing: true }
      format.html { redirect_to @proposal }
    end

  end


  protected

  def proposal_comment_params
    params.require(:proposal_comment).permit(:content, :parent_proposal_comment_id, :section_id)
  end

  #questo metodo permette di verificare che l'utente collegato sia l'autore del commento
  def check_author
    @proposal_comment = ProposalComment.find(params[:id])
    unless current_user.is_mine? @proposal_comment
      flash[:notice] = t('error.proposals.modify_comments')
      redirect_to :back
    end
  end

  def save_post_and_authenticate_user
    unless current_user
      session[:proposal_comment] = params[:proposal_comment]
      session[:proposal_id] = params[:proposal_id]
      flash[:info] = t('info.proposal.login_to_contribute')
      respond_to do |format|
        format.js { render :update do |page|
          page.redirect_to new_user_session_path
        end
        }
      end
    end
  end


  def rank(rank_type)
    authorize! :rank, @proposal_comment
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
        format.js { render 'rank' }
        format.html { redirect_to @proposal }
      else
        flash[:notice] = t(:error_on_proposal_comment_rank)
        format.js { render :update do |page|
          page.replace_html "flash_messages_comment_#{params[:id]}", partial: 'layouts/flash', locals: {flash: flash}
        end
        }
        format.html { redirect_to @proposal }
      end
    end
  end


  #check if the user can valutate again a contribute. that can happen only if the contribute received a suggestion after the previous valutation
  def already_ranked
    return true if current_user.can_rank_again_comment?(@proposal_comment)

    flash[:notice] = t('info.proposal.comment_already_ranked')
    respond_to do |format|
      format.js { render :update do |page|
        page.replace_html "flash_messages_comment_#{params[:id]}", partial: 'layouts/flash', locals: {flash: flash}
      end
      }
      format.html {
        redirect_to proposal_path(params[:proposal_id])
      }
    end
  end

  def choose_layout
    @group ? "groups" : "open_space"
  end
end
