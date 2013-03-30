#encoding: utf-8
class InterestBordersController < ApplicationController

  before_filter :authenticate_user!

  def index
    hint = params[:q] + "%"
    @continenti = Continente.all(:conditions => ["upper(description) like upper(?)",hint], :limit => 10)
    @stati = Stato.all(:conditions => ["upper(description) like upper(?)",hint], :limit => 10)
    @regiones = Regione.all(:conditions => ["upper(description) like upper(?)",hint], :limit => 10)
    @province = Provincia.all(:conditions => ["upper(description) like upper(?)",hint], :limit => 10)
    @comunes = Comune.all(:conditions => ["upper(description) like upper(?)",hint], :limit => 10)
    @generic_borders = GenericBorder.all(:conditions => ["upper(description) like upper(?)",hint], :limit => 10)
    regioni = @regiones.collect { |r| {:id => InterestBorder::SHORT_REGIONE+'-'+r.id.to_s, :name => r.description + ' (Regione)'} }
    province = @province.collect { |p| {:id => InterestBorder::SHORT_PROVINCIA+'-'+p.id.to_s, :name => p.description + ' (Provincia)'} }
    comuni = @comunes.collect { |p| {:id => InterestBorder::SHORT_COMUNE+'-'+p.id.to_s, :name => p.description + ' (Comune)'} }
    stati = @stati.collect { |p| {:id => InterestBorder::SHORT_STATO+'-'+p.id.to_s, :name => p.description + ' (Stato)'} }
    continenti = @continenti.collect { |p| {:id => InterestBorder::SHORT_CONTINENTE+'-'+p.id.to_s, :name => p.description + ' (Continente)'} }
    generics = @generic_borders.collect { |p| {:id => InterestBorder::SHORT_GENERIC+'-'+p.id.to_s, :name => p.description + ' ('+p.name+')'} }
    map = generics + continenti + stati + regioni + province + comuni
    respond_to do |format|      
      format.xml  { render :xml => map[0,10] }
      format.json  { render :json =>  map[0,10]}
      format.html # index.html.erb
    end
  end
end  
