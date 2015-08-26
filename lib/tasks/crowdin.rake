namespace :airesis do
  namespace :crowdin do
    desc 'Download translations from Crowdin site in zip file,
          then unzip the file and extract translations to correct folders '
    task translations: :environment do
      Crowdin::Client.new.download_translations
      Crowdin::Client.new.extract_zip
    end

    desc 'Download translations only'
    task download_translations: :environment do
      Crowdin::Client.new.download_translations
    end

    desc 'Unzip translations only'
    task unzip: :environment do
      Crowdin::Client.new.extract_zip
    end

    desc 'List available languages on crowdin'
    task status: :environment do
      Crowdin::Client.new.status
    end

    desc 'Upload new sources to crowdin'
    task upload: :environment do
      Crowdin::Client.new.upload_sources
    end

    desc 'Update existing sources to crowdin'
    task update: :environment do
      Crowdin::Client.new.update_sources
    end
  end
end
