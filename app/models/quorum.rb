class Quorum < ActiveRecord::Base
  include ActionView::Helpers::TextHelper
  
  STANDARD = 2 
  
  validates :good_score, :presence => true
  validates :name, :presence => true
  
  validate :minutes_or_percentage
  
  has_one :group_quorum, :class_name => 'GroupQuorum', :dependent => :destroy
  has_one :group, :through => :group_quorum, :class_name => 'Group'
  has_one :proposal, :class_name => 'Proposal'
  
  scope :public, { :conditions => ["public = ?",true]}
  scope :active, { :conditions => ["active = ?",true]}
  
  attr_accessor :days_m, :hours_m, :minutes_m
  
  before_save :populate

  def or?
    return self.condition && (self.condition.upcase == 'OR')
  end
  
  def and?
    return self.condition && (self.condition.upcase == 'AND')
  end
    
  def minutes_or_percentage
    if (self.days_m.blank? && self.hours_m.blank? && self.minutes_m.blank? && !self.percentage && !self.minutes)
      self.errors.add(:minutes, "Devi indicare la durata della proposta o il numero minimo di partecipanti")
    end
  end
  
  #se i minuti non vengono definiti direttamente (come in caso di copia) allora calcolali dai dati di input
  def populate 
    if (!self.minutes)
      self.minutes = self.minutes_m.to_i + (self.hours_m.to_i * 60) + (self.days_m.to_i * 24 * 60)
      self.minutes = nil if (self.minutes == 0)
    end
  end
  
  def time
    min = self.minutes
    return nil if !min
    if (min > 59)
      hours = min/60
      min = min%60
      if (hours > 23)
        days = hours/24
        hours = hours%24
      end
    end
    ar = []
    ar << pluralize(days,"giorno","giorni") if (days && days > 0)
    ar << pluralize(hours,"ora","ore") if (hours && hours > 0)
    ar << pluralize(min,"minuto","minuti") if (min && min > 0)
    retstr = ar.join(" e ")    
    return  retstr
  end
end
