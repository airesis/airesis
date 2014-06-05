#encoding: utf-8
class ComunesController < ApplicationController

  before_filter :authenticate_user!

  def index
    @territory = SysLocale.find_by_key(I18n.locale).territory
    @comunes = @territory.comunes.where(["lower_unaccent(description) like lower_unaccent(?)",params[:q].to_s + '%']).order('population desc nulls last').limit(10)
    comuni = @comunes.collect { |p| {id: p.id.to_s, text: p.description} }
    respond_to do |format|
      format.json  { render json:  comuni[0,10]}
    end
  end
end  