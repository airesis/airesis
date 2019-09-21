class HomeController < ApplicationController
  layout :choose_layout

  # l'utente deve aver fatto login
  before_action :authenticate_user!, only: [:show]

  prepend_before_action :load_tutorial, :set_tutorial_parameters, only: :index

  def index
    @page_title = 'Home'
    if current_user
      @user = current_user
      @page_title = @user.fullname
      render 'show'
    end
  end

  def public
    load_open_space_resources
    render 'open_space'
  end

  def intro
  end

  def press
  end

  def school
  end

  def municipality
  end

  def privacy
  end

  def terms
  end

  def cookie_law
  end

  def statistics
    @stat1 = StatNumProposal.extract
  end

  def show
    @user = current_user
    @page_title = @user.fullname
  end

  def feedback
    respond_to do |format|
      format.js do
        feedback = JSON.parse(params[:data])
        data = feedback[1][22..-1] if feedback[1] # get the feedback image data

        stack = ''
        if current_user
          stack << "user id: #{current_user.id}\n"
          stack << "user email: #{current_user.email}\n"
          stack << "current url: #{session[:user_return_to]}\n"
        end
        feedback = SentFeedback.new(message: feedback[0]['message'], stack: stack)

        feedback.email = current_user.email if current_user # save user email if is logged in

        if data
          temp_file = Tempfile.new(['tmp', '.png'], encoding: 'ascii-8bit')
          begin
            temp_file.write(Base64.decode64(data))
            feedback.image = temp_file
          ensure
            temp_file.close
            temp_file.unlink
          end
        end
        feedback.save!

        ResqueMailer.feedback(feedback.id).deliver_later
        render nothing: true
      end
      format.html { render nothing: true }
    end
  end

  protected

  def set_tutorial_parameters
    @tutorial_action = 'show'
  end

  def load_open_space_resources
    @blog_posts = BlogPost.open_space(current_user, current_domain)
    @events = Event.in_territory(current_domain.territory).next.order('starttime asc').accessible_by(Ability.new(current_user)).limit(10)
    @proposals = Proposal.open_space_portlet(current_user, current_domain.territory)
    @most_active_groups = Group.most_active(current_domain.territory)
    @tags = Tag.most_used(current_domain.territory).limit(100)
  end

  def choose_layout
    if ['landing'].include? action_name
      false
    elsif ['index'].include? action_name
      current_user ? 'users' : false
    elsif ['show'].include? action_name
      'users'
    elsif ['public'].include? action_name
      'open_space'
    else
      'landing'
    end
  end
end
