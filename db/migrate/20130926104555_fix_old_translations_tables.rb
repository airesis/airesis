class FixOldTranslationsTables < ActiveRecord::Migration
  def up
    execute "update stato_translations set locale = 'it-IT' where locale = 'it'"
    execute "update stato_translations set locale = 'es-ES' where locale = 'es'"
    execute "update stato_translations set locale = 'en-US' where locale = 'eu'"
    execute "update stato_translations set locale = 'pt-PT' where locale = 'pt'"
  end

  def down
  end
end
