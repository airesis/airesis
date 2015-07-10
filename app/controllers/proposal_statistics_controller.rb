class ProposalStatisticsController < ApplicationController

  #carica la proposta
  before_filter :load_proposal

###SICUREZZA###

#l'utente deve aver fatto login
  before_filter :authenticate_user!

  def rank_time
    respond_to do |format|
      format.json
    end
  end

  protected

  def load_proposal
    @proposal = Proposal.find(params[:id])
  end
end
