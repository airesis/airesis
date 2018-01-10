class RemoveUnusedTables2018 < ActiveRecord::Migration
  def change
    drop_table 'action_abilitations' do |t|
      t.integer  'group_action_id'
      t.integer  'participation_role_id'
      t.integer  'group_id'
      t.datetime 'created_at'
      t.datetime 'updated_at'
    end

    drop_table 'area_action_abilitations' do |t|
      t.integer  'group_action_id', null: false
      t.integer  'area_role_id',    null: false
      t.integer  'group_area_id',   null: false
      t.datetime 'created_at',      null: false
      t.datetime 'updated_at',      null: false
    end

    drop_table 'group_actions' do |t|
      t.string   'name',       limit: 255
      t.datetime 'created_at'
      t.datetime 'updated_at'
      t.integer  'seq'
    end

    drop_table "sys_movements" do |t|
      t.integer  "sys_movement_type_id",               null: false
      t.integer  "sys_currency_id",                    null: false
      t.datetime "made_on",                            null: false
      t.integer  "user_id",                            null: false
      t.float    "amount",                             null: false
      t.datetime "created_at",                         null: false
      t.datetime "updated_at",                         null: false
      t.string   "description",          limit: 10000
    end

    drop_table "sys_currencies" do |t|
      t.string   "description", limit: 10, null: false
      t.datetime "created_at",             null: false
      t.datetime "updated_at",             null: false
    end

    drop_table "sys_movement_types" do |t|
      t.string   "description", limit: 20, null: false
      t.datetime "created_at",             null: false
      t.datetime "updated_at",             null: false
    end
  end
end
