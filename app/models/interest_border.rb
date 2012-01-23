class InterestBorder < ActiveRecord::Base
  has_many :proposal_borders, :class_name => 'ProposalBorder'
  has_many :groups, :class_name => 'Group'
  
  attr_accessible :foreign_id, :ftype
  
  def description
    return territory(self.foreign_id,true)
  end
  
  def territory(fid=self.foreign_id,description=false)
    case self.ftype
     when 'C'
       comune = Comune.find_by_id(fid)
       return description ? comune.description + ' (Comune)' : comune
     when 'P'
       provincia = Provincia.find_by_id(fid)
       return description ? provincia.description + ' (Provincia)' : provincia
     when 'R'
       regione = Regione.find_by_id(fid)
       return description ? regione.description + ' (Regione)' : regione
     else
       raise Exception
    end
  end
  
  
  def self.table_element(border)
    ftype = border[0,1] #tipologia (primo carattere)
    fid = border[2..-1] #chiave primaria (dal terzo all'ultimo carattere)
    found = false  
     case ftype
      when 'C' #comune
        comune = Comune.find_by_id(fid)
        found = comune
      when 'P' #provincia
          provincia = Provincia.find_by_id(fid)
          found = provincia
      when 'R' #regione
          regione = Regione.find_by_id(fid)
          found = regione
      end
      return found
  end
  
  
  def as_json(options={})
   { :id => ftype + "-" + foreign_id.to_s, :name => description }
  end
end
