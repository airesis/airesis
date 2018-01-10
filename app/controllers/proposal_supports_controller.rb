class ProposalSupportsController < ApplicationController
  # load_and_authorize_resource
  layout 'open_space'

  before_filter :load_proposal

  authorize_resource only: [:new]

  before_filter :authenticate_user!

  def index
  end

  def new
    @proposal_support = @proposal.proposal_supports.build
    respond_to do |format|
      format.html
      format.js
    end
  end

  def create
    # the user must have the correct permissions on each group

    # required groups
    groups = params[:proposal][:supporting_group_ids].collect(&:to_i) rescue []
    # his groups
    user_groups = current_user.scoped_group_participations(:support_proposals).pluck('group_participations.group_id')

    # allowed groups
    diff = groups - user_groups

    fail ActiveRecord::ActiveRecordError.new unless diff.empty?

    no_supp = user_groups - groups # id of user groups not supported

    @proposal.supporting_group_ids += groups
    @proposal.supporting_group_ids -= no_supp

    @proposal.save!
    flash[:notice] = 'Sostegno alla proposta salvato correttamente'

    respond_to do |format|
      format.html do
        redirect_to @proposal
      end
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
