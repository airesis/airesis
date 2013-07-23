#encoding: utf-8
#Copyright 2012 Rodi Alessandro
#This file is part of Airesis.
#Airesis is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as 
#published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
#Airesis is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY 
#or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
#You should have received a copy of the GNU General Public License along with Foobar. If not, see http://www.gnu.org/licenses/.

class HomeController < ApplicationController
  include StepHelper

  layout :choose_layout

  #l'utente deve aver fatto login
  before_filter :authenticate_user!, :only => [:show]

  before_filter :initialize_roadmap, :only => [:bugtracking]

  def index
    redirect_to home_url if current_user
  end

  def videoguide
  end

  def engage
  end

  def whatis
  end

  def roadmap
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

  def helpus
  end

  def privacy
  end

  def terms
  end

  def statistics
    @stat1 = StatNumProposal.extract

  end

  def show
    @step = get_next_step(current_user)
    @user = current_user
    @page_title = @user.fullname
  end

  def feedback
    feedback = JSON.parse(params[:data])
    data = feedback[1][22..-1] if feedback[1]#get the feedback image data


    feedback = SentFeedback.new(message: feedback[0]['message'])

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

    ResqueMailer.feedback(feedback.id).deliver
    respond_to do |format|
      format.html {render :nothing => true}
      format.js {}
    end
  end

  private
  def initialize_roadmap
    @roadmap ||= Roadmap.new(BUGTRACKING_USERNAME,BUGTRACKING_PASSWORD)
  end

  private

  def choose_layout
    if ['show'].include? action_name
      'users'
    elsif ['privacy', 'terms', 'engage', 'whatis', 'roadmap', 'whowe', 'helpus', 'videoguide','press','statistics'].include? action_name
      'landing'
    else
      nil
    end
  end





end
