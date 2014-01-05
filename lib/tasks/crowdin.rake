namespace :airesis do
  namespace :crowdin do

    task :translations => :enviroment do
      Crowdin::Client.download_translations
      Crowdin::Client.extract_zip

    end



    task :download_translations => :enviroment do
      Crowdin::Client.download_translations

    end

    task :unzip => :enviroment do
      Crowdin::Client.extract_zip
    end

  end

end