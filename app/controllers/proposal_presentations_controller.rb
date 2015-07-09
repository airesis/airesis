class ProposalPresentationsController < ApplicationController
    

  #carica la proposta
  before_filter :load_proposal
  #carica la proposta
  before_filter :load_proposal_presentation

  #l'utente deve aver fatto login
  before_filter :authenticate_user!

  def destroy
    authorize! :destroy, @proposal_presentation
    @proposal_presentation.destroy
    flash[:notice] = 'Non sei più redattore di questa proposta'
    redirect_to @proposal.private? ? group_proposal_url(@proposal.groups.first,@proposal) : proposal_url(@proposal)
  end

  protected
 
  def load_proposal
    @proposal = Proposal.find(params[:proposal_id])
  end

  def load_proposal_presentation
    @proposal_presentation = ProposalPresentation.find(params[:id])
  end
  
end
