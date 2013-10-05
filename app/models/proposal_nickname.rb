#encoding: utf-8
class ProposalNickname < ActiveRecord::Base
  belongs_to :user, :class_name => 'User', :foreign_key => :user_id
  belongs_to :proposal, :class_name => 'Proposal', :foreign_key => :proposal_id
  
  validates_uniqueness_of :user_id, :scope => :proposal_id, :message => 'Questo utente ha già un nickname in questa proposta'
  validates_uniqueness_of :nickname, :scope => :proposal_id, :message => 'Questo nickname è già in uso in questa proposta'


  def avatar(size=24)
    "http://www.gravatar.com/avatar/#{Digest::MD5.hexdigest(self.nickname)}?s=#{size}&d=identicon&r=PG"
  end
end
