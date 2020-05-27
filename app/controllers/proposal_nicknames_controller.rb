class ProposalNicknamesController < ApplicationController
  # carica la proposta
  before_action :load_proposal_nickname

  # ##SICUREZZA###

  # l'utente deve aver fatto login
  before_action :authenticate_user!

  def update
    loop = true
    while loop
      @nickname = NicknameGeneratorHelper.give_me_a_nickname
      loop = ProposalNickname.find_by(proposal_id: @proposal_nickname.proposal.id, nickname: @nickname)
    end
    @proposal_nickname.nickname = @nickname
    @proposal_nickname.save!
    @my_nickname = @proposal_nickname
    flash[:notice] = "Nickname cambiato in #{@nickname}"
    respond_to do |format|
      format.html { redirect_to redirect_url(@proposal) }
      format.js
    end
  end

  protected

  def load_proposal_nickname
    @proposal_nickname = ProposalNickname.find(params[:id])
    @proposal = @proposal_nickname.proposal
  end
end
