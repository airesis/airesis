#encoding: utf-8
class VotationsController < ApplicationController
  include RotpModule

  layout 'open_space'

  before_filter :authenticate_user!

  def vote
    Proposal.transaction do
      @proposal = Proposal.find_by_id(params[:proposal_id])

      authorize! :vote, @proposal

      return unless validate_security_token

      vote_type = params[:data][:vote_type].to_i

      vote = UserVote.new(user_id: current_user.id, proposal_id: @proposal.id)
      vote.vote_type_id = vote_type unless @proposal.secret_vote
      vote.save!

      if vote_type == VoteType::POSITIVE
        @proposal.vote.positive += 1
      elsif vote_type == VoteType::NEGATIVE
        @proposal.vote.negative += 1
      elsif vote_type == VoteType::NEUTRAL
        @proposal.vote.neutral += 1
      end
      @proposal.vote.save!
      respond_to do |format|
        flash[:notice] = t('votations.create.confirm')
        format.js
        format.html { redirect_to votation_path }
      end
    end
  rescue ActiveRecord::ActiveRecordError => e
    if @proposal.errors[:user_votes]
      respond_to do |format|
        flash[:error] = t('errors.votation.already_voted')
        format.js { render 'votations/errors/vote_error' }
        format.html { redirect_to votation_path }
      end
    end
  end


  #un utente invia il voto in formato schulze
  def vote_schulze
    begin
      Proposal.transaction do
        @proposal = Proposal.find_by_id(params[:proposal_id])
        authorize! :vote, @proposal

        return unless validate_security_token

        votestring = params[:data][:votes]
        solutions = votestring.split(/;|,/).map { |a| a.to_i }.sort #lista degli id delle soluzioni
        p_sol = @proposal.solutions.pluck(:id).sort
        raise Exception unless (p_sol <=> solutions) == 0 #se c'è discrepanza tra gli id delle soluzioni e quelli inviati dal client solleva un'eccezione

        #salva la votazione dell'utente
        schulz = @proposal.schulze_votes.find_by(preferences: votestring)
        if schulz
          schulz.count += 1
          schulz.save!
        else
          schulz = @proposal.schulze_votes.build(preferences: votestring, count: 1)
        end
        #memorizza che l'utente ha effettuato la votazione
        vote = @proposal.user_votes.build(user_id: current_user.id)
        vote.vote_schulze = votestring unless @proposal.secret_vote
        @proposal.save!
      end
      respond_to do |format|
        flash[:notice] = t('votations.create.confirm')
        format.html { render action: :show }
        format.js { render 'votations/vote_schulze' }
      end

    rescue Exception => e
      respond_to do |format|
        #magari ha provato a votare due volte!
        flash[:error] = t('errors.messages.votation')
        format.html { redirect_to @proposal }
        format.js { render 'votations/errors/vote_error' }
      end
    end
  end


  protected

  def validate_security_token
    return true unless (current_user.rotp_enabled && ::Configuration.rotp)
    return true if check_token(current_user, params[:data][:token])
    flash[:error] = t('errors.messages.invalid_token')
    respond_to do |format|
      format.js { render 'votations/errors/vote_error' }
    end
    false
  end
end
