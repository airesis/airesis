#encoding: utf-8
class BlockedProposalAlertsController < ApplicationController

  before_filter :authenticate_user!
  before_filter :load_proposal

  def block
    @blocked_alerts = BlockedProposalAlert.find_or_create_by(user_id: current_user.id, proposal_id: @proposal.id)
    @blocked_alerts.updates = true
    @blocked_alerts.contributes = true
    @blocked_alerts.state = true
    @blocked_alerts.authors = true
    @blocked_alerts.valutations = true

    respond_to do |format|
      if @blocked_alerts.save
        flash[:notice] = 'Notifiche disattivate'
        format.js { render 'replace' }
        format.html  { redirect_to redirect_url(@proposal) }
      else
        flash[:notice] = 'Errore durante la disattivazione delle notifiche'
        format.js { render 'layouts/error' }
        format.html  { redirect_to redirect_url(@proposal) }
      end
    end
  end

  def unlock
    @blocked_alerts = BlockedProposalAlert.find_by(user_id: current_user.id, proposal_id: @proposal.id)
    respond_to do |format|
      if @blocked_alerts.destroy
        flash[:notice] = 'Notifiche attivate'
        @blocked_alerts = nil
        format.js { render 'replace' }
        format.html  { redirect_to redirect_url(@proposal) }
      else
        flash[:notice] = "Errore durante l'attivazione delle notifiche"
        format.js { render 'layouts/error' }
        format.html  { redirect_to redirect_url(@proposal) }
      end
    end
  end

  protected

  def load_proposal
    @proposal = Proposal.find(params[:proposal_id])
  end
end
