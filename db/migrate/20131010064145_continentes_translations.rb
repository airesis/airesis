#encoding: utf-8
class ContinentesTranslations < ActiveRecord::Migration
  def up
    I18n.locale = 'it-IT'
    Continente.create_translation_table!({
                                             description: :string
                                         }, {
                                             migrate_data: true
                                         })

  end

  def down
  end
end
