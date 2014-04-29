#encoding: utf-8
#Copyright 2012 Rodi Alessandro
#This file is part of Airesis.
#Airesis is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as 
#published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
#Airesis is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY 
#or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
#You should have received a copy of the GNU General Public License along with Foobar. If not, see http://www.gnu.org/licenses/.

class HomeController < ApplicationController

  layout :choose_layout

  #l'utente deve aver fatto login
  before_filter :authenticate_user!, :only => [:show]

  before_filter :initialize_roadmap, :only => [:bugtracking]

  def index
    @page_title = 'Home'
    if current_user
      render 'open_space'
    end
  end

  def public
    render 'open_space'
  end

  def videoguide
  end

  def engage
  end

  def whatis
  end

  def intro
  end

  def roadmap
  end

  def donations
    @features = SysFeature.all
    @colors = ['red','yellow','blue','violet','green']
  end

  def press
  end

  def bugtracking
    @versions = @roadmap.versions
    @issues = @roadmap.issues
    respond_to do |format|
      format.json { render :json => "{\"data\":[#{@versions.to_json},#{@issues.to_json}]}" }
    end
  end

  def whowe
  end

  def story
  end

  def helpus
  end

  def school
  end

  def municipality
  end

  def privacy
  end

  def terms
  end

  def movements
    @income = SysMovement.income
    @outcome = SysMovement.outcome
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

      format.js {
        feedback = JSON.parse(params[:data])
        data = feedback[1][22..-1] if feedback[1]#get the feedback image data

        stack  = ""
        if current_user
          stack << "user id: #{current_user.id}\n"
          stack << "user email: #{current_user.email}\n"
          stack << "current url: #{session[:user_return_to]}\n"
        end
        feedback = SentFeedback.new(message: feedback[0]['message'], stack: stack)

        feedback.email = current_user.email if current_user #save user email if is logged in

        if data
          temp_file = Tempfile.new(['tmp','.png'], encoding: 'ascii-8bit')
          begin
            temp_file.write(Base64.decode64(data))
            feedback.image = temp_file
          ensure
            temp_file.close
            temp_file.unlink
          end
        end
        feedback.save!

        ResqueMailer.delay.feedback(feedback.id)
        render :nothing => true
      }
      format.html {render :nothing => true}
    end
  end

  private
  def initialize_roadmap
    @roadmap ||= Roadmap.new(BUGTRACKING_USERNAME,BUGTRACKING_PASSWORD)
  end

  private

  def choose_layout
    if ['index'].include? action_name
      current_user ? 'open_space' : false
    elsif ['show'].include? action_name
      'users'
    elsif ['public'].include? action_name
      'open_space'
    else
      'landing'
    end
  end





end
