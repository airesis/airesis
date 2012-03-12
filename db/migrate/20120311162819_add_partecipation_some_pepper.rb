class AddPartecipationSomePepper < ActiveRecord::Migration
  def up
    rename_table :meetings_partecipations, :meeting_partecipations
    add_column :meeting_partecipations, :comment, :string
    add_column :meeting_partecipations, :guests, :integer
    add_column :meeting_partecipations, :response, :string, :limit => 1
  end

  def down
    remove_column :meeting_partecipations, :comment
    remove_column :meeting_partecipations, :guests
    remove_column :meeting_partecipations, :response
  end
end
