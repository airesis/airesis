require 'cancan'

class Frm::ApplicationController < ApplicationController
  layout 'groups'

  before_action :load_group

  authorize_resource :group

  protected

  def load_group
    super
    head :forbidden if @group.disable_forums
  end
end
