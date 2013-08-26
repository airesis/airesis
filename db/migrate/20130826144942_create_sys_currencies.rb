class CreateSysCurrencies < ActiveRecord::Migration
  def up
    create_table :sys_currencies do |t|
      t.string :description, limit: 10, null: false
      t.timestamps
    end

    SysCurrency.create(description: 'EUR')
    SysCurrency.create(description: 'CHF')
    SysCurrency.create(description: '$')
  end

  def down
    drop_table :sys_currencies
  end
end
