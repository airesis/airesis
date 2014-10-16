#encoding: utf-8
class Quorum < ActiveRecord::Base
  include ActionView::Helpers::TextHelper, NotificationHelper, Rails.application.routes.url_helpers, GroupsHelper

  STANDARD = 2

  validates :good_score, presence: true
  validates :name, presence: true

  has_one :group_quorum, class_name: 'GroupQuorum', dependent: :destroy
  has_one :group, through: :group_quorum, class_name: 'Group'
  has_one :proposal, class_name: 'Proposal'
  has_one :proposal_life

  scope :public, -> {where(["public = ?", true])}
  scope :active, -> {where(["active = ?", true])}
  scope :assigned, -> {where(["assigned = ?", true])}
  scope :unassigned, -> {where(["assigned = ?", false])}


  attr_accessor :days_m, :hours_m, :minutes_m


  after_find :populate_accessor

  before_validation :populate

  def populate
    self.minutes = self.minutes_m.to_i + (self.hours_m.to_i * 60) + (self.days_m.to_i * 24 * 60)
    self.minutes = nil if (self.minutes == 0)
  end

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

  #calculate minimum number of participants
  def min_participants
    @min_participants ||= min_participants_pop
  end

  #calculate minimum number of participants
  def min_vote_participants
    @min_vote_participants ||= min_vote_participants_pop
  end


  protected

  def abandon(proposal)
    proposal.proposal_state_id = ProposalState::ABANDONED
    life = proposal.proposal_lives.create(quorum_id: proposal.quorum_id, valutations: proposal.valutations, rank: proposal.rank, seq: ((proposal.proposal_lives.maximum(:seq) || 0) + 1))
    #save old authors
    proposal.users.each do |user|
      life.users << user
    end
    life.save!
    #delete old data
    proposal.valutations = 0
    proposal.rank = 0
    #proposal.quorum_id = nil

    #and authors
    proposal.proposal_presentations.destroy_all
    proposal.rankings.destroy_all
    #proposal.save!
  end



end
