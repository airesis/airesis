class InterestBordersController < ApplicationController
  # TODO: before_action :authenticate_user!

  def index
    hint = "#{params[:q]}%"
    @results = by_hint(hint)

    respond_to do |format|
      format.html
      format.json { render json: @results }
    end
  end

  protected

  def by_hint(hint)
    territory = current_domain.territory
    limit = 10 # hints limit
    results = []

    continents = Continent.by_hint(hint).limit(limit)
    results += continents.collect { |p| { id: "#{InterestBorder::SHORT_CONTINENT}-#{p.id}", text: p.name } }
    limit -= continents.size
    return results unless limit > 0

    countries = Country.by_hint(hint).limit(limit)
    results += countries.collect { |p| { id: "#{InterestBorder::SHORT_COUNTRY}-#{p.id}", text: p.name } }
    limit -= countries.size
    return results unless limit > 0

    regions = territory.regions.by_hint(hint).limit(limit)
    results += regions.collect { |r| { id: "#{InterestBorder::SHORT_REGION}-#{r.id}", text: r.name } }
    limit -= regions.size
    return results unless limit > 0

    provinces = territory.provinces.by_hint(hint).limit(limit)
    results += provinces.collect { |p| { id: "#{InterestBorder::SHORT_PROVINCE}-#{p.id}", text: p.name } }
    limit -= provinces.size
    return results unless limit > 0

    municipalities = territory.municipalities.by_hint(hint).order('population desc nulls last').limit(limit)
    results += municipalities.collect { |p| { id: "#{InterestBorder::SHORT_MUNICIPALITY}-#{p.id}", text: p.name } }
    limit -= municipalities.size
    return results unless limit > 0

    generic_borders = GenericBorder.by_hint(hint).limit(limit)
    results += generic_borders.collect { |p| { id: "#{InterestBorder::SHORT_GENERIC}-#{p.id}", text: p.name_j } }
    results
  end
end
