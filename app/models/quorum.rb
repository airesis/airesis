#encoding: utf-8
class Quorum < ActiveRecord::Base
  include ActionView::Helpers::TextHelper

  STANDARD = 2

  validates :good_score, :presence => true
  validates :name, :presence => true

  validate :minutes_or_percentage

  validates :condition, :inclusion => {:in => ['OR', 'AND']}

  has_one :group_quorum, :class_name => 'GroupQuorum', :dependent => :destroy
  has_one :group, :through => :group_quorum, :class_name => 'Group'
  has_one :proposal, :class_name => 'Proposal'

  scope :public, {:conditions => ["public = ?", true]}
  scope :active, {:conditions => ["active = ?", true]}

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
    self.form_type = (self.percentage || (self.good_score != self.bad_score)) ? 'a' : 's'
  end

  def or?
    self.condition && (self.condition.upcase == 'OR')
  end

  def and?
    self.condition && (self.condition.upcase == 'AND')
  end

  #return true if the quorum is assigned to a proposal
  def assigned?
    self.started_at != nil
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
    unless self.minutes
      self.minutes = self.minutes_m.to_i + (self.hours_m.to_i * 60) + (self.days_m.to_i * 24 * 60)
      self.minutes = nil if (self.minutes == 0)
    end

    #se il form compilato è semplice tolgo tutti i possibili parametri che sono stati
    #impostati e non servono più
    if self.form_type && (self.form_type == 's')
      self.bad_score = self.good_score
      self.percentage = nil
    end
    self.bad_score =self.good_score unless self.bad_score
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

  #return true if there is still time left to the end of the quorum
  def time_left?
    self.ends_at && (self.ends_at - Time.now > 0)
  end


  #used to describe the remaining time left for the discussion.
  #if the quorum is assigned, if the quorum is not assigned it show the total time
  #When total_time=true, force to show the total time
  def time(total_time=false)
    min = nil
    if self.minutes
      if self.assigned? && !total_time #if is assigned and we are not forcing total time show remaining
        min = (self.ends_at - Time.now).to_i/60
      else
        min = self.minutes
      end
    end
    if min && min > 0
      if min > 59
        hours = min/60
        min = min%60
        if hours > 23
          days = hours/24
          hours = hours%24
          min = 0 if hours != 0
          if days > 30
            months = days/30
            days = days%30
            min = 0
          end
        end
      end
      ar = []
      ar << I18n.t('time.left.months', count: months) if (months && months > 0)
      ar << I18n.t('time.left.days', count: days) if (days && days > 0)
      ar << I18n.t('time.left.hours', count: hours) if (hours && hours > 0)
      ar << I18n.t('time.left.minutes', count: min) if (min && min > 0)
      retstr = ar.join(" #{I18n.t('words.and')} ")
    else
      retstr = nil
    end
    retstr
  end

  def end_desc
    conds = []
    conds << "#{I18n.l self.ends_at} " if self.ends_at
    conds << " #{I18n.t('pages.proposals.new_rank_bar.valutations', count: self.valutations)}" if self.valutations
    conds.join(or? ? I18n.t('words.or') : I18n.t('words.and'))
  end

  #short description of time left
  def time_left
    ret = []
    if self.minutes
      amount = self.ends_at - Time.now #left in seconds
      if amount > 0
        left = I18n.t('time.left.seconds', count: amount.to_i)
        if amount >= 60 #if more or equal than 60 seconds left give me minutes
          amount_min = amount/60
          left = I18n.t('time.left.minutes', count: amount_min.to_i)
          if amount_min >= 60 #if more or equal than 60 minutes left give me hours
            amount_hour = amount_min/60
            left = I18n.t('time.left.hours', count: amount_hour.to_i)
            if amount_hour > 24 #if more than 24 hours left give me days
              amount_days = amount_hour/24
              left = I18n.t('time.left.days', count: amount_days.to_i)
            end
          end
        end
        ret << left.upcase
      end
    end
    if self.percentage
      valutations = self.valutations - self.proposal.valutations
      if valutations > 0
        ret << I18n.t('pages.proposals.new_rank_bar.valutations', count: valutations)
      end
    end
    if ret.size > 0
      ret.join(or? ? " #{I18n.t('words.or').upcase} " : " #{I18n.t('words.and').upcase} ")
    else
      "IN STALLO" #todo:i18n
    end

  end

  def valutations_left?
    self.valutations && (self.valutations - self.proposal.valutations > 0)
  end

  def valutations_left
    ret = []
    valutations = self.valutations - self.proposal.valutations if self.valutations
    if valutations && valutations > 0
      ret << I18n.t('pages.proposals.new_rank_bar.valutations', count: valutations)
      ret.join
    end
  end


  def explanation
    @explanation ||= explanation_pop
  end


  #calculate minimum number of partecipants
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
        count = (self.percentage.to_f * 0.01 * self.group.count_voter_partecipants) #todo group areas
      else
        count = (self.percentage.to_f * 0.001 * User.count)
      end
      [count, 1].max.floor
    else
      nil
    end
  end

  # @param [boolean] terminated true if the quorum is terminated and proposal got over it
  def explanation_pop
    conditions = []
    ret = ''
    if assigned? #explain a quorum assigned to a proposal
      if self.proposal.abandoned?
        ret = terminated_explanation_pop
      else
        ret = assigned_explanation_pop
      end
    else
      ret = unassigned_explanation_pop #it a non assigned quorum
    end

    ret += "."
    ret.html_safe
  end


  #TODO we need to refactor this part of code but at least now is more clear
  #explain a quorum when assigned to a proposal in it's current state
  def assigned_explanation_pop
    ret = ''
    if self.minutes && self.time_left? #if the quorum has a minimum time and there is still time remaining
      time = "<b>#{self.time}</b> "
      time +=I18n.t('models.quorum.until_date', date: I18n.l(self.ends_at))

      if self.percentage && self.valutations_left?
        participants = I18n.t('models.quorum.participants', count: self.valutations)
        if self.or?
          ret = I18n.translate('models.quorum.or_condition_1', #display number of required evaluations and time left
                               percentage: self.percentage,
                               time: time,
                               participants_num: participants)
        else #and
          ret = I18n.translate('models.quorum.and_condition_1', #display number of required evaluations and time left
                               percentage: self.percentage,
                               time: time,
                               participants_num: participants)

        end
      else #only time
        ret = I18n.translate('models.quorum.time_condition_1', time: time) #display the time left for discussion
      end
    elsif self.percentage && self.valutations_left? #if the quorum has only valutations left
      participants = I18n.t('models.quorum.participants', count: self.valutations)
      ret = I18n.translate('models.quorum.participants_condition_1',
                           percentage: self.percentage,
                           participants_num: participants) #display only number of required evaluations
    else #stalled

    end
    ret += "<br/>"
    if self.bad_score && (self.bad_score != self.good_score) #if quorum has negative quorum and it is not the same as positive quorum
      ret += I18n.translate('models.quorum.bad_score_explain', good_score: self.good_score, bad_score: self.bad_score)
    else #if quorum has negative quorum and it is the same as positive quorum
      ret += I18n.translate('models.quorum.good_score_condition', good_score: self.good_score)
    end
    ret
  end

  #explain a quorum in a proposal that has temrinated her life cycle
  def terminated_explanation_pop
    ret = ''
    if self.minutes #if the quorum has a minimum time
      time = "<b>#{self.time(true)}</b> " #show total time if the quorum is terminated
      time +=I18n.t('models.quorum.until_date', date: I18n.l(self.ends_at))
      if self.percentage
        participants = I18n.t('models.quorum.participants_past', count: self.valutations)
        if self.or?
          ret = I18n.translate('models.quorum.or_condition_1_past', #display number of required evaluations and time left
                               percentage: self.percentage,
                               time: time,
                               participants_num: participants)
        else #and
          ret = I18n.translate('models.quorum.and_condition_1_past', #display number of required evaluations and time left
                               percentage: self.percentage,
                               time: time,
                               participants_num: participants)
        end
      else #only time
        ret = I18n.translate('models.quorum.time_condition_1_past', time: time) #display the time left for discussion
      end
    else #only valutations
      participants = I18n.t('models.quorum.participants_past', count: self.valutations)
      ret = I18n.translate('models.quorum.participants_condition_1_past',
                           percentage: self.percentage,
                           participants_num: participants) #display only number of required evaluations
    end
    ret += "<br/>"
    if self.bad_score && (self.bad_score != self.good_score) #if quorum has negative quorum and it is not the same as positive quorum
      ret += I18n.translate('models.quorum.bad_score_explain_past', good_score: self.good_score, bad_score: self.bad_score)
    else #if quorum has negative quorum and it is the same as positive quorum
      ret += I18n.translate('models.quorum.good_score_condition_past', good_score: self.good_score)
    end
    ret
  end

  #explain a non assigned quorum
  def unassigned_explanation_pop
    ret = ''
    if self.minutes #if the quorum has a minimum time
      time = "<b>#{self.time}</b> "
      if self.percentage
        participants = I18n.t('models.quorum.participants', count: self.min_partecipants)
        if self.or?
          ret = I18n.translate('models.quorum.or_condition_1', #display number of required evaluations and time left
                               percentage: self.percentage,
                               time: time,
                               participants_num: participants)
        else #and
          ret = I18n.translate('models.quorum.and_condition_1', #display number of required evaluations and time left
                               percentage: self.percentage,
                               time: time,
                               participants_num: participants)
        end
      else #if the quorum has only minimum time of discussion
        ret = I18n.translate('models.quorum.time_condition_1', time: time) #display the time left for discussion
      end
    else #only evaluations
      participants = I18n.t('models.quorum.participants', count: self.min_partecipants)
      ret = I18n.translate('models.quorum.participants_condition_1', participants_num: participants) #display number of required evaluations
    end
    ret += "<br/>"
    if self.bad_score && (self.bad_score != self.good_score) #if quorum has negative quorum and it is not the same as positive quorum
      ret += I18n.translate('models.quorum.bad_score_explain', good_score: self.good_score, bad_score: self.bad_score)
    else #if quorum has negative quorum and it is the same as positive quorum
      ret += I18n.translate('models.quorum.good_score_condition', good_score: self.good_score)
    end
    ret
  end
end
