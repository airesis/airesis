require_relative 'boot'

require 'rails/all'

require 'csv'

Bundler.require(*Rails.groups)

# TODO: renenable token authenticable

module Airesis
  class Application < Rails::Application
    config.encoding = 'utf-8'
    config.coding = 'utf-8'
    config.load_defaults 6.0

    # Configure sensitive parameters which will be filtered from the log file.
    config.filter_parameters += [:password]

    # Version of your assets, change this if you want to expire all your assets
    config.assets.version = '1.0'

    config.autoload_paths << "#{Rails.root}/lib"
    config.time_zone = 'Rome'
    config.i18n.default_locale = :'en-EU'

    europe_eng_fallbacks = %i[en-GB en-IE en-US en-ZA en-AU en-NZ
                              sr-CS sr-SP sh-HR zh-TW me-ME bs-BA
                              ru-RU ro-RO it-IT id-ID hu-HU
                              es-ES de-DE el-GR fr-FR pt-PT]
    portuguese_fallbacks = [:'pt-BR']
    spanish_fallbacks = %i[es-EC es-AR es-CL]
    fallbacks = {}
    europe_eng_fallbacks.each { |key| fallbacks[key] = :'en-EU' }
    portuguese_fallbacks.each { |key| fallbacks[key] = :'pt-PT' }
    spanish_fallbacks.each { |key| fallbacks[key] = :'es-ES' }
    config.i18n.fallbacks = [I18n.default_locale, fallbacks]

    config.i18n.available_locales = %i[bs-BA de-DE el-GR en en-AU en-EU en-GB en-NZ en-US en-ZA
                                       en-IE es-AR es-CL es-EC es-ES fr-FR hu-HU id-ID
                                       it-IT me-ME pt-BR pt-PT ro-RO ru-RU sh-HR sr-CS sr-SP
                                       zh-TW]

    config.i18n.enforce_available_locales = true

    config.to_prepare do
      Devise::Mailer.layout 'newsletters/default'
    end

    config.action_view.sanitized_allowed_tags = %w[del dd h3 address big sub tt a ul h4 cite dfn h5 small kbd code
                                                   b ins img h6 sup pre strong blockquote acronym dt br p div samp
                                                   li ol var em h1 i abbr h2 span hr iframe table tr td th u s]
    config.action_view.sanitized_allowed_attributes = %w[name href cite class title src xml:lang height datetime alt
                                                         abbr width id class style data-cke-realelement cellspacing
                                                         cellpadding border target]

    config.active_job.queue_adapter = :sidekiq

    config.action_mailer.delivery_method = :smtp

    config.action_mailer.raise_delivery_errors = true
    config.action_mailer.default_url_options = { host: ENV['MAILER_DEFAULT_HOST'] }

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
        s3_region: ENV['AWS_REGION'],
        s3_credentials: {
          access_key_id: ENV['AWS_ACCESS_KEY_ID'],
          secret_access_key: ENV['AWS_SECRET_ACCESS_KEY']
        },
        s3_host_name: ENV['AWS_HOST']
      }

      if ENV['AWS_ALIAS'].present?
        options[:s3_host_alias] = ENV['AWS_ALIAS']
        options[:url] = ':s3_alias_url'
      end

      config.action_controller.asset_host = ENV['ASSETS_HOST'] if ENV['ASSETS_HOST'].present?
      config.paperclip_defaults = options
    end

    config.middleware.insert_before 0, Rack::Cors, debug: Rails.env.development? do
      allow do
        origins '*'

        resource '/api/*',
                 headers: :any,
                 methods: %i[get post patch delete]
      end
    end
  end
end
