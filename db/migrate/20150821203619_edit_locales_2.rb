class EditLocales2 < ActiveRecord::Migration
  def change
    Country::Translation.where(locale: 'ro-RO').update_all(locale: 'ro')
    Continent::Translation.where(locale: 'ro-RO').update_all(locale: 'ro')

    Country::Translation.where(locale: 'pt-PT').update_all(locale: 'pt')
    Continent::Translation.where(locale: 'pt-PT').update_all(locale: 'pt')

    Country::Translation.where(locale: 'es-ES').update_all(locale: 'es')
    Continent::Translation.where(locale: 'es-ES').update_all(locale: 'es')
  end
end
