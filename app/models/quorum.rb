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
    ar << I18n.t('day',count: days) if (days && days > 0)
    ar << I18n.t('hour',count: hours) if (hours && hours > 0)
    ar << I18n.t('minute',count: min) if (min && min > 0)
    retstr = ar.join(" e ")    
    retstr
  end

  def explanation
    @explanation ||= explanation_pop
  end


  def min_partecipants
    @min_partecipants ||= min_partecipants_pop
  end

  protected

  def min_partecipants_pop
    count = 1
    if self.percentage
      if self.group
        count = (self.percentage.to_f * 0.01 * self.group.count_voter_partecipants)
			else
        count = (self.percentage.to_f * 0.001 * User.count)
		  end
      [count,1].max.floor
    else
      nil
    end
  end

  def explanation_pop
    conditions = []
    ret = ""
    if self.minutes
      if self.percentage
        if self.condition == 'OR'
          ret = I18n.translate('models.quorum.or_condition_1',percentage: self.percentage, time: self.time)
        else
          ret = I18n.translate('models.quorum.and_condition_1',percentage: self.percentage, time: self.time)
        end
      else
        ret = I18n.translate('models.quorum.time_condition_1',time: self.time)
      end
    elsif self.percentage
      ret = I18n.translate('models.quorum.participants_condition_1',percentage: self.percentage)
    end
    ret += "<br/>"
    ret += I18n.translate('models.quorum.good_score_condition',good_score: self.good_score)
    if self.bad_score && self.bad_score != self.good_score
      ret += " "
      ret += I18n.translate('models.quorum.bad_score_condition',bad_score: self.bad_score)
      ret += "<br/>"
      ret += I18n.translate('models.quorum.bad_score_explain')
    end
    ret += "."
    ret.html_safe
  end
end
