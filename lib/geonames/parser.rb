require 'json'
require 'open-uri'
require 'active_support/core_ext/hash/slice'
require 'active_support/core_ext/hash/indifferent_access'

# HOW TO
# 1. Proceed to geonames.org
# 2. search for the country you are interested in
# 3. look for its id (http://www.geonames.org/3658394/ecuador.html) the id is 3658394
# 4. fill continent_name, country_name, country_code (the id) and lang
# 5. run!
#
# ---Ecuador
# @continent_name = 'America'
# @country_name = 'Ecuador'
# @country_code = '3658394' #2635167
# @lang = 'es-EC'
#
# ---Ireland
# @continent_name = 'Europe'
# @country_name = 'Ireland'
# @country_code = '2963597'
# @lang = 'en-IE'
#
# ---Serbia
# @continent_name = 'Europe'
# @country_name = 'Serbia'
# @country_code = '6290252'
# @lang = 'sr'
#
# ---Indonesia
# @continent_name = 'Asia'
# @country_name = 'Indonesia'
# @country_code = '1643084'
# @lang = 'id'
#
# ---Bosnia and Herzegovina
# @continent_name = 'Europe'
# @country_name = 'Bosnia and Herzegovina'
# @country_code = '3277605'
# @lang = 'bs'
#
# ---Germany
# @continent_name = 'Europe'
# @country_name = 'Germany'
# @country_code = '2921044'
# @lang = 'de'
#
# ---Spain
# @continent_name = 'Europe'
# @country_name = 'Spain'
# @country_code = '2510769'
# @lang = 'es'
#
# ---France
# @continent_name = 'Europe'
# @country_name = 'France'
# @country_code = '3017382'
# @lang = 'fr'
#
# ---United kingdom
# @continent_name = 'Europe'
# @country_name = 'United Kingdom'
# @country_code = '2635167'
# @lang = 'en'
#
# ---Croatia
# @continent_name = 'Europe'
# @country_name = 'Croatia'
# @country_code = '3202326'
# @lang = 'hr-HR'
#
# ---Montenegro
# @continent_name = 'Europe'
# @country_name = 'Montenegro'
# @country_code = '3194884'
# @lang = 'en'
#
# ---Hungary
# @continent_name = 'Europe'
# @country_name = 'Hungary'
# @country_code = '719819'
# @lang = 'hu-HU'
#
# ---Romania
# @continent_name = 'Europe'
# @country_name = 'Romania'
# @country_code = '798549'
# @lang = 'ro'
#
# ---China
# @continent_name = 'Asia'
# @country_name = 'China'
# @country_code = '1814991'
# @lang = 'zh-CN'
#
# ---Italy
# @continent_name = 'Europe'
# @country_name = 'Italy'
# @country_code = '3175395'
# @lang = 'it-IT'

module Geonames
  class Parser
    def initialize

      @continent_name = 'Europe'
      @country_name = 'Italy'
      @country_code = '3175395'
      @lang = 'it-IT'

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

      output = File.open("#{@country_name.downcase.tr(' ', '_')}.rb", 'w') do |f|
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
