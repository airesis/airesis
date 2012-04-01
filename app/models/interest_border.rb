class InterestBorder < ActiveRecord::Base
  has_many :proposal_borders, :class_name => 'ProposalBorder'
  has_many :groups, :class_name => 'Group'
  
  attr_accessible :territory_id, :territory_type

  belongs_to :territory, :polymorphic => true

  COMUNE = 'Comune'
  PROVINCIA = 'Provincia'
  REGIONE = 'Regione'
  SHORT_COMUNE = 'C'
  SHORT_PROVINCIA = 'P'
  SHORT_REGIONE = 'R'
  TYPE_MAP = { COMUNE => SHORT_COMUNE, REGIONE => SHORT_REGIONE, PROVINCIA => SHORT_PROVINCIA}
  I_TYPE_MAP = { SHORT_COMUNE => COMUNE, SHORT_REGIONE => REGIONE, SHORT_PROVINCIA => PROVINCIA}

  
  def description
    return territory.description + ' (' + territory_type + ')'    
  end
  
  
  
  def self.table_element(border)
    ftype = border[0,1] #tipologia (primo carattere)
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
      end
      return found
  end
  
  def as_json(options={})
    
   { :id => TYPE_MAP[self.territory_type] + "-" + self.territory_id.to_s, :name => self.description }
  end
  
end
