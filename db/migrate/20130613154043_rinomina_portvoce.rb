class RinominaPortvoce < ActiveRecord::Migration
  def up
    ParticipationRole.find(2).update_attributes({name: 'amministratore', description: 'Amministratore'})
  end

  def down
    ParticipationRole.find(2).update_attributes({name: 'portavoce', description: 'Portavoce'})
  end
end
