class CreateGroupInvitations < ActiveRecord::Migration
  def up
    create_table :group_invitations do |t|
      t.string :token, null: false, limit: 32
      t.timestamp :created_at, null: false
      t.integer :inviter_id, null: false
      t.integer :invited_id
      t.boolean :consumed, null: false, default: false
      t.integer :group_invitation_email_id, null: false
      t.string :testo, limit: 4000
    end

    add_foreign_key(:group_invitations,:users, {column: :inviter_id})
    add_foreign_key(:group_invitations,:users, {column: :invited_id})
    add_index :group_invitations, :group_invitation_email_id, unique: true

    create_table :group_invitation_emails do |t|
      t.string :email, null: false, limit: 200
      t.integer :group_id, null: false
      t.string :accepted, null: false, limit: 1, default: 'W'
      t.timestamps
    end
    add_foreign_key(:group_invitation_emails,:groups)
    add_index :group_invitation_emails, [:email,:group_id], unique: true

    create_table :banned_emails do |t|
      t.string :email, null: false, limit: 200
      t.timestamp :created_at, null: false
    end

    add_index :banned_emails, :email, unique: true
  end


  def down
    drop_table :group_invitations
    drop_table :group_invitation_emails
    drop_table :banned_emails
  end
end
