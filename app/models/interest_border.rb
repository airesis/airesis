class InterestBorder < ApplicationRecord
  has_many :proposal_borders, class_name: 'ProposalBorder'
  has_many :groups, class_name: 'Group'

  belongs_to :territory, polymorphic: true

  DISTRICT = 'District'.freeze
  MUNICIPALITY = 'Municipality'.freeze
  PROVINCE = 'Province'.freeze
  REGION = 'Region'.freeze
  COUNTRY = 'Country'.freeze
  CONTINENT = 'Continent'.freeze
  GENERIC = 'Generic'.freeze
  SHORT_MUNICIPALITY = 'C'.freeze
  SHORT_PROVINCE = 'P'.freeze
  SHORT_REGION = 'R'.freeze
  SHORT_COUNTRY = 'S'.freeze
  SHORT_CONTINENT = 'K'.freeze
  SHORT_GENERIC = 'G'.freeze
  TYPE_MAP = { MUNICIPALITY => SHORT_MUNICIPALITY,
               REGION => SHORT_REGION,
               PROVINCE => SHORT_PROVINCE,
               COUNTRY => SHORT_COUNTRY,
               CONTINENT => SHORT_CONTINENT,
               GENERIC => SHORT_GENERIC }.freeze
  I_TYPE_MAP = TYPE_MAP.invert

  def district
    is_district? ? territory : nil
  end

  def municipality
    is_municipality? ? territory : territory.try(:municipality)
  end

  def province
    is_province? ? territory : territory.try(:province)
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

  def is_municipality?
    territory_type == MUNICIPALITY
  end

  def is_province?
    territory_type == PROVINCE
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
    ftype = border[0, 1] # tipologia (primo carattere)
    fid = border[2..] # chiave primaria (dal terzo all'ultimo carattere)
    found = false
    case ftype
    when SHORT_MUNICIPALITY
      found = Municipality.find_by(id: fid)
    when SHORT_PROVINCE
      found = Province.find_by(id: fid)
    when SHORT_REGION
      found = Region.find_by(id: fid)
    when SHORT_COUNTRY
      found = Country.find_by(id: fid)
    when SHORT_CONTINENT
      found = Continent.find_by(id: fid)
    when SHORT_GENERIC
      found = GenericBorder.find_by(id: fid)
    end
    found
  end

  def self.to_key(table_row)
    "#{TYPE_MAP[table_row.class.name]}-#{table_row.id}"
  end

  def self.key_to_json(key)
    { id: key, text: table_element(key).name }
  end

  def key
    "#{TYPE_MAP[territory_type]}-#{territory_id}"
  end

  def text
    territory.name
  end

  def as_json(_options = {})
    { id: key, text: text }
  end

  def self.find_or_create_by_key(key)
    return if key.blank?

    ftype = key[0, 1] # type (primo carattere)
    fid = key[2..] # primary key (dal terzo all'ultimo carattere)
    find_or_create_by(territory_type: I_TYPE_MAP[ftype], territory_id: fid)
  end
end
