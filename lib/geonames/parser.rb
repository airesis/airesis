require 'json'
require 'open-uri'
require 'active_support/core_ext/hash/slice'
require 'active_support/core_ext/hash/indifferent_access'

module Geonames
  class Parser

    def initialize
      # correctly set these parameters
      @continent_name = 'Europe'
      @country_name = 'Portugal'
      @country_code = '2264397' #2635167
      @lang = 'pt-PT'

      @username = 'coorasse'

      @continent_output = "continent = Continent.find_by(description: '#{@continent_name}')"
      @country_output = "state = Country.find_by(description: '#{@country_name}')"

      @regions_output = "region = Region.create(description: \"%{name}\", country: state, continent: continent, geoname_id: %{geoname_id})"
      @provinces_output = "province = region.provinces.create(description: \"%{name}\", country: state, continent: continent,  geoname_id: %{geoname_id}, population: %{population})"
      @cities_output = "province.municipalities.create(description: \"%{name}\", region: region, country: state, continent: continent, geoname_id: %{geoname_id}, population: %{population})"
    end

    def extract_features(geoname)
      {name: geoname[:name],
       longitude: geoname[:lng],
       latitude: geoname[:lat],
       population: geoname[:population],
       geoname_id: geoname[:geonameId]}
    end

    def geoname_url(code)
      "http://api.geonames.org/childrenJSON?geonameId=#{code}&username=#{@username}&lang=#{@lang}"
    end

    def fetch(code)
      JSON.load(open(geoname_url(code))).with_indifferent_access
    end

    def fetch_and_extract(code)
      json = fetch(code)
      json['geonames'] ? json['geonames'].map { |geoname| extract_features(geoname) } : []
    end

    def extract
      country_json = fetch(@country_code)

      output = File.open("#{@country_name.downcase}.rb", 'w') do |f|
        f.puts @continent_output
        f.puts @country_output
        regions = fetch_and_extract(@country_code)

        regions.each do |region|
          f.puts @regions_output % region
          provinces = fetch_and_extract(region[:geoname_id])
          provinces.each do |province|
            f.puts @provinces_output % province
            cities = provinces = fetch_and_extract(province[:geoname_id])
            cities.each do |city|
              f.puts @cities_output % city
            end
          end
        end
      end
    end
  end
end

Geonames::Parser.new.extract
