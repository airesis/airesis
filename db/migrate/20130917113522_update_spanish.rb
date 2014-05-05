class UpdateSpanish < ActiveRecord::Migration
  def up
    SysLocale.where(key: 'es').first.update_attributes({key: 'es-ES', lang: 'es-ES'});
  end

  def down
    SysLocale.where(key: 'es-ES').first.update_attributes({key: 'es', lang: 'es'})
  end
end
