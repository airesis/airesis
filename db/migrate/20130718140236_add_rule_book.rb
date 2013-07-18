class AddRuleBook < ActiveRecord::Migration
  def up
    add_column :groups, :rule_book, :string, limit: 40000
  end

  def down
    remove_column :groups, :rule_book
  end
end
