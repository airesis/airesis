#encoding: utf-8
class Quorum < ActiveRecord::Base
  include ActionView::Helpers::TextHelper
  
  STANDARD = 2 
  
  validates :good_score, :presence => true
  validates :name, :presence => true
  
  validate :minutes_or_percentage
  
  validates :condition, :inclusion => {:in => ['OR','AND']}
  
  has_one :group_quorum, :class_name => 'GroupQuorum', :dependent => :destroy
  has_one :group, :through => :group_quorum, :class_name => 'Group'
  has_one :proposal, :class_name => 'Proposal'
  
  scope :public, { :conditions => ["public = ?",true]}
  scope :active, { :conditions => ["active = ?",true]}
  
  attr_accessor :days_m, :hours_m, :minutes_m, :form_type
  
  before_save :populate

  before_update :populate!

  after_find :populate_accessor

  def populate_accessor
    self.minutes_m = self.minutes
    if self.minutes_m
      if self.minutes_m > 59
        self.hours_m = self.minutes_m/60
        self.minutes_m = self.minutes_m%60
        if self.hours_m > 23
          self.days_m = self.hours_m/24
          self.hours_m = self.hours_m%24
        end
      end
    end
    self.form_type = self.valutations || self.good_score != self.bad_score ? 'a' : 's'
  end

  def or?
    self.condition && (self.condition.upcase == 'OR')
  end
  
  def and?
    self.condition && (self.condition.upcase == 'AND')
  end
    
  def minutes_or_percentage
    if self.days_m.blank? && self.hours_m.blank? && self.minutes_m.blank? && !self.percentage && !self.minutes
      self.errors.add(:minutes, "Devi indicare la durata della proposta o il numero minimo di partecipanti")
    end
  end
  
  #se i minuti non vengono definiti direttamente (come in caso di copia) allora calcolali dai dati di input
  def populate
    if !self.minutes
      self.minutes = self.minutes_m.to_i + (self.hours_m.to_i * 60) + (self.days_m.to_i * 24 * 60)
      self.minutes = nil if (self.minutes == 0)
    end

    #se il form compilato è semplice tolgo tutti i possibili parametri che sono stati
    #impostati e non servono più
    if self.form_type && (self.form_type == 's')
      self.bad_score = self.good_score
      self.percentage = nil
    end
  end

  def populate!
      self.minutes = self.minutes_m.to_i + (self.hours_m.to_i * 60) + (self.days_m.to_i * 24 * 60)
      self.minutes = nil if (self.minutes == 0)

    #se il form compilato è semplice tolgo tutti i possibili parametri che sono stati
    #impostati e non servono più
    if self.form_type && (self.form_type == 's')
      self.bad_score = self.good_score
      self.percentage = nil
    end
  end
  
  def time
    min = self.minutes
    return nil if !min
    if min > 59
      hours = min/60
      min = min%60
      if hours > 23
        days = hours/24
        hours = hours%24
      end
    end
    ar = []
    ar << pluralize(days,"giorno","giorni") if (days && days > 0)
    ar << pluralize(hours,"ora","ore") if (hours && hours > 0)
    ar << pluralize(min,"minuto","minuti") if (min && min > 0)
    retstr = ar.join(" e ")    
    retstr
  end

  def explanation
    @explanation = explanation_pop
  end

  protected

  def explanation_pop
    conditions = []
    if self.minutes
      ret = ""
      if self.percentage
        if self.condition == 'OR'
          ret = "Il dibattito proseguirà finchè non avranno partecipato il #{self.percentage}% degli aventi diritto e, in ogni caso, al massimo per #{self.time}."
        else
          ret = "Il dibattito durerà #{self.time} ma proseguirà se non avrà partecipato almeno il #{self.percentage}% degli aventi diritto."
        end
      else
        ret = "Il dibattito durerà esattamente #{self.time}."
      end
    elsif self.percentage
      ret = "Il dibattito proseguirà finchè non avranno partecipato il #{self.percentage}% degli aventi diritto."
    end
    ret += "<br/>Andrà in votazione se supererà il #{self.good_score}% del gradimento"
    if self.bad_score && self.bad_score != self.good_score
      ret += " e verrà abbandonata se sarà sotto il #{self.bad_score}%.<br/>Il dibattito continuerà se il gradimento rimarrà tra queste due soglie indipendentemente dal tempo o dal numero di valutazioni."
    end
    ret += "."
    ret.html_safe
  end
end
