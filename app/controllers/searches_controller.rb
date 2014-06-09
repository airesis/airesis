class SearchesController < ApplicationController
  include GroupsHelper
  before_action :set_search, only: [:show, :edit, :update, :destroy]

  def index
    @search = Search.new
    @search.q = params[:term]
    @search.user_id = current_user.id
    @search.find
    results = []
    if @search.groups.count > 0
      results << {value: t('controllers.searches.index.groups_divider'), type: 'Divider'}
      @search.groups.each do |group|
        results << {value: group.name, type: 'Group', url: group_url(group), proposals_url: group_proposals_url(group), events_url: group_events_url(group), participants_num: group.group_participations_count, proposals_num: group.proposals.count, image: group.image_url}
      end
    end
    if @search.proposals.count > 0
      results << {value: 'Proposals', type: 'Divider'}
      @search.proposals.each do |proposal|
        url = proposal.private? ?
            group_proposal_url(proposal.groups.first, proposal) : proposal_url(proposal)
        results << {value: proposal.title, type: 'Proposal', url: url, image: '/assets/gruppo-anonimo.png'}
      end
    end
    if @search.blogs.count > 0
      results << {value: 'Blogs', type: 'Divider'}
      @search.blogs.each do |blog|
        results << {value: blog.title, type: 'Blog', url: blog_url(blog), username: blog.user.fullname, user_url: user_url(blog.user), image: blog.user_image_tag(40)}
      end
    end
    render json: results
  end

  def show
  end

  def new
    @search = Search.new
  end

  def edit
  end

  def create
    @search = Search.new
    @search.q = params[:term]
    @search.user_id = current_user.id
    @search.find
    respond_to do |format|
      format.js
    end
  end

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

  def destroy
    @search.destroy
    respond_to do |format|
      format.html { redirect_to searches_url }
      format.json { head :no_content }
    end
  end

  private
  def set_search
    @search = Search.find(params[:id])
  end

  def search_params
    params.require(:search).permit(:q)
  end
end
