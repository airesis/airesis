class InterestBorder < ActiveRecord::Base
  has_many :proposal_borders, class_name: 'ProposalBorder'
  has_many :groups, class_name: 'Group'

  belongs_to :territory, polymorphic: true

  DISTRICT = 'District'
  COMUNE = 'Comune'
  PROVINCIA = 'Provincia'
  REGIONE = 'Regione'
  COUNTRY = 'Country'
  CONTINENTE = 'Continente'
  GENERIC = 'Generic'
  SHORT_COMUNE = 'C'
  SHORT_PROVINCIA = 'P'
  SHORT_REGIONE = 'R'
  SHORT_COUNTRY = 'S'
  SHORT_CONTINENTE = 'K'
  SHORT_GENERIC = 'G'
  TYPE_MAP = {COMUNE => SHORT_COMUNE,
              REGIONE => SHORT_REGIONE,
              PROVINCIA => SHORT_PROVINCIA,
              COUNTRY => SHORT_COUNTRY,
              CONTINENTE => SHORT_CONTINENTE,
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

  def regione
    is_regione? ? territory : territory.try(:regione)
  end

  def country
    is_country? ? territory : territory.try(:country)
  end

  def continente
    is_continente? ? territory : territory.try(:continente)
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

  def is_regione?
    territory_type == REGIONE
  end

  def is_country?
    territory_type == COUNTRY
  end

  def is_continente?
    territory_type == CONTINENTE
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
      when SHORT_COMUNE #comune
        comune = Comune.find_by_id(fid)
        found = comune
      when SHORT_PROVINCIA #provincia
        provincia = Provincia.find_by_id(fid)
        found = provincia
      when SHORT_REGIONE #regione
        regione = Regione.find_by_id(fid)
        found = regione
      when SHORT_COUNTRY
        found = Country.find_by_id(fid)
      when SHORT_CONTINENTE
        continente = Continente.find_by_id(fid)
        found = continente
      when SHORT_GENERIC
        generic = GenericBorder.find_by_id(fid)
        found = generic
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
