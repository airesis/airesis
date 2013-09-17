class UpdatePortugal < ActiveRecord::Migration
  def up
    SysLocale.where(:key => 'pt').first.update_attributes({key: 'pt-PT', lang: 'pt-PT'});
    SysLocale.create(:key => 'pt-BR', :host => 'http://www.airesis.us', lang: 'pt-BR')
    execute "update sys_locales set host = replace(host,'http://','')"
  end

  def down
    SysLocale.where(:key => 'pt-PT').first.update_attributes({key: 'pt', lang: 'pt'})
    SysLocale.where(:key => 'pt-BR').first.destroy
  end
end
