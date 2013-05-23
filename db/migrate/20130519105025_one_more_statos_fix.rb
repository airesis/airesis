class OneMoreStatosFix < ActiveRecord::Migration
  def up
    execute " update stato_translations
              set stato_id = stato_id - 1
              where locale = 'it' and stato_id > 4"

    execute " update comunes set description = initcap(lower(description))"
  end

  def down
    execute " update stato_translations
              set stato_id = stato_id + 1
              where locale = 'it' and stato_id > 3"
  end
end
