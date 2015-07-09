module Admin
  class ModeratorController < Admin::ManagerController
    before_filter :moderator_required

    layout 'users'

    def show
    end
  end
end
