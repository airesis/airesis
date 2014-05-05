class InterestBorder < ActiveRecord::Base
  has_many :proposal_borders, class_name: 'ProposalBorder'
  has_many :groups, class_name: 'Group'

  attr_accessible :territory_id, :territory_type

  belongs_to :territory, polymorphic: true

  CIRCOSCRIZIONE = 'Circoscrizione'
  COMUNE = 'Comune'
  PROVINCIA = 'Provincia'
  REGIONE = 'Regione'
  STATO = 'Stato'
  CONTINENTE = 'Continente'
  GENERIC = 'Generic'
  SHORT_COMUNE = 'C'
  SHORT_PROVINCIA = 'P'
  SHORT_REGIONE = 'R'
  SHORT_STATO = 'S'
  SHORT_CONTINENTE = 'K'
  SHORT_GENERIC = 'G'
  TYPE_MAP = {COMUNE => SHORT_COMUNE, REGIONE => SHORT_REGIONE, PROVINCIA => SHORT_PROVINCIA, STATO => SHORT_STATO, CONTINENTE => SHORT_CONTINENTE, GENERIC => SHORT_GENERIC}
  I_TYPE_MAP = {SHORT_COMUNE => COMUNE, SHORT_REGIONE => REGIONE, SHORT_PROVINCIA => PROVINCIA, SHORT_STATO => STATO, SHORT_CONTINENTE => CONTINENTE, SHORT_GENERIC => GENERIC}

  #retrieve the comune in wich is the interest border. nil if it's not inside a comune
  def circoscrizione
    if self.is_circoscrizione?
      self.territory
    else
      nil
    end
  end

  def comune
    if self.is_comune?
      self.territory
    elsif self.territory.respond_to? :comune
      self.territory.comune
    else
      nil
    end
  end

  def provincia
    if self.is_provincia?
      self.territory
    elsif self.territory.respond_to? :provincia
      self.territory.provincia
    else
      nil
    end
  end

  def regione
    if self.is_regione?
      self.territory
    elsif self.territory.respond_to? :regione
      self.territory.regione
    else
      nil
    end
  end

  def stato
    if self.is_stato?
      self.territory
    elsif self.territory.respond_to? :stato
      self.territory.stato
    else
      nil
    end
  end

  def continente
    if self.is_continente?
      self.territory
    elsif self.territory.respond_to? :continente
      self.territory.continente
    else
      nil
    end
  end

  def is_circoscrizione?
    self.territory_type == CIRCOSCRIZIONE
  end

  def is_comune?
    self.territory_type == COMUNE
  end

  def is_provincia?
    self.territory_type == PROVINCIA
  end

  def is_regione?
    self.territory_type == REGIONE
  end

  def is_stato?
    self.territory_type == STATO
  end

  def is_continente?
    self.territory_type == CONTINENTE
  end

  def is_generic?
    self.territory_type == GENERIC
  end

  def description
    return territory.description + ' (' + (self.is_generic? ? territory.name : territory_type) + ')'
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
      when SHORT_STATO
        stato = Stato.find_by_id(fid)
        found = stato
      when SHORT_CONTINENTE
        continente = Continente.find_by_id(fid)
        found = continente
      when SHORT_GENERIC
        generic = GenericBorder.find_by_id(fid)
        found = generic
    end
    found
  end

  def as_json(options={})
    {id: TYPE_MAP[self.territory_type] + "-" + self.territory_id.to_s, name: self.description}
  end

end
