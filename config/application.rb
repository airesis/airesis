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
    config.action_view.sanitized_allowed_attributes = %w(id class style data-cke-realelement cellspacing cellpadding border target)
    #  ActionView::Base.field_error_proc = Proc.new do |html_tag, instance|
    #    include ActionView::Helpers::OutputSafetyHelper
    #    raw %(<span class="field_with_errors">#{html_tag}</span>)
    #  end

    config.after_initialize do
      GroupsHelper.init
    end

    config.action_mailer.delivery_method = :smtp

    config.action_mailer.raise_delivery_errors = true
    config.action_mailer.default_url_options = {host: ENV['MAILER_DEFAULT_HOST']}

    config.action_mailer.smtp_settings = {
        enable_starttls_auto: true,
        port: 587,
        address: ENV['EMAIL_ADDRESS'],
        user_name: ENV['EMAIL_USERNAME'],
        password: ENV['EMAIL_PASSWORD'],
        authentication: :plain
    }

    if ENV['AWS_HOST'].present?
      options = {
          storage: :s3,
          s3_protocol: :https,
          bucket: ENV['AWS_BUCKET'],
          s3_credentials: {
              access_key_id: ENV['AWS_ACCESS_KEY_ID'],
              secret_access_key: ENV['AWS_SECRET_ACCESS_KEY']
          },
          s3_host_name: ENV['AWS_HOST']
      }

      if ENV['AWS_ALIAS'].present?
        options.merge!(s3_host_alias: ENV['AWS_ALIAS'],
                       url: ':s3_alias_url')
      end

      config.paperclip_defaults = options
    end
  end
end

I18n.enforce_available_locales = false
