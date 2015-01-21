#encoding: utf-8
class InterestBordersController < ApplicationController

  #before_filter :authenticate_user!
  def index
    hint = "#{params[:q]}%"
    map = []
    @territory = SysLocale.find_by_key(I18n.locale).territory #that is the territory of the current user. it can be a state or a continent

    limit = 10 #hints limit
    results = []

    @continenti = Continente.with_translations(I18n.locale).where(["upper(continente_translations.description) like upper(?)", hint]).limit(limit)
    results += @continenti.collect { |p| {id: InterestBorder::SHORT_CONTINENTE+'-'+p.id.to_s, name: t('interest_borders.continent', name: p.description)} } unless @continenti.empty?
    limit -= @continenti.size
    if limit > 0
      @stati = Stato.with_translations([I18n.locale, 'en']).where(["upper(stato_translations.description) like upper(?)", hint]).limit(limit)
      results += @stati.collect { |p| {id: InterestBorder::SHORT_STATO+'-'+p.id.to_s, name: t('interest_borders.country', name: p.description)} } unless @stati.empty?
      limit -= @stati.size
      if limit > 0
        @regiones = @territory.regiones.where(["upper(regiones.description) like upper(?)", hint]).limit(limit)
        results += @regiones.collect { |r| {id: InterestBorder::SHORT_REGIONE+'-'+r.id.to_s, name: t('interest_borders.region', name: r.description)} } unless @regiones.empty?
        limit -= @regiones.size
        if limit > 0
          @province = @territory.provincias.where(["lower_unaccent(provincias.description) like lower_unaccent(?)", hint]).limit(limit)
          results += @province.collect { |p| {id: InterestBorder::SHORT_PROVINCIA+'-'+p.id.to_s, name: t('interest_borders.province', name: p.description)} } unless @province.empty?
          limit -= @province.size
          if limit > 0
            @comunes = @territory.comunes.where(["lower_unaccent(comunes.description) like lower_unaccent(?)", hint]).order('population desc nulls last').limit(limit)
            results += @comunes.collect { |p| {id: InterestBorder::SHORT_COMUNE+'-'+p.id.to_s, name: t('interest_borders.town', name: p.description)} } unless @comunes.empty?
            limit -= @comunes.size
            if limit > 0
              @generic_borders = GenericBorder.where(["upper(description) like upper(?)", hint]).limit(limit)
              results += @generic_borders.collect { |p| {id: InterestBorder::SHORT_GENERIC+'-'+p.id.to_s, name: p.description + ' ('+p.name+')'} } unless @generic_borders.empty?
            end
          end
        end
      end
    end


    respond_to do |format|
      format.json { render json: results }
      format.html # index.html.erb
    end
  end
end  
