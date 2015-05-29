echo "          _               _"
echo "     /\\   (_)             (_)"
echo "    /  \\   _ _ __ ___  ___ _ ___"
echo "   / /\\ \\ | | '__/ _ \\/ __| / __|"
echo "  / ____ \\| | | |  __/\\__ \\ \\__ \\"
echo " /_/    \\_\\_|_|  \\___||___/_|___/"
echo "           Scegli di partecipare"
echo ""
echo "=====Welcome in Airesis Setup====="
echo "=================================="
echo ""
echo "We'll ask you some information to help you configure your Airesis Development Environment."
echo "We will ask you some questions where you have to choose and identify default option with round parethesis."
echo "Something like: 'Press Y or (N)'."
echo "If you press y or Y will be yes, if you press n, N or Enter will be no."
echo "We suggest you to keep default configuration if that is your first configuration."
echo "Press ENTER when you are ready to proceed"
read
cp config/paypal.example.yml config/paypal.yml
cp config/application.example.yml config/application.yml
cp config/database.example.yml config/database.yml
echo "Please check your config/database.yml, setup it correctly and then continue."
echo "Press ENTER when you have configured your config/database.yml file"
read
echo "I will install necessary gems."
echo "Press ENTER"
read
bundle install
echo "We will now create the database with initial data inside it. Please wait, it will take some time...and if you are wondering, NO. IT'S NOT STUCKED!"
echo "Press ENTER when you are ready to proceed and take a coffee"
read
bundle exec rake db:setup
echo ""
echo "OK! Well done! We have finished! Now just start your Airesis environment with rails s and if something goes wrong please blame the developer."
echo "If you want to change other options please edit '#{environmentfilename}'"
echo "See ya and Happy edemocracy!"
