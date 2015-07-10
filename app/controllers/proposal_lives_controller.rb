class ProposalLivesController < ApplicationController

  #load_and_authorize_resource
  #carica la proposta
  before_filter :load_proposal

  ###SICUREZZA###

  #l'utente deve aver fatto login
  before_filter :authenticate_user!


  def show
    @life = @proposal.proposal_lives.find(params[:id])
  end

  protected

  def load_proposal
    @proposal = Proposal.find(params[:proposal_id])
    @group = @proposal.groups.first if @proposal.private
  end

end
