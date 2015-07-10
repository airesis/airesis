class ProposalSupportsController < ApplicationController

  #load_and_authorize_resource
  #carica la proposta
  before_filter :load_proposal

###SICUREZZA###
  authorize_resource only: [:new]

#l'utente deve aver fatto login
  before_filter :authenticate_user!

  def index
  end

#mostra il pannello o la pagina per fornire supporto alla proposta da parte di un gruppo
  def new
    @proposal_support = @proposal.proposal_supports.build
    respond_to do |format|
      format.html
      format.js
    end
  end

  def create
    #devo avere i permessi su ciascun gruppo al quale voglio far supportare la proposta
    #i gruppi ai quali l'utente vuol far supportare la proposta

    groups = (params[:proposal] && params[:proposal][:supporting_group_ids]) ? params[:proposal][:supporting_group_ids].collect { |i| i.to_i } : []
    #i gruppi per i quali possiede i permessi
    user_groups = current_user.scoped_group_participations(GroupAction::PROPOSAL).pluck('group_participations.group_id')
    #tutti i gruppi nella richiesta devono essere tra quelli dell'utente
    diff = groups - user_groups
    unless diff.empty? #la differenza deve essere un insieme vuoto, altrimenti lancio l'eccezione
      raise ActiveRecord::ActiveRecordError.new
    end

    no_supp = user_groups - groups #id of user groups not supported

    @proposal.supporting_group_ids += groups
    @proposal.supporting_group_ids -= no_supp

    @proposal.save!
    flash[:notice] = "Sostegno alla proposta salvato correttamente"

    respond_to do |format|
      format.html
      format.js
    end

  rescue ActiveRecord::ActiveRecordError => e
    respond_to do |format|
      format.html redirect_to proposal_path(@proposal)
      format.js do
        render :update do |page|
          page.alert "Errore durante l'operazione"
        end
      end
    end
  end

  def edit
  end

  def update
  end


  def destroy
  end


  protected

  def load_proposal
    @proposal = Proposal.find(params[:proposal_id])
  end

end
