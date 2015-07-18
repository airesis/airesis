# define permissions for users
class Ability
  include CanCan::Ability
  include Abilities::Commons

  def initialize(user)
    merge Abilities::Guest.new(user)
    return unless user
    merge Abilities::Logged.new(user)
    return unless user.moderator?
    merge Abilities::Moderator.new(user)
    return unless user.admin?
    merge Abilities::Admin.new(user)
  end
end
