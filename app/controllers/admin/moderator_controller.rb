module Admin
  class ModeratorController < Admin::ManagerController
    before_action :moderator_required

    layout 'users'

    def show; end
  end
end
