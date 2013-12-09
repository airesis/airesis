require 'crowdin-api'
require 'logger'

module Crowdin
  class Client

    def auth
      @crowdin = Crowdin::API.new(:api_key => CROWDIN_API , :project_id => CROWDIN_PROJECT_ID, :account_key => CROWDIN_ACCOUNT_KEY)
      @crowdin.log = Logger.new $stderr
    end

    def upload_sources
      auth
      @crowdin.add_file(
          files = [
              { :dest => '/dates.en.yml', :source => 'config/locales/dates/dates.en.yml'},
          ], :type => 'yaml')

    end

    def update_sources
      auth
      @crowdin.update_file(
          files = [
              { :dest => '/dates.en.yml', :source => 'config/locales/dates/dates.en.yml'}
          ])
    end

    def download_translations
      auth
      @crowdin.translations_status
      @crowdin.export_translations
      @crowdin.download_translation('it', :output => 'config/locales/output.zip')

    end
  end
end


