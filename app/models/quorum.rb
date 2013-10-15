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

  def time_fixed?
    self.minutes && !self.percentage && ((self.good_score == self.bad_score) || !self.bad_score)
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
    retstr = ar.join(" "+I18n.t('pages.groups.edit_quorums.condition_AND')+" ")
    retstr
  end

  def end_desc
    conds = []
    conds << (I18n.l self.ends_at)+"  " if self.minutes
    conds << " "+I18n.t('pages.proposals.new_rank_bar.valutations', num:self.valutations) if self.percentage
    conds.join(or? ? I18n.t('pages.groups.edit_quorums.condition_OR') : I18n.t('pages.groups.edit_quorums.condition_AND'))
  end

  def time_left
    amount = self.ends_at - Time.now #left in seconds
    left = I18n.t('time.left.seconds',count: amount.to_i)
    if amount >= 60  #if more or equal than 60 seconds left give me minutes
      amount_min = amount/60
      left = I18n.t('time.left.minutes',count: amount_min.to_i)
      if amount_min >= 60 #if more or equal than 60 minutes left give me hours
        amount_hour = amount_min/60
        left = I18n.t('time.left.hours',count: amount_hour.to_i)
        if amount_hour > 24 #if more than 24 hours left give me days
          amount_days = amount_hour/24
          left = I18n.t('time.left.days',count: amount_days.to_i)
        end
      end
    end
    left
  end

  def explanation
    @explanation ||= explanation_pop
  end


  def min_partecipants
    @min_partecipants ||= min_partecipants_pop
  end

  def has_bad_score?
    self.bad_score && (self.bad_score != self.good_score)
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
    participants = I18n.t('models.quorum.participants', count: ((self.valutations == nil)? self.min_partecipants : self.valutations))
    if self.minutes
      if self.percentage
        if self.condition == 'OR'
          ret = I18n.translate('models.quorum.or_condition_1',
                               percentage: self.percentage,
                               time:((self.ends_at == nil)? "<b>"+self.time+"</b>" : "<b>"+self.time+"</b> "+I18n.t('models.quorum.until_date',date: I18n.l(self.ends_at, format: :long_date), time: I18n.l(self.ends_at, format: :hour))),
                               participants_num: participants)
        else
          ret = I18n.translate('models.quorum.and_condition_1',
                               percentage: self.percentage,
                               time:((self.ends_at == nil)? "<b>"+self.time+"</b>" : "<b>"+self.time+"</b> "+I18n.t('models.quorum.until_date',date: I18n.l(self.ends_at, format: :long_date), time: I18n.l(self.ends_at, format: :hour))),
                               participants_num: participants)
        end
      else
        ret = I18n.translate('models.quorum.time_condition_1',
                             time: ((self.ends_at == nil)? "<b>"+self.time+"</b>" : "<b>"+self.time+"</b> "+I18n.t('models.quorum.until_date',date: I18n.l(self.ends_at, format: :long_date),time: I18n.l(self.ends_at, format: :hour))))
      end
    elsif self.percentage
      ret = I18n.translate('models.quorum.participants_condition_1',percentage: self.percentage, participants_num: participants)
    end
    if self.bad_score && (self.bad_score != self.good_score)
        ret += "<br/>"
        ret += I18n.translate('models.quorum.bad_score_explain', good_score: self.good_score, bad_score: self.bad_score)
    elsif self.good_score = self.bad_score
        ret += "<br/>"
        ret += I18n.translate('models.quorum.good_score_condition',good_score: self.good_score)
    end
    ret += "."
    ret.html_safe
  end



end
