#encoding: utf-8
class InterestBordersController < ApplicationController

  #before_filter :authenticate_user!

  def index
    hint = params[:q] + "%"
    map = []
    @continenti = Continente.all(:conditions => ["upper(description) like upper(?)",hint], limit: 10)

    @stati = Stato.with_translations(I18n.locale).all(conditions: ["upper(stato_translations.description) like upper(?)", hint], limit: 10)
    @regiones = Regione.all(conditions: ["upper(description) like upper(?)", hint], limit: 10)
    @province = Provincia.all(conditions: ["upper(description) like upper(?)", hint], limit: 10)
    @comunes = Comune.all(conditions: ["upper(description) like upper(?)", hint], order: 'population desc nulls last', limit: 10)
    @generic_borders = GenericBorder.all(conditions: ["upper(description) like upper(?)", hint], limit: 10)
    regioni = @regiones.collect { |r| {:id => InterestBorder::SHORT_REGIONE+'-'+r.id.to_s, name: t('interest_borders.region', :name => r.description)} }
    province = @province.collect { |p| {:id => InterestBorder::SHORT_PROVINCIA+'-'+p.id.to_s, name: t('interest_borders.province',:name => p.description)} }
    comuni = @comunes.collect { |p| {:id => InterestBorder::SHORT_COMUNE+'-'+p.id.to_s, name: t('interest_borders.town',:name => p.description)} }
    stati = @stati.collect { |p| {:id => InterestBorder::SHORT_STATO+'-'+p.id.to_s, name: t('interest_borders.country', :name => p.description)} }
    continenti = @continenti.collect { |p| {:id => InterestBorder::SHORT_CONTINENTE+'-'+p.id.to_s, name: t('interest_borders.continent', :name => p.description)} }
    generics = @generic_borders.collect { |p| {:id => InterestBorder::SHORT_GENERIC+'-'+p.id.to_s, :name => p.description + ' ('+p.name+')'} }
    if @domain_locale == :eu
      map = generics + continenti + stati
    else
      map = generics + continenti + stati + regioni + province + comuni
    end

    respond_to do |format|      
      format.xml  { render :xml => map[0,10] }
      format.json  { render :json =>  map[0,10]}
      format.html # index.html.erb
    end
  end
end  
