class MunicipalitiesController < ApplicationController

  before_filter :authenticate_user!

  def index
    Rails.logger.info "locale: #{I18n.locale}"
    @territory = SysLocale.find_by(key: I18n.locale).territory
    Rails.logger.info "territory: #{@territory.inspect}"
    @municipalities = @territory.municipalities.where(['lower_unaccent(description) like lower_unaccent(?)', params[:q].to_s + '%']).order('population desc nulls last').limit(10)
    comuni = @municipalities.collect { |p| {id: p.id.to_s, text: p.description} }
    respond_to do |format|
      format.json { render json: comuni[0, 10] }
    end
  end
end  
