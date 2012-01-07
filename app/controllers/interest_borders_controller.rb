#encoding: utf-8
class InterestBordersController < ApplicationController

  before_filter :authenticate_user!

  def index
    @regiones = Regione.find(:all,:conditions => "upper(description) like upper('#{params[:q]}%')", :limit => 10)
    @province = Provincia.find(:all,:conditions => "upper(description) like upper('#{params[:q]}%')", :limit => 10)
    @comunes = Comune.find(:all,:conditions => "upper(description) like upper('#{params[:q]}%')", :limit => 10)
    regioni = @regiones.collect { |r| {:id => 'R-'+r.id.to_s, :name => r.description + ' (Regione)'} }
    province = @province.collect { |p| {:id => 'P-'+p.id.to_s, :name => p.description + ' (Provincia)'} }
    comuni = @comunes.collect { |p| {:id => 'C-'+p.id.to_s, :name => p.description + ' (Comune)'} }
    map = regioni + province + comuni
    respond_to do |format|
      
      format.xml  { render :xml => map[0,10] }
      format.json  { render :json =>  map[0,10]}
      format.html # index.html.erb
    end
  end
end  