require 'crowdin-api'
require 'logger'
require 'zip'

module Crowdin
  class Client

    def initialize(params={})
      @extract_folder = params[:extract_folder] || 'tmp/crowdin'
      @download_folder = params[:download_folder] || 'tmp'
      @min_translation_percentage = params[:min_translation_percentage] || 20
      @locales_mapping = {'en-GB' => 'crowdin'}
      auth
    end

    def auth
      @crowdin = Crowdin::API.new(api_key: ENV['CROWDIN_API'],
                                  project_id: ENV['CROWDIN_PROJECT_ID'],
                                  account_key: ENV['CROWDIN_ACCOUNT_KEY'])
      #@crowdin.log = Logger.new $stderr
    end

    def upload_sources
      source_files_path = Dir['config/locales/**/*.en.yml']

      files=[]
      source_files_path.each { |path|
        files << {dest: "/#{File.basename(path)}",
                  source: path,
                  export_pattern: '/'+path.gsub('en.yml', '%locale%.yml')}
      }
      @crowdin.add_file(files, :type => 'yaml')
    end

    def upload_translations
      transl_files_path = Dir['config/locales/**/*.it-IT.yml']
      files = []
      transl_files_path.each { |path|
        files << {dest: "/#{File.basename(path).gsub(/(?<=\.)(.*)(?=\.yml)/, 'en')}", source: path}
      }

      @crowdin.upload_translation(
        files,
        language = 'it',
        params = {import_duplicates: true})
    end

    #scan directory "locales", memorize the names of the directories inside it
    #passes the directories name to crowdin.update_files, that upload the english files inside each directory
    def update_sources
      source_files_path = Dir['config/locales/**/*.en.yml']
      files=[]

      source_files_path.each { |path|
        files << {dest: "/#{File.basename(path)}", source: path}
      }
      @crowdin.update_file(files)
    end


    # check translation_status
    # build zip file in Crowdin server
    # download only zip files of languages inside @lang_ready (see #status for more info on @lang_ready)
    def download_translations
      status
      @crowdin.export_translations
      @lang_ready.each { |lang|
        puts "Downloading '#{lang}' in zip format"
        @crowdin.download_translation(lang, output: "#{@download_folder}/output-#{lang}.zip")
      }
    end


    # extract the zip file of each language contained in the folder "config/locales",
    # only if the files in the archive are not empty
    # delete zip files at the end of extraction
    # reload translations from file (if there are new .yml files added we still need to restart the application!)
    def extract_zip
      FileUtils.rmtree(@extract_folder)
      zip_files = Dir["#{@download_folder}/*.zip"]

      zip_files.each { |zip|
        Zip::File.open(zip) { |zip_file|
          zip_file.each { |f|
            file_name = f.name
            FileUtils.mkdir_p("#{@extract_folder}/#{File.dirname(file_name)}")

            # doesn't extract empty files or files with fake locale
            if f.size && f.size != 0
              # if true overwrite existing files with same name
              zip_file.extract(f, "#{@extract_folder}/#{f.name}") { true }
            end
          }
        }
        delete_zip(zip)
      }
      self.change_fakelocale
    end

    # set a fake locale for crowdin files
    def change_fakelocale
      @locales_mapping.each do |key, value|
        puts "Converting '#{key}' into #{value}"
        files = Dir["#{@extract_folder}/config/locales/*/*.#{key}.yml"]
        files.each { |file_name|
          File.open('tmpfile', 'w') { |tmp|
            File.open(file_name, 'r').each { |l|
              if l.chomp == "#{key}:"
                tmp << "#{value}:\n"
              else
                tmp << l
              end
            }
            FileUtils.rm(file_name)
            FileUtils.mv(tmp.path, file_name.gsub(key,value))
          }
        }
      end
    end

    def delete_zip(zip_file)
      File.delete(zip_file)
    end

    # check the status of the translations and populate the array @lang_ready with the lang code
    # that have translation percentage superior to @min_translation_percentage
    def status
      @lang_ready= []

      output_array = @crowdin.translations_status
      output_array.each do |lang|
        next if lang['translated_progress'] < @min_translation_percentage
        @lang_ready << lang['code']
      end if false
      @lang_ready << 'en-GB'
      puts "Available languages: #{@lang_ready}"
    end
  end
end
