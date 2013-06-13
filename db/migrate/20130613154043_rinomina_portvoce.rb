class RinominaPortvoce < ActiveRecord::Migration
  def up
    PartecipationRole.find(2).update_attributes({name: 'amministratore', description: 'Amministratore'})
  end

  def down
    PartecipationRole.find(2).update_attributes({name: 'portavoce', description: 'Portavoce'})
  end
end
