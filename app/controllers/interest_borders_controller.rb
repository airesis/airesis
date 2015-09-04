class InterestBordersController < ApplicationController
  # before_filter :authenticate_user!
  def index
    hint = "#{params[:q]}%"
    map = []
    territory = current_domain.territory

    limit = 10 #hints limit
    results = []

    continents = Continent.with_translations(I18n.locale).
      where(['upper(continent_translations.description) like upper(?)', hint]).limit(limit)
    results += continents.collect { |p| {id: "#{InterestBorder::SHORT_CONTINENT}-#{p.id}", text: p.name} }
    limit -= continents.size
    if limit > 0
      stati = Country.with_translations([I18n.locale, 'en']).
        where(['upper(country_translations.description) like upper(?)', hint]).uniq.limit(limit)
      results += stati.collect { |p| {id: "#{InterestBorder::SHORT_COUNTRY}-#{p.id}", text: p.name} }
      limit -= stati.size
      if limit > 0
        regions = territory.regions.
          where(['upper(regions.description) like upper(?)', hint]).limit(limit)
        results += regions.collect { |r| {id: "#{InterestBorder::SHORT_REGION}-#{r.id}", text: r.name} }
        limit -= regions.size
        if limit > 0
          province = territory.provinces.
            where(['lower_unaccent(provinces.description) like lower_unaccent(?)', hint]).limit(limit)
          results += province.collect { |p| {id: "#{InterestBorder::SHORT_PROVINCE}-#{p.id}", text: p.name} }
          limit -= province.size
          if limit > 0
            municipalities = territory.municipalities.
              where(['lower_unaccent(municipalities.description) like lower_unaccent(?)', hint]).order('population desc nulls last').limit(limit)
            results += municipalities.collect { |p| {id: "#{InterestBorder::SHORT_MUNICIPALITY}-#{p.id}", text: p.name} }
            limit -= municipalities.size
            if limit > 0
              generic_borders = GenericBorder.where(['upper(description) like upper(?)', hint]).limit(limit)
              results += generic_borders.collect { |p| {id: "#{InterestBorder::SHORT_GENERIC}-#{p.id}", text: p.name_j} }
            end
          end
        end
      end
    end

    respond_to do |format|
      format.html
      format.json { render json: results }
    end
  end
end  
