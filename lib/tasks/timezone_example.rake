namespace :airesis do
  namespace :timezone do

    desc "Test Timezone. Please run as is or rake airesis:timezone:example['80.18.120.118']"
    task :example, [:arg1] => :environment do |t,args|
      args.with_defaults(:arg1 => '46.126.156.173')
      @ip_address = args[:arg1]
      puts 'IP Address: ' + @ip_address
      @search = Geocoder.search(@ip_address)
      if @search.empty?
        puts "Unable to localize that IP"
      else
        @latlon = [@search[0].latitude, @search[0].longitude]
        puts "Your coordinates: #{@latlon}"
        Timezone::Configure.begin do |c|
          c.username = GEOSPATIAL_NAME
        end
        @zone = Timezone::Zone.new :latlon => @latlon
        puts 'Your Timezone is: ' + @zone.active_support_time_zone
        Time.zone = @zone.active_support_time_zone
        puts "Current time is: #{Time.zone.now}"
      end

    end
  end
end