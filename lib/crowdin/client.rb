require 'crowdin-api'
require 'logger'
require 'zip'

module Crowdin
  class Client

    DOWNLOAD_FOLDER = "tmp"
    MIN_TRANSLATION_PERCENTAGE = 60

    def auth
      @crowdin = Crowdin::API.new(:api_key => CROWDIN_API , :project_id => CROWDIN_PROJECT_ID, :account_key => CROWDIN_ACCOUNT_KEY)
      @crowdin.log = Logger.new $stderr
    end

    def upload_sources
      auth
      #@crowdin.add_file(
      #    files = [
      #        { :dest => '/config/locales/dates/%file_name%.%locale%.yml', :source => 'config/locales/dates/*.en.yml'},
      #    ], :type => 'yaml')
      directories = Dir.entries("config/locales")
      #puts directories
      files=[]
      directories.each { |name|
        if !(name.eql?("..") || name.eql?('.') || name.end_with?(".zip"))
          files << { :dest => "/#{name}.yml", :source => "config/locales/#{name}/#{name}.en.yml", :export_pattern => "/config/locales/#{name}/#{name}.%locale%.yml"}
        end
      }
      @crowdin.add_file(files, :type=>'yaml')
    end

    #scan directory "locales", memorize the names of the directories inside it
    #passes the directories name to crowdin.update_files, that upload the english files inside each directory
    def update_sources
      auth
      directories = []
      Dir.open("config/locales").each do |filename|
        next if (!File.directory?("config/locales/"+filename) || filename.end_with?('.'))
        directories << filename
        end

      files=[]
      directories.each { |filename|
        files << { :dest => "/#{filename}.yml", :source => "config/locales/#{filename}/#{filename}.en.yml"}
        }
      @crowdin.update_file(files)
    end


    #check translation_status
    #build zip file in Crowdin server
    #download only zip files of languages inside @lang_ready (see #status for more info on @lang_ready)
    def download_translations
      auth
      self.status
      @crowdin.export_translations
      @lang_ready.each { |lang|
        @crowdin.download_translation(lang, :output => "#{DOWNLOAD_FOLDER}/output-#{lang}.zip")
      }

    end


    #extract the zip file of each language contained in the folder "config/locales", only if the files in the archive are not empty
    #delete zip files at the end of extraction
    #reload translations from file (if there are new .yml files added we still need to restart the application!)
    def extract_zip
      zip_files = []
      Dir.open(DOWNLOAD_FOLDER).each do |filename|
        next if !(filename.end_with?('zip'))
        zip_files << "#{DOWNLOAD_FOLDER}/#{filename}"
      end

      zip_files.each{ |zip|
        Zip::File.open(zip) { |zip_file|
          zip_file.each { |f|
            f_path=File.join(f.name)
            FileUtils.mkdir_p(File.dirname(f_path))
            if f.directory? || (f.size && f.size != 0) #always extract directories, but doesn't extract empty files
              zip_file.extract(f, f_path) { true } #if true overwrite existing files with same name
            end
          }
        }
        delete_zip(zip)
      }
      I18n.reload!
    end

    def delete_zip(zip_file)
      File.delete(zip_file)
    end

    #check the status of the translations and populate the array @lang_ready with the lang code
    #that have translation percentage superior to MIN_TRANSLATION_PERCENTAGE
    def status
      auth
      @lang_ready= []

      output_array =  @crowdin.translations_status
      output_array.each do |lang|
       next if lang["translated_progress"] < MIN_TRANSLATION_PERCENTAGE
          @lang_ready << lang["code"]
      end

    end


  end
end


