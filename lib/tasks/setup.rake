namespace :airesis do

    desc 'Setup Airesis Environment'
    task :setup do
      puts "          _               _"
      puts "     /\\   (_)             (_)"
      puts "    /  \\   _ _ __ ___  ___ _ ___"
      puts "   / /\\ \\ | | '__/ _ \\/ __| / __|"
      puts "  / ____ \\| | | |  __/\\__ \\ \\__ \\"
      puts " /_/    \\_\\_|_|  \\___||___/_|___/"
      puts "           Scegli di partecipare"
      puts ""
      puts "=====Welcome in Airesis Setup====="
      puts "=================================="
      puts ""
      puts "We'll ask you some information to help you configure your Airesis Development Environment."
      puts "We will ask you some questions where you have to choose and identify default option with round parethesis."
      puts "Something like: 'Press Y or (N)'."
      puts "If you press y or Y will be yes, if you press n, N or Enter will be no."
      puts "We suggest you to keep default configuration if that is your first configuration."
      print "Press ENTER when you are ready to proceed"
      STDIN.gets
      puts ""
      puts "We will now create the database with initial data inside it. Please wait, it will take some time...and if you are wondering, NO. IT'S NOT STUCKED!"
      print "Press ENTER when you are ready to proceed and take a coffee"
      STDIN.gets

      sh "rake db:setup"
      sh "mkdir -p private/elfinder"
      Timeout::timeout(1) do
	STDIN.gets
      end rescue nil
	
      dbconfig = YAML::load(File.open('config/database.yml'))
      ActiveRecord::Base.establish_connection(dbconfig["development"])

      require "#{File.dirname(__FILE__)}/../../config/environment.rb"

      puts ""
      puts ""
      puts "Well done! Now some questions!"
      puts "Would you like to activate Social Network Login on your environment?"
      puts "You must have a different Social Network Application registered on different services and a public and private key for each one of them"
      print "Press Y or (N)..."
      
      choose = STDIN.gets
      puts choose
      if "y" == choose.chomp.downcase
        Configuration.find_by_name(::Configuration::SOCIALNETWORK).update_attribute(:value,1)
        puts "Please enter your applications private and public key in config/environment.rb file"
        print "Press ENTER when you are ready to proceed"
        STDIN.gets
      else
        Configuration.find_by_name(::Configuration::SOCIALNETWORK).update_attribute(:value,0)
      end
      puts ""
      puts "Would you like to activate Recaptcha when the user register?"
      puts "If you are just developing that's not necessary"
      print "Press Y or (N)..."
      choose = STDIN.gets
      if "y" == choose.chomp.downcase
        ::Configuration.find_by_name(::Configuration::RECAPTCHA).update_attribute(:value,1)
        puts "Please enter your recaptcha private and public key in config/environment.rb file"
        print "Press ENTER when you are ready to proceed"
        STDIN.gets
      else
        ::Configuration.find_by_name(::Configuration::RECAPTCHA).update_attribute(:value,0)
      end

      puts ""
      puts "OK! Well done! We have finished! Now just start your Airesis environment with rails s and if something goes wrong please blame the developer."
      puts "If you want to change other options please edit '#{environmentfilename}'"
      puts "By bye!"

    end
end
