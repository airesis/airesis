require File.expand_path('../boot', __FILE__)

require 'rails/all'


require 'fb_graph'

if defined?(Bundler)
  # If you precompile assets before deploying to production, use this line
  Bundler.require *Rails.groups(:assets => %w(development test))
  # If you want your assets lazily compiled in production, use this line
  # Bundler.require(:default, :assets, Rails.env)
end

module Airesis
  class Application < Rails::Application
    config.encoding = "utf-8"
    config.coding = "utf-8"

    # Configure sensitive parameters which will be filtered from the log file.
    config.filter_parameters += [:password]

    # Enable the asset pipeline
    config.assets.enabled = true

    # Version of your assets, change this if you want to expire all your assets
    config.assets.version = '1.0'
    
    config.autoload_paths << "#{Rails.root}/lib"
    config.time_zone = 'Rome' 
    config.i18n.default_locale = :it

    config.to_prepare do
      Devise::Mailer.layout "maktoub/unregistered_mailer" # email.haml or email.erb
    end

    config.action_view.sanitized_allowed_tags = ['u']
  #  ActionView::Base.field_error_proc = Proc.new do |html_tag, instance|
  #    include ActionView::Helpers::OutputSafetyHelper
  #    raw %(<span class="field_with_errors">#{html_tag}</span>)
  #  end 
  end
end
