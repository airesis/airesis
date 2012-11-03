#encoding: utf-8
class VotationsController < ApplicationController

  before_filter :authenticate_user!

  before_filter :load_proposals, :only => [ :show]

  
  def show
    @page_title = "Sezione votazioni"
  end

  def vote

    Proposal.transaction do
      @proposal = Proposal.find_by_id(params[:proposal_id])
      proposal = @proposal
      proposal.user_votes.build(:user_id => current_user.id)
      if (params[:vote_type] == 1)
        proposal.vote.positive = proposal.vote.positive+1
      elsif (params[:vote_type] == 2)
        proposal.vote.neutral = proposal.vote.neutral+1
      else
       proposal.vote.negative = proposal.vote.negative+1
      end
      proposal.vote.save!
      proposal.save!

      load_proposals
      respond_to do |format|
        flash[:notice] = 'Voto registrato'
        format.js   { render :update do |page|
            page.replace_html "flash_messages", :partial => 'layouts/flash', :locals => {:flash => flash}
          #page.replace_html "proposals_list", :partial => "votations/list", :locals =>  {:proposals => @proposals}
          end
        }
        format.html { redirect_to votation_path }
      end
  end
  rescue ActiveRecord::ActiveRecordError => e
    if @proposal.errors[:user_votes]
      respond_to do |format|
        load_proposals
        flash[:error] = 'Hai già votato per questa proposta'
        format.js   { render :update do |page|
            page.replace_html "flash_messages", :partial => 'layouts/flash', :locals => {:flash => flash}
            page.replace_html "proposals_list", :partial => "votations/list", :locals =>  {:proposals => @proposals}
          end
        }
        format.html { redirect_to votation_path }
      end
    end
  end

  protected

  #carica le proposte per le quali può votare l'utente connesso
  def load_proposals
    #la proposta deve essere in stato 'in votazione'
    #l'utente non deve avere già votato per questa proposta
    @proposals = Proposal.find(:all,:select => "p.*",:joins=>"p", :conditions => "p.proposal_state_id = 4 and p.id not in (select proposal_id from user_votes where user_id = "+current_user.id.to_s+" and proposal_id = p.id)")
  end
end  