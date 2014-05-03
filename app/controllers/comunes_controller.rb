#encoding: utf-8
class ComunesController < ApplicationController

  before_filter :authenticate_user!

  def index
    @comunes = Comune.all(:conditions => "upper(description) like upper('#{params[:q]}%')", :limit => 10)
    comuni = @comunes.collect { |p| {:id => p.id.to_s, :name => p.description} }
    map = comuni
    respond_to do |format|
      format.json  { render :json =>  map[0,10]}
      format.html
    end
  end
end  