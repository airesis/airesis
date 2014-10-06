module UsersHelper

  #
  # Use this to wrap view elements that the user can't access.
  # !! Note: this is an *interface*, not *security* feature !!
  # You need to do all access control at the controller level.
  #
  # Example:
  # <%= if_authorized?(:index,   User)  do link_to('List all users', users_path) end %> |
  # <%= if_authorized?(:edit,    @user) do link_to('Edit this user', edit_user_path) end %> |
  # <%= if_authorized?(:destroy, @user) do link_to 'Destroy', @user, confirm: 'Are you sure?', method: :delete end %>
  #
  #
  def if_authorized?(action, resource, &block)
    if authorized?(action, resource)
      yield action, resource
    end
  end

  #
  # Link to user's page ('users/1')
  #
  # By default, their login is used as link text and link title (tooltip)
  #
  # Takes options
  # * content_text: 'Content text in place of user.login', escaped with
  #   the standard h() function.
  # * content_method: :user_instance_method_to_call_for_content_text
  # * title_method: :user_instance_method_to_call_for_title_attribute
  # * as well as link_to()'s standard options
  # * full_name: true show the User Name and Surname
  #
  # Examples:
  #   link_to_user @user
  #   # => <a href="/users/3" title="barmy">barmy</a>
  #
  #   # if you've added a .name attribute:
  #  content_tag :span, class: :vcard do
  #    (link_to_user user, class: 'fn n', title_method: :login, content_method: :name) +
  #          ': ' + (content_tag :span, user.email, class: 'email')
  #   end
  #   # => <span class="vcard"><a href="/users/3" title="barmy" class="fn n">Cyril Fotheringay-Phipps</a>: <span class="email">barmy@blandings.com</span></span>
  #
  #   link_to_user @user, content_text: 'Your user page'
  #   # => <a href="/users/3" title="barmy" class="nickname">Your user page</a>
  #
  def link_to_user(user, options={})
    raise "Invalid user" unless user
    options.reverse_merge! content_method: :name, title_method: :login, class: :nickname
    if options[:full_name]
      content_text = "#{user.name} #{user.surname}"
      options[:title] ||= content_text
    end
    content_text ||= options.delete(:content_text)
    content_text ||= user.send(options.delete(:content_method))
    options[:title] ||= user.send(options.delete(:title_method))
    link_to h(content_text), user_path(user), options
  end

  #show a small tag with the user image followed by the nickname
  #if fullname is true the user name and surname is written instead of the nickname
  #if a proposal is passed as argument are checked few things,
  #if the proposal is_current? and the user has a nickname associated to it
  #then the user real name and image are hidden and replaced by the proposal nickname ones.  
  def user_tag(user, proposal=nil, full_name=true, show_rank=false, options={})
    raise "Invalid User" unless user
    if proposal && proposal.is_anonima?
      u_nick = user.proposal_nicknames.find_by_proposal_id(proposal.id)
    end
    ret = content_tag :div, class: 'user-tag' do
      (content_tag :div, class: 'user-avatar' do
        if u_nick
          image_tag "http://www.gravatar.com/avatar/#{Digest::MD5.hexdigest(u_nick.nickname)}?s=24&d=identicon&r=PG"
        else
          user.user_image_tag(24)
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

  def user_tag_mini(user, proposal=nil, full_name=true)
    raise "Invalid User" unless user
    if proposal && proposal.is_anonima? && (user != current_user)
      u_nick = user.proposal_nicknames.find_by_proposal_id(proposal.id)
    end
    ret = "<div class=\"blogUserImage\" title=\""
    if u_nick
      ret += u_nick.nickname
    else
      if full_name
        ret += "#{user.name} #{user.surname}"
      else
        ret += "#{user.login}"
      end
    end
    ret += "\">"
    if u_nick
      ret += "<img src=\"http://www.gravatar.com/avatar/"
      ret += Digest::MD5.hexdigest(u_nick.nickname)
      ret += "?s=24&d=identicon&r=PG\"/>"
    else
      ret += user.user_image_tag(20)
    end
    ret += "</div>"
    ret.html_safe
  end

  def user_valutation_image(user, proposal, options={})
    if proposal.respond_to? :ranking
      val = proposal.ranking.to_i
    else
      val = proposal.rankings.find_by_user_id(user.id).ranking_type_id rescue nil
    end
    if val == 1
      "<div class=\"like-mini\" style=\"display:inline-block;\" title=\"Hai valutato positivamente questa proposta\"></div>".html_safe
    elsif val == 3
      "<div class=\"dislike-mini\" style=\"display:inline-block;\" title=\"Hai valutato negativamente questa proposta\"></div>".html_safe
    end
  end


  #
  # Link to login page using remote ip address as link content
  #
  # The :title (and thus, tooltip) is set to the IP address 
  #
  # Examples:
  #   link_to_login_with_IP
  #   # => <a href="/login" title="169.69.69.69">169.69.69.69</a>
  #
  #   link_to_login_with_IP content_text: 'not signed in'
  #   # => <a href="/login" title="169.69.69.69">not signed in</a>
  #
  def link_to_login_with_IP(content_text=nil, options={})
    ip_addr = request.remote_ip
    content_text ||= ip_addr
    options.reverse_merge! title: ip_addr
    if tag = options.delete(:tag)
      content_tag tag, h(content_text), options
    else
      link_to h(content_text), login_path, options
    end
  end

  #
  # Link to the current user's page (using link_to_user) or to the login page
  # (using link_to_login_with_IP).
  #
  def link_to_current_user(options={})
    if current_user
      link_to_user current_user, options
    else
      content_text = options.delete(:content_text) || 'not signed in'
      # kill ignored options from link_to_user
      [:content_method, :title_method].each { |opt| options.delete(opt) }
      link_to_login_with_IP content_text, options
    end
  end

end
