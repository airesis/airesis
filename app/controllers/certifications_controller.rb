#encoding: utf-8
class CertificationsController < ApplicationController

  before_filter :admin_required
  before_filter :load_group, only: [:create, :destroy]

  def index

  end

  def create
    if @group.certified?
      flash[:error] = 'Group already certified'
    else
      @group.certified =  true
      @group.subdomain = params[:domain]
      @group.save!
      flash[:notice] = 'Group certified correctly'
    end
    render :index
  end


  def destroy
    if @group.certified?
      @group.certified =  false
      @group.subdomain = nil
      @group.save!
      flash[:notice] = 'Group removed correctly'
    else
      flash[:error] = 'This group is not certified'
    end
    render :index
  end
end  