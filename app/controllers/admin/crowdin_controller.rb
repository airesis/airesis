module Admin
  class CrowdinController < Admin::ApplicationController
    def upload_sources
      Crowdin::Client.new.upload_sources
      flash[:notice] = 'Sources uploaded'
      redirect_to admin_panel_path
    end

    def update_sources
      Crowdin::Client.new.update_sources
      flash[:notice] = 'Sources updated'
      redirect_to admin_panel_path
    end

    def upload_translations
      Crowdin::Client.new.upload_translations
      flash[:notice] = 'Translation uploaded'
      redirect_to admin_panel_path
    end

    def download_translations
      Crowdin::Client.new.download_translations
      flash[:notice] = 'Translations downloaded'
      redirect_to admin_panel_path
    end

    def extract_delete_zip
      Crowdin::Client.new.extract_zip
      flash[:notice] = 'Translations unzipped and zip deleted'
      redirect_to admin_panel_path
    end

  end
end
