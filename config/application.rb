require File.expand_path('../boot', __FILE__)

require 'rails/all'

# If you have a Gemfile, require the gems listed there, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env) if defined?(Bundler)

module DemocracyOnline3
  class Application < Rails::Application
    #config.active_record.observers = :user_observer
    config.encoding = "UTF-8"
    config.coding = "UTF-8"

    # Configure sensitive parameters which will be filtered from the log file.
    config.filter_parameters += [:password]
    
    config.autoload_paths << "#{Rails.root}/lib"
    config.time_zone = 'UTC' 
    config.i18n.default_locale = :it 

  end
end
