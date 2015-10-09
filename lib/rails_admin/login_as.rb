require 'rails_admin/config/actions'
require 'rails_admin/config/actions/base'

module RailsAdminLoginAs
end

module RailsAdmin
  module Config
    module Actions
      class LoginAs < RailsAdmin::Config::Actions::Base
        RailsAdmin::Config::Actions.register(self)
        register_instance_option :visible? do
          true
        end

        register_instance_option :member? do
          true
        end

        register_instance_option :link_icon do
          'fa fa-user'
        end

        register_instance_option :pjax? do
          false
        end

        register_instance_option :http_methods do
          [:get]
        end

        register_instance_option :controller do
          proc do
            puts "sign in as #{@object.inspect}"
            sign_in :user, @object, { bypass: true }
            redirect_to '/'
          end
        end
      end
    end
  end
end
