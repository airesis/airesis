class SearchesController < ApplicationController
  include GroupsHelper, UsersHelper

  def index
    @search = Search.new
    @search.q = params[:term]
    @search.user_id = current_user.id
    @search.find
    results = []
    if @search.groups.count > 0
      results << {value: t('controllers.searches.index.groups_divider'), type: 'Divider'}
      @search.groups.each do |group|
        results << {value: group.name, type: 'Group', url: group_url(group), proposals_url: group_proposals_url(group), events_url: group_events_url(group), participants_num: group.group_participations_count, proposals_num: group.proposals.count, image: group.image.url}
      end
    end
    if @search.proposals.count > 0
      results << {value: 'Proposals', type: 'Divider'}
      @search.proposals.each do |proposal|
        url = proposal.private? ?
          group_proposal_url(proposal.groups.first, proposal) : proposal_url(proposal)
        results << {value: proposal.title, type: 'Proposal', url: url, image: '/img/gruppo-anonimo.png'}
      end
    end
    if @search.blogs.count > 0
      results << {value: 'Blogs', type: 'Divider'}
      @search.blogs.each do |blog|
        results << {value: blog.title, type: 'Blog', url: blog_url(blog), username: blog.user.fullname, user_url: user_url(blog.user), image: avatar(blog.user, size: 40)}
      end
    end
    render json: results
  end
end
