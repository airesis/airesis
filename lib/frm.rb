require 'frm/engine'
require 'frm/autocomplete'
require 'frm/default_permissions'
require 'workflow'

module Frm
  mattr_accessor :base_path, :user_class, :theme, :formatter,
                 :default_gravatar, :default_gravatar_image, :avatar_user_method,
                 :user_profile_links, :email_from_address, :autocomplete_field,
                 :per_page, :sign_in_path, :moderate_first_post



  class << self




    def moderate_first_post
      # Default it to true
      @@moderate_first_post != false
    end



    def per_page
      @@per_page || 20
    end

    def user_class
      User.class
    end

  end
end