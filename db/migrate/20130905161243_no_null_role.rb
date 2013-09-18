class NoNullRole < ActiveRecord::Migration
  def up
    Group.transaction do
      Group.where(:partecipation_role_id => nil).all.each do |group|
        role = group.partecipation_roles.first

         if role then
           puts role.id
           group.partecipation_role_id = role.id
           group.save!
         else
           puts "group #{group.name} has no roles"
           group.destroy
         end

      end
    end

    change_column :groups, :partecipation_role_id, :integer, null: false
  end

  def down
    change_column :groups, :partecipation_role_id, :integer, null: true
  end
end
