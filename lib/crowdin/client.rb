require 'crowdin-api'
require 'logger'
require 'zip'

module Crowdin
  class Client

    def initialize
      auth
    end

    DOWNLOAD_FOLDER = "tmp"
    MIN_TRANSLATION_PERCENTAGE = 60
    FAKE_LANGUAGE = "en-GB"

    def auth
      @crowdin = Crowdin::API.new(api_key: ENV['CROWDIN_API'] , project_id: ENV['CROWDIN_PROJECT_ID'], account_key: ENV['CROWDIN_ACCOUNT_KEY'])
      @crowdin.log = Logger.new $stderr
    end

    def upload_sources

      source_files_path = Dir["config/locales/**/*.en.yml"]

      files=[]
      source_files_path.each { |path|
        files << { dest: "/#{File.basename(path)}", source: path, export_pattern: "/"+path.gsub("en.yml","%locale%.yml")}
      }
      @crowdin.add_file(files, :type=>'yaml')
    end

    def upload_translations

      transl_files_path = Dir["config/locales/**/*.it-IT.yml"]
      files = []
      transl_files_path.each { |path|
        files << { dest: "/#{File.basename(path).gsub(/(?<=\.)(.*)(?=\.yml)/, "en")}", source: path }
      }

      @crowdin.upload_translation(
          files,
          language = 'it',
           params = {import_duplicates: true})
    end

    #scan directory "locales", memorize the names of the directories inside it
    #passes the directories name to crowdin.update_files, that upload the english files inside each directory
    def update_sources

      source_files_path = Dir["config/locales/**/*.en.yml"]
      files=[]

      source_files_path.each { |path|
        files << { dest: "/#{File.basename(path)}", source: path}
        }
      @crowdin.update_file(files)
    end


    #check translation_status
    #build zip file in Crowdin server
    #download only zip files of languages inside @lang_ready (see #status for more info on @lang_ready)
    def download_translations

      self.status
      @crowdin.export_translations
      @lang_ready.each { |lang|
        @crowdin.download_translation(lang, output: "#{DOWNLOAD_FOLDER}/output-#{lang}.zip")
      }

    end


    #extract the zip file of each language contained in the folder "config/locales", only if the files in the archive are not empty
    #delete zip files at the end of extraction
    #reload translations from file (if there are new .yml files added we still need to restart the application!)
    def extract_zip
      zip_files = Dir["#{DOWNLOAD_FOLDER}/*.zip"]

      zip_files.each{ |zip|
        Zip::File.open(zip) { |zip_file|
          zip_file.each { |f|
            file_name = f.name
            FileUtils.mkdir_p(File.dirname(file_name))

            if (file_name.include? "#{FAKE_LANGUAGE}") && !(file_name.include? "assets")
              zip_file.rename(f,file_name.gsub(/(?<=\.)(.*)(?=\.)/, "crowdin") )
            end

            if f.size && f.size != 0 && !(f.name.include? "#{FAKE_LANGUAGE}") #doesn't extract empty files or files with fake locale
              zip_file.extract(f, f.name) { true } #if true overwrite existing files with same name
            end
          }
        }
        delete_zip(zip)
      }
      self.change_fakelocale
      I18n.reload!
    end

    def change_fakelocale
      files = Dir["config/locales/*/*.crowdin.yml"]
      files.each{ |file_name|
        File.open("tmpfile", 'w') { |tmp|
          File.open(file_name, 'r').each { |l|
            if l.chomp == "#{FAKE_LANGUAGE}:"
              tmp << "crowdin:\n"
            else
              tmp << l
            end
          }
          FileUtils.mv(tmp.path, file_name)
        }
      }
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
      @lang_ready << "#{FAKE_LANGUAGE}" unless @lang_ready.include?("#{FAKE_LANGUAGE}")
    end


  end
end
