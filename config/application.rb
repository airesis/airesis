require File.expand_path('../boot', __FILE__)

require 'rails/all'

require 'csv'

Bundler.require(:default, Rails.env)

#TODO renenable token authenticable

module Airesis
  class Application < Rails::Application
    config.encoding = "utf-8"
    config.coding = "utf-8"

    # Configure sensitive parameters which will be filtered from the log file.
    config.filter_parameters += [:password]

    # Version of your assets, change this if you want to expire all your assets
    config.assets.version = '1.0'

    config.autoload_paths << "#{Rails.root}/lib"
    config.time_zone = 'Rome'
    config.i18n.default_locale = :en
    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{yml}')]
    config.i18n.fallbacks =[:en]

    config.to_prepare do
      Devise::Mailer.layout "maktoub/unregistered_mailer" # email.haml or email.erb
    end

    config.action_view.sanitized_allowed_tags = %w(u iframe table tr td th)
    config.action_view.sanitized_allowed_attributes = %w(id class style data-cke-realelement cellspacing cellpadding border)
    #  ActionView::Base.field_error_proc = Proc.new do |html_tag, instance|
    #    include ActionView::Helpers::OutputSafetyHelper
    #    raw %(<span class="field_with_errors">#{html_tag}</span>)
    #  end

    config.after_initialize do
      GroupsHelper.init
    end

  end
end

I18n.enforce_available_locales = false
