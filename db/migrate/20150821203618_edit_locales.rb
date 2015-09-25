class EditLocales < ActiveRecord::Migration
  def change
    Country::Translation.where(locale: 'it-IT').update_all(locale: 'it')
    Continent::Translation.where(locale: 'it-IT').update_all(locale: 'it')
  end
end
