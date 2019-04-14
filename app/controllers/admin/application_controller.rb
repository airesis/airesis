module Admin
  class ApplicationController < ::ApplicationController
    layout 'admin'

    before_action :admin_required

    protected

    def admin_required
      is_admin? || admin_denied
    end
  end
end
