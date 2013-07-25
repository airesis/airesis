#encoding: utf-8

class ModeratorController < ManagerController
  before_filter :moderator_required#, :only => [:new, :create, :destroy]

  layout 'users'

  def show        
   
  end

end
