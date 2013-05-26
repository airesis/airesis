#encoding: utf-8
class ProposalHistoriesController < ApplicationController

  #load_and_authorize_resource
  #carica la proposta
  before_filter :load_proposal

  layout :choose_layout
###SICUREZZA###

#l'utente deve aver fatto login
  before_filter :authenticate_user!

  #mostra il pannello o la pagina sulla history della proposta  
  def index
    respond_to do |format|
      format.js
      format.html # index.html.erb      
    end
  end

  def show
    @revision = @proposal.revisions.find(params[:id])
  end

  protected

  def load_proposal
    @proposal = Proposal.find(params[:proposal_id])
    @group = @proposal.presentation_groups.first if @proposal.private
  end

  def choose_layout
    @proposal.private ? "groups" : "open_space"
  end

end
