class SearchesController < ApplicationController
  include GroupsHelper
  before_action :set_search, only: [:show, :edit, :update, :destroy]

  # GET /searches
  # GET /searches.json
  def index
    @search = Search.new
    @search.q = params[:term]
    @search.user_id = current_user.id
    @search.find
    results = []
    if @search.groups.count > 0
      results << {:value => t('controllers.searches.index.groups_divider'), type: 'Divider'}
      @search.groups.each do |group|
        results << {:value => group.name, type: 'Group', url: group_url(group), proposals_url: group_proposals_url(group), events_url: group_events_url(group), partecipants_num: group.group_partecipations_count, proposals_num: group.internal_proposals.count, image: group.image_url}
      end
    end
    if @search.proposals.count > 0
      results << {:value => 'Proposals', type: 'Divider'}
      @search.proposals.each do |proposal|
        url = proposal.private? ?
            group_proposal_url(proposal.presentation_groups.first, proposal) : proposal_url(proposal)
        results << {:value => proposal.title, type: 'Proposal', url: url, image: '/assets/gruppo-anonimo.png'}
      end
    end
    if @search.blogs.count > 0
      results << {:value => 'Blogs', type: 'Divider'}
      @search.blogs.each do |blog|
        results << {:value => blog.title, type: 'Blog', url: blog_url(blog), username: blog.user.fullname, user_url: user_url(blog.user), image: blog.user_image_tag(40)}
      end
    end
    render :json => results
  end

  # GET /searches/1
  # GET /searches/1.json
  def show
  end

  # GET /searches/new
  def new
    @search = Search.new
  end

  # GET /searches/1/edit
  def edit
  end

  # POST /searches
  # POST /searches.json
  def create
    @search = Search.new
    @search.q = params[:term]
    @search.user_id = current_user.id
    @search.find
    respond_to do |format|
      format.js
    end
  end

  # PATCH/PUT /searches/1
  # PATCH/PUT /searches/1.json
  def update
    respond_to do |format|
      if @search.update(search_params)
        format.html { redirect_to @search, notice: 'Search was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @search.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /searches/1
  # DELETE /searches/1.json
  def destroy
    @search.destroy
    respond_to do |format|
      format.html { redirect_to searches_url }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_search
    @search = Search.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def search_params
    params.require(:search).permit(:q)
  end
end
