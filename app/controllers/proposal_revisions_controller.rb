#encoding: utf-8
class ProposalRevisionsController < ApplicationController
  layout :choose_layout

  before_filter :authenticate_user!

  load_and_authorize_resource :proposal
  load_resource through: :proposal

  def index
    respond_to do |format|
      format.js
      format.html # index.html.erb      
    end
  end

  def show

  end

  protected

  def choose_layout
    @proposal.private ? "groups" : "open_space"
  end
end
