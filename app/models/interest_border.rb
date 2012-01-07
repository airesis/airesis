class InterestBorder < ActiveRecord::Base
  has_many :proposal_borders, :class_name => 'ProposalBorder'
  
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
end
