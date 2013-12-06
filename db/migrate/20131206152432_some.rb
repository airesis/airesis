class Some < ActiveRecord::Migration
  def up
    Frm::Forum.where(:description => 'Forum aperto a tutti i partecipanti di Airesis. Anche a coloro che non appartengono al gruppo').update_all(:description => 'Forum visualizzabile da tutti i partecipanti di Airesis. Anche a coloro che non appartengono al gruppo')
  end

  def down
    Frm::Forum.where(:description => 'Forum visualizzabile da tutti i partecipanti di Airesis. Anche a coloro che non appartengono al gruppo').update_all(:description => 'Forum aperto a tutti i partecipanti di Airesis. Anche a coloro che non appartengono al gruppo')
  end
end
