class InterestBorder < ActiveRecord::Base
  has_many :proposal_borders, class_name: 'ProposalBorder'
  has_many :groups, class_name: 'Group'

  belongs_to :territory, polymorphic: true

  DISTRICT = 'District'
  COMUNE = 'Comune'
  PROVINCIA = 'Provincia'
  REGION = 'Region'
  COUNTRY = 'Country'
  CONTINENT = 'Continent'
  GENERIC = 'Generic'
  SHORT_COMUNE = 'C'
  SHORT_PROVINCIA = 'P'
  SHORT_REGION = 'R'
  SHORT_COUNTRY = 'S'
  SHORT_CONTINENT = 'K'
  SHORT_GENERIC = 'G'
  TYPE_MAP = {COMUNE => SHORT_COMUNE,
              REGION => SHORT_REGION,
              PROVINCIA => SHORT_PROVINCIA,
              COUNTRY => SHORT_COUNTRY,
              CONTINENT => SHORT_CONTINENT,
              GENERIC => SHORT_GENERIC}
  I_TYPE_MAP =TYPE_MAP.invert

  def district
    is_district? ? territory : nil
  end

  def comune
    is_comune? ? territory : territory.try(:comune)
  end

  def provincia
    is_provincia? ? territory : territory.try(:provincia)
  end

  def region
    is_region? ? territory : territory.try(:region)
  end

  def country
    is_country? ? territory : territory.try(:country)
  end

  def continent
    is_continent? ? territory : territory.try(:continent)
  end

  def is_district?
    territory_type == DISTRICT
  end

  def is_comune?
    territory_type == COMUNE
  end

  def is_provincia?
    territory_type == PROVINCIA
  end

  def is_region?
    territory_type == REGION
  end

  def is_country?
    territory_type == COUNTRY
  end

  def is_continent?
    territory_type == CONTINENT
  end

  def is_generic?
    territory_type == GENERIC
  end

  def description
    "#{territory.description} (#{(is_generic? ? territory.name : territory_type)})"
  end

  def self.table_element(border)
    ftype = border[0, 1] #tipologia (primo carattere)
    fid = border[2..-1] #chiave primaria (dal terzo all'ultimo carattere)
    found = false
    case ftype
      when SHORT_COMUNE
        found = Comune.find_by_id(fid)
      when SHORT_PROVINCIA
        found = Provincia.find_by_id(fid)
      when SHORT_REGION
        found = Region.find_by_id(fid)
      when SHORT_COUNTRY
        found = Country.find_by_id(fid)
      when SHORT_CONTINENT
        found = Continent.find_by_id(fid)
      when SHORT_GENERIC
        found = GenericBorder.find_by_id(fid)
    end
    found
  end

  def solr_search_field
    territory.solr_search_field
  end

  def as_json(options={})
    {id: "#{TYPE_MAP[territory_type]}-#{territory_id}", name: territory.name}
  end

  def self.find_or_create_by_key(key)
    return unless key.present?
    ftype = key[0, 1] # type (primo carattere)
    fid = key[2..-1] # primary key (dal terzo all'ultimo carattere)
    find_or_create_by(territory_type: I_TYPE_MAP[ftype], territory_id: fid)
  end

end
