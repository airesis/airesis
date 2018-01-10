class SimplifyPermissions < ActiveRecord::Migration
  def change
    add_column :participation_roles, :write_to_wall, :boolean, null: false, default: false
    add_column :participation_roles, :create_events, :boolean, null: false, default: false
    add_column :participation_roles, :support_proposals, :boolean, null: false, default: false
    add_column :participation_roles, :accept_participation_requests, :boolean, null: false, default: false
    add_column :participation_roles, :view_proposals, :boolean, null: false, default: false
    add_column :participation_roles, :participate_proposals, :boolean, null: false, default: false
    add_column :participation_roles, :insert_proposals, :boolean, null: false, default: false
    add_column :participation_roles, :vote_proposals, :boolean, null: false, default: false
    add_column :participation_roles, :choose_date_proposals, :boolean, null: false, default: false
    add_column :participation_roles, :view_documents, :boolean, null: false, default: false
    add_column :participation_roles, :manage_documents, :boolean, null: false, default: false
    remove_column :participation_roles, :parent_participation_role_id, :integer

    add_column :area_roles, :view_proposals, :boolean, null: false, default: false
    add_column :area_roles, :participate_proposals, :boolean, null: false, default: false
    add_column :area_roles, :insert_proposals, :boolean, null: false, default: false
    add_column :area_roles, :vote_proposals, :boolean, null: false, default: false
    add_column :area_roles, :choose_date_proposals, :boolean, null: false, default: false

    ParticipationRole.includes(:group_actions).each do |participation_role|
      participation_role.group_actions.each do |group_action|
        if group_action.id == GroupAction::STREAM_POST
          participation_role.write_to_wall = true
        elsif group_action.id == GroupAction::CREATE_EVENT
          participation_role.create_events = true
        elsif group_action.id == GroupAction::SUPPORT_PROPOSAL
          participation_role.support_proposals = true
        elsif group_action.id == GroupAction::REQUEST_ACCEPT
          participation_role.accept_participation_requests = true
        elsif group_action.id == GroupAction::PROPOSAL_VIEW
          participation_role.view_proposals = true
        elsif group_action.id == GroupAction::PROPOSAL_PARTICIPATION
          participation_role.participate_proposals = true
        elsif group_action.id == GroupAction::PROPOSAL_INSERT
          participation_role.insert_proposals = true
        elsif group_action.id == GroupAction::DOCUMENTS_VIEW
          participation_role.view_documents = true
        elsif group_action.id == GroupAction::DOCUMENTS_MANAGE
          participation_role.manage_documents = true
        elsif group_action.id == GroupAction::PROPOSAL_VOTE
          participation_role.vote_proposals = true
        elsif group_action.id == GroupAction::PROPOSAL_DATE
          participation_role.choose_date_proposals = true
        end
      end
      participation_role.save!
    end

    AreaRole.includes(:area_actions).each do |area_role|
      area_role.area_actions.each do |group_action|
        if group_action.id == GroupAction::PROPOSAL_VIEW
          area_role.view_proposals = true
        elsif group_action.id == GroupAction::PROPOSAL_PARTICIPATION
          area_role.participate_proposals = true
        elsif group_action.id == GroupAction::PROPOSAL_INSERT
          area_role.insert_proposals = true
        elsif group_action.id == GroupAction::PROPOSAL_VOTE
          area_role.vote_proposals = true
        elsif group_action.id == GroupAction::PROPOSAL_DATE
          area_role.choose_date_proposals = true
        end
      end
      area_role.save!
    end
  end
end
