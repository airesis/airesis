namespace :airesis do
  namespace :crowdin do

    task :translations => :environment do
      Crowdin::Client.new.download_translations
      Crowdin::Client.new.extract_zip

    end



    task :download_translations => :environment do
      Crowdin::Client.new.download_translations

    end

    task :unzip => :environment do
      Crowdin::Client.new.extract_zip
    end

  end

end