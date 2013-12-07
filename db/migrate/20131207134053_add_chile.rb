class AddChile < ActiveRecord::Migration
  def up


    I18n.locale = 'en'
    @chile = Stato.find_by_description('Chile')


    I18n.locale = 'es-CL'
    @chile.update_attribute(:description, 'Chile')
    @chile_id = @chile.id
    @america_id = @chile.continente_id

    SysLocale.create(:key => 'es-CL', :host => 'http://www.airesis.us', lang: 'es-CL', territory: @chile)
  end

  def down
    I18n.locale = 'es-CL'
    @chile = Stato.find_by_description('Chile')
    SysLocale.where(:key => 'es-CL').destroy_all
  end
end
