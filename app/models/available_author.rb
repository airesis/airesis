#encoding: utf-8
class AvailableAuthor < ActiveRecord::Base
  belongs_to :user, :class_name => 'User', :foreign_key => :user_id
  belongs_to :proposal, :class_name => 'Proposal', :foreign_key => :proposal_id
  
  validates_uniqueness_of :user_id, :scope => :proposal_id, :message => 'Questo utente si è già reso disponibile come redattore per questa proposta'
  
end
