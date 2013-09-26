require 'cancan'

class Frm::ApplicationController < ApplicationController
  layout 'groups'

  before_filter :load_group

  private

  def forem_admin?
    current_user && current_user.forem_admin?
  end
  helper_method :forem_admin?

  def forem_admin_or_moderator?(forum)
    current_user && (current_user.forem_admin? || forum.moderator?(current_user))
  end
  helper_method :forem_admin_or_moderator?

end
