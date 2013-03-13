class DisableCategories < ActiveRecord::Migration
  def up
    Configuration.create(name: 'proposal_categories', value: 1)
    Configuration.create(name: 'folksonomy', value: 1)
  end

  def down
    Configuration.find_by_name('proposal_categories').destroy
    Configuration.find_by_name('folksonomy').destroy
  end
end
