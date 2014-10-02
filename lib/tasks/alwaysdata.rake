
namespace :alwaysdata do
  task :restart do
    require "rubygems"
    require "bundler/setup"
    require "capybara"
    require "capybara/dsl"
    require "capybara-webkit"
    USERNAME= ENV['ALWAYSDATA_USERNAME']
    PASSWORD= ENV['ALWAYSDATA_PASSWORD']


    Capybara.run_server = false
    Capybara.current_driver = :webkit
    Capybara.app_host = "http://admin.alwaysdata.com"

    module Alwaysdata
      class Server
        include Capybara::DSL

        def restart_server
          visit('/')
          fill_in "id_login", :with => USERNAME
          fill_in "id_password", :with => PASSWORD
          page.find('.awesome').click
          visit('/advanced/processes/restart')
        end
      end
    end

    spider = Alwaysdata::Server.new
    spider.restart_server
  end
end
