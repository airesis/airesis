# abilitation to the actions for roles in groups
class ActionAbilitation < ActiveRecord::Base
  belongs_to :group_action, class_name: 'GroupAction', foreign_key: :group_action_id
  belongs_to :participation_role, class_name: 'ParticipationRole', foreign_key: :participation_role_id

  # TODO: should I remove that? is not necessary anymore
  belongs_to :group, class_name: 'Group', foreign_key: :group_id
end
