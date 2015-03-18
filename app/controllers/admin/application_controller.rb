class Admin::ApplicationController < ApplicationController

  layout 'admin'

  before_filter :admin_required


  protected

  def admin_required
    is_admin? || admin_denied
  end
end
