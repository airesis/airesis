class InterestBordersController < ApplicationController
  # before_filter :authenticate_user!
  def index
    hint = "#{params[:q]}%"
    map = []
    territory = SysLocale.find_by_key(I18n.locale).territory #that is the territory of the current user. it can be a state or a continent

    limit = 10 #hints limit
    results = []

    continenti = Continente.with_translations(I18n.locale).
      where(["upper(continente_translations.description) like upper(?)", hint]).limit(limit)
    results += continenti.collect { |p| {id: "#{InterestBorder::SHORT_CONTINENTE}-#{p.id}", name: p.name} }
    limit -= continenti.size
    if limit > 0
      stati = Country.with_translations([I18n.locale, 'en']).
        where(["upper(country_translations.description) like upper(?)", hint]).limit(limit)
      results += stati.collect { |p| {id: "#{InterestBorder::SHORT_COUNTRY}-#{p.id}", name: p.name} }
      limit -= stati.size
      if limit > 0
        regiones = territory.regiones.
          where(["upper(regiones.description) like upper(?)", hint]).limit(limit)
        results += regiones.collect { |r| {id: "#{InterestBorder::SHORT_REGIONE}-#{r.id}", name: r.name} }
        limit -= regiones.size
        if limit > 0
          province = territory.provincias.
            where(["lower_unaccent(provincias.description) like lower_unaccent(?)", hint]).limit(limit)
          results += province.collect { |p| {id: "#{InterestBorder::SHORT_PROVINCIA}-#{p.id}", name: p.name} }
          limit -= province.size
          if limit > 0
            comunes = territory.comunes.
              where(["lower_unaccent(comunes.description) like lower_unaccent(?)", hint]).order('population desc nulls last').limit(limit)
            results += comunes.collect { |p| {id: "#{InterestBorder::SHORT_COMUNE}-#{p.id}", name: p.name} }
            limit -= comunes.size
            if limit > 0
              generic_borders = GenericBorder.where(["upper(description) like upper(?)", hint]).limit(limit)
              results += generic_borders.collect { |p| {id: "#{InterestBorder::SHORT_GENERIC}-#{p.id}", name: p.name_j} }
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
