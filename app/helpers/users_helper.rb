module UsersHelper
  def link_to_ip(title, provider, css)
    link_to title, user_omniauth_authorize_path(provider), alt: title, title: title, class: "zocial icon #{css}"
  end

  def link_to_user(user, options = {})
    options.reverse_merge! content_method: :name, title_method: :email, class: :nickname
    if options[:full_name]
      content_text = "#{user.name} #{user.surname}"
      options[:title] ||= content_text
    end
    content_text ||= options.delete(:content_text)
    content_text ||= user.send(options.delete(:content_method))
    options[:title] ||= user.send(options.delete(:title_method))
    link_to h(content_text), user_path(user), options
  end

  # show a small tag with the user image followed by the nickname
  # if fullname is true the user name and surname is written instead of the nickname
  # if a proposal is passed as argument are checked few things,
  # if the proposal is_current? and the user has a nickname associated to it
  # then the user real name and image are hidden and replaced by the proposal nickname ones.
  def user_tag(user, proposal = nil, full_name = true, show_rank = false, options = {})
    fail 'Invalid User' unless user
    if proposal && proposal.is_anonima?
      u_nick = user.proposal_nicknames.find_by(proposal_id: proposal.id)
    end
    ret = content_tag :div, class: 'user-tag' do
      (content_tag :div, class: 'user-avatar' do
        if u_nick
          image_tag "https://www.gravatar.com/avatar/#{Digest::MD5.hexdigest(u_nick.nickname)}?s=24&d=identicon&r=PG"
        else
          avatar(user, size: 24)
        end
      end) +
        (content_tag :div, class: 'user-name' do
          if u_nick
            u_nick.nickname
          else
            link_to_user(user, options.merge(full_name: full_name)) +
              (" (#{user.rank})" if show_rank)
          end
        end)
    end
  end

  def user_tag_mini(user, proposal = nil)
    if proposal && proposal.is_anonima? && (user != current_user)
      u_nick = user.proposal_nicknames.find_by(proposal_id: proposal.id)
    end
    ret = "<div class=\"blogUserImage\" title=\"#{u_nick ? u_nick.nickname : user.email}\">"
    ret += if u_nick
             "<img src=\"https://www.gravatar.com/avatar/#{Digest::MD5.hexdigest(u_nick.nickname)}?s=24&d=identicon&r=PG\"/>"
           else
             avatar(user, size: 20)
           end
    ret += '</div>'
    ret.html_safe
  end

  def user_valutation_image(user, proposal, _options = {})
    val = if proposal.respond_to?(:ranking)
            proposal.ranking.to_i
          else
            proposal.rankings.find_by(user_id: user.id).try(:ranking_type_id)
          end
    if val == ProposalRanking::POSITIVE
      "<div class=\"like-mini\" style=\"display:inline-block;\" title=\"Hai valutato positivamente questa proposta\"></div>".html_safe
    elsif val == ProposalRanking::NEGATIVE
      "<div class=\"dislike-mini\" style=\"display:inline-block;\" title=\"Hai valutato negativamente questa proposta\"></div>".html_safe
    end
  end

  def avatar(user, params = {})
    size = params[:size] || 80
    url = params[:url]
    certification_logo = params[:cert].nil? ? true : params[:cert]
    force_size = params[:force_size].nil? ? true : params[:force_size]

    size -= 6 if user.certified? && certification_logo && size < 60

    style = force_size ? "style=\"width:#{size}px;height:#{size}px;\"" : ''

    ret = "<img src=\"#{user.user_image_url(size, params)}\" #{style} alt=\"\" itemprop=\"photo\" />"

    if user.certified? && certification_logo
      if size >= 60
        cert_img = "<img class=\"certification\" src=\"#{asset_path 'certification.png'}\"/>"
        ret = "<div class=\"user_certified\">#{ret}#{cert_img}</div>"
      else
        ret = "<div class=\"user_certified_mini\"  style=\"width:#{size + 6}px;height:#{size + 6}px;\">#{ret}</div>"
      end
    end
    ret.html_safe
  end
end
