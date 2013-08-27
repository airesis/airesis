#encoding: utf-8
class GroupQuorumsController < ApplicationController
  include NotificationHelper
  
  #carica il gruppo
  before_filter :load_group
  
  def new
    
  end
  
  def create
    
  end

end
