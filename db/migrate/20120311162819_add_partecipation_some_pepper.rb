class AddParticipationSomePepper < ActiveRecord::Migration
  def up
    rename_table :meetings_participations, :meeting_participations
    add_column :meeting_participations, :comment, :string
    add_column :meeting_participations, :guests, :integer
    add_column :meeting_participations, :response, :string, limit: 1
  end

  def down
    remove_column :meeting_participations, :comment
    remove_column :meeting_participations, :guests
    remove_column :meeting_participations, :response
  end
end
