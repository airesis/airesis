class NoNullRole < ActiveRecord::Migration
  def up
    Group.transaction do
      Group.where(participation_role_id: nil).all.each do |group|
        role = group.participation_roles.first

         if role
           group.participation_role_id = role.id
           group.save!
         else
           group.destroy
         end

      end
    end

    change_column :groups, :participation_role_id, :integer, null: false
  end

  def down
    change_column :groups, :participation_role_id, :integer, null: true
  end
end
