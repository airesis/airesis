#encoding: utf-8
class ProposalCommentsController < ApplicationController

  #carica la proposta
  before_filter :load_proposal
  #carica il commento
  before_filter :load_proposal_comment, :only => [:show, :edit, :update, :delete, :rankup, :rankdown, :ranknil, :destroy, :report, :mark_noise]

###SICUREZZA###

#l'utente deve aver fatto login
  before_filter :authenticate_user!, :only => [:edit, :update, :delete, :new, :report, :mark_noise]
  before_filter :save_post_and_authenticate_user, :only => [:create]
  before_filter :check_author, :only => [:edit, :update, :delete, :mark_noise]
  before_filter :already_ranked, :only => [:rankup, :rankdown, :ranknil]

  #questo metodo permette di verificare che l'utente collegato sia l'autore del commento
  def check_author
    @proposal_comment = ProposalComment.find(params[:id])
    if !current_user.is_mine? @proposal_comment
      flash[:notice] = t('controllers.proposal_comments.cant_edit')
      redirect_to :back
    end
  end

  def load_proposal
    @proposal = Proposal.find(params[:proposal_id])
  end

  def load_proposal_comment
    @proposal_comment = @proposal.comments.find(params[:id])
  end


  #restituisce l'elenco dei contributi
  def index
    order = ""
    conditions = " 1 = 1 "
    if params[:view] == ORDER_RANDOM
      conditions << " AND proposal_comments.id not in (#{params[:contributes].join(',')})" if params[:contributes]
      left = COMMENTS_PER_PAGE
      tmp_comments = []
      #estrai i contributi con notifiche
      if left > 0
        #estrai id di quelli già valutati
        valuated_cond = conditions + " AND proposal_comment_rankings.user_id = #{current_user.id}"
        valuated_ids = @proposal.contributes.listable.all(:joins => :rankings, :select => 'distinct(proposal_comments.id)', :conditions => valuated_cond).map { |c| c.id }

        #estrai i contributi non valutati
        non_valuated_cond = conditions
        non_valuated_cond += " AND proposal_comments.id not in (#{valuated_ids.join(',')})" unless valuated_ids.empty?
        tmp_comments += @proposal.contributes.listable.all(:conditions => non_valuated_cond, :order => " random()", :limit => left)
        left -= tmp_comments.size

        if left > 0 && !valuated_ids.empty?
          #estrai quelli già valutati
          valuated_cond = conditions
          valuated_cond += " AND proposal_comments.id in (#{valuated_ids.join(',')})"
          tmp_comments += @proposal.contributes.listable.all(:conditions => valuated_cond, :order => " rank desc", :limit => left)
        end
      end
      @proposal_comments = tmp_comments
      @total_pages = (@proposal.contributes.listable.count.to_f / COMMENTS_PER_PAGE.to_f).ceil
      @current_page = (params[:page] || 1).to_i
    else
      if params[:view] == ORDER_BY_RANK
        order << " proposal_comments.j_value desc, proposal_comments.id desc"
      else
        order << "proposal_comments.created_at desc"
      end
      @proposal_comments = @proposal.contributes.listable.paginate(:page => params[:page], :per_page => COMMENTS_PER_PAGE, :order => order)
      @total_pages = @proposal_comments.total_pages
      @current_page = @proposal_comments.current_page
    end


    respond_to do |format|
      format.js
      format.html # index.html.erb
                  #format.xml  { render :xml => @proposal_comments }
    end
  end

  def list
    index
  end

  def edit_list
    index
  end

  def show
    respond_to do |format|
      format.html # show.html.erb
      format.xml { render :xml => @proposal_comment }
    end
  end

  #mostra tutti i suggerimenti dati ad un contributo
  def show_all_replies
    @proposal_comment = ProposalComment.find_by_id(params[:id])
    @replies = ProposalComment.where('parent_proposal_comment_id=?', params[:id]).order('created_at ASC')[0..-6]
  end

  def new
    @proposal_comment = @proposal.comments.build
    respond_to do |format|
      format.html # new.html.erb
      format.xml { render :xml => @proposal_comment }
    end
  end


  def edit

  end


  def create
    parent_id = params[:proposal_comment][:parent_proposal_comment_id]
    @is_reply = parent_id != nil
    post_contribute


    respond_to do |format|
      @proposal_comments = @proposal.contributes.paginate(:page => params[:page], :per_page => COMMENTS_PER_PAGE, :order => 'created_at DESC')
      @my_nickname = current_user.proposal_nicknames.find_by_proposal_id(@proposal.id)
      unless @is_reply
        @saved = @proposal_comments.find { |comment| comment.id == @proposal_comment.id }
        @saved.collapsed = true
      end
      format.js
      format.html { redirect_to @proposal }
    end

  rescue Exception => e
    #log_error(e)
    respond_to do |format|
      puts e
      flash[:error] = t('controllers.proposal_comments.insert_error')
      format.js { render :update do |page|
        if @is_reply
          flash[:error] = @proposal_comment.errors.messages.values.join(" e ")
          page.replace_html parent_id.to_s + "_reply_area_msg", :partial => 'layouts/flash', :locals => {:flash => flash}
        else
          page.replace_html "flash_messages", :partial => 'layouts/flash', :locals => {:flash => flash}
          page.replace "proposalNewComment", :partial => 'proposal_comments/proposal_comment', :locals => {:proposal_comment => @proposal_comment}
        end
      end
      }
    end
  end


  def update
    respond_to do |format|
      if @proposal_comment.update_attributes(params[:proposal_comment])
        flash[:notice] = t('controllers.proposal_comments.edit_ok')
        format.html { redirect_to(@proposal) }
        format.xml { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml { render :xml => @proposal_comment.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @proposal_comment.destroy

    respond_to do |format|
      flash[:notice] = t('controllers.proposal_comments.delete_ok')
      format.js
      format.html { redirect_to @proposal }
      format.xml { head :ok }
    end
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
    flash[:notice] = t('controllers.proposal_comments.report_ok')

  rescue Exception => e
    #log_error(e)
    respond_to do |format|
      flash[:error] = t('controllers.proposal_comments.report_error')
      format.js { render :update do |page|
        page.replace_html "flash_messages", :partial => 'layouts/flash', :locals => {:flash => flash}
      end
      }
    end
  end


  def noise

  end

  def manage_noise

  end

  #the editor marked
  def mark_noise
    if params[:noise] == 'true'
      @proposal_comment.update_attribute(:noise, true)
    elsif params[:noise] == 'false'
      @proposal_comment.update_attribute(:noise, false)
    end

    respond_to do |format|
      format.js {}
    end

  end


  protected

  def save_post_and_authenticate_user
    if (!current_user)
      session[:proposal_comment] = params[:proposal_comment]
      session[:proposal_id] = params[:proposal_id]
      flash[:info] = t('login_to_post_contribute')
      respond_to do |format|
        format.js { render :update do |page|
          page.redirect_to new_user_session_path
        end
        }
      end
    end
  end


  def rank(rank_type)
    if @my_ranking = ProposalCommentRanking.find_by_user_id_and_proposal_comment_id(current_user.id, @proposal_comment.id)
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
        flash[:notice] = t(:proposal_comment_rank_registered)
        format.js { render :update do |page|
          #page.replace_html "flash_messages_comment_#{params[:id]}", :partial => 'layouts/flash', :locals => {:flash => flash}
          page.replace_html "rankingpanelcontainer#{params[:id]}", :partial => 'proposal_comments/ranking_panel', :locals => {:comment => @proposal_comment}
        end
        }
        format.html { redirect_to @proposal }
      else
        flash[:notice] = t(:error_on_proposal_comment_rank)
        format.js { render :update do |page|
          page.replace_html "flash_messages_comment_#{params[:id]}", :partial => 'layouts/flash', :locals => {:flash => flash}
        end
        }
        format.html { redirect_to @proposal }
      end
    end
  end


  #check if the user can valutate again a contribute. that can happen only if the contribute received a suggestion after the previous valutation
  def already_ranked
    return true if current_user.can_rank_again_comment?(@proposal_comment)
    flash[:notice] = t(:error_proposal_comment_already_ranked)
    respond_to do |format|
      format.js { render :update do |page|
        page.replace_html "flash_messages_comment_#{params[:id]}", :partial => 'layouts/flash', :locals => {:flash => flash}
      end
      }
      format.html {
        redirect_to proposal_path(params[:proposal_id])
      }
    end
  end
end
