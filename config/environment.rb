#encoding: utf-8
require File.expand_path('../application', __FILE__)

Airesis::Application.initialize!

if defined? Capybara
  Capybara.server do |app, port|
    require 'rack/handler/thin'
    Rack::Handler::Thin.run(app, :Port => port)
  end
end
