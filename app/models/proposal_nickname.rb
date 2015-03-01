class ProposalNickname < ActiveRecord::Base
  belongs_to :user, class_name: 'User', foreign_key: :user_id
  belongs_to :proposal, class_name: 'Proposal', foreign_key: :proposal_id

  validates_uniqueness_of :user_id, scope: :proposal_id, message: 'Questo utente ha già un nickname in questa proposta'
  validates_uniqueness_of :nickname, scope: :proposal_id, message: 'Questo nickname è già in uso in questa proposta'

  attr_accessor :generated

  def avatar(size=24)
    "http://www.gravatar.com/avatar/#{Digest::MD5.hexdigest(self.nickname)}?s=#{size}&d=identicon&r=PG"
  end

  #a factory for nicknames. to be called when is necessary to generate a nickname for a user in a proposal
  def self.generate(user, proposal)
    proposal_nickname = ProposalNickname.find_by(user_id: user.id, proposal_id: proposal.id)
    return proposal_nickname if proposal_nickname
    loop = true
    while loop do
      nickname = NicknameGeneratorHelper.give_me_a_nickname
      loop = ProposalNickname.find_by(proposal_id: proposal.id, nickname: nickname)
    end
    proposal_nickname = ProposalNickname.create(user_id: user.id, proposal_id: proposal.id, nickname: nickname)
    proposal_nickname.generated = proposal.anonima?
    proposal_nickname
  end


  def to_json
    {name: nickname, id: id, avatar: avatar(16), type: 'nickname'}
  end
end
