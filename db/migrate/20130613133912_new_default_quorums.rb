#encoding: utf-8
class NewDefaultQuorums < ActiveRecord::Migration
  def up
    add_column :groups, :admin_title, :string, limit: 200 #add a column for a custom admin title

    add_column :quorums, :seq, :integer

    a = Quorum.create(name: '1 giorno', description: 'Un quorum adatto a proposte molto veloci che devono essere votate il giorno successivo', minutes: 1440, condition: 'AND', bad_score: 50, good_score: 50, active: true, public: true, seq: 1)
    b = Quorum.create(name: '3 giorni', description: 'Un dibattito di pochi giorni', minutes: 4320, condition: 'AND', bad_score: 50, good_score: 50, active: true, public: true, seq: 2 )
    c = Quorum.create(name: '7 giorni', description: 'Una proposta da discutere per una settimana', minutes: 10080, condition: 'AND', bad_score: 50, good_score: 50, active: true, public: true, seq: 3 )
    d = Quorum.create(name: '15 giorni', description: 'Un quorum più lungo per una proposta più complessa', minutes: 21600, condition: 'AND', bad_score: 50, good_score: 50, active: true, public: true, seq: 4 )
    e = Quorum.create(name: '30 giorni', description: 'Un quorum molto lungo per discussioni elaborate su proposte molto complesse', minutes: 43200, condition: 'AND', bad_score: 50, good_score: 50, active: true, public: true, seq: 5 )

    Quorum.update_all({name: 'Veloce', description: 'Una discussione di due giorni dove vi è anche un numero minimo di partecipanti', seq: 6},{name: 'fast'})
    Quorum.update_all({name: 'Normale', description: '15 giorni di discussione e un numero minimo di partecipanti', seq: 7},{name: 'standard'})
    Quorum.update_all({name: 'Lunga', description: 'Una discussione davvero lunga, che durerà due mesi e richiederà la partecipazione di almeno il 50% degli aventi diritto', seq: 8},{name: 'long'})
    Quorum.update_all({name: 'Buon punteggio', description: '15 giorni di discussione ma il gradimento deve superare il 70%', seq: 9},{name: 'good_score'})

    Group.all.each do |group|
      [a,b,c,d,e].each do |quorum|
        copy = quorum.dup
        copy.public = false
        copy.active = true
        copy.save!
        group.group_quorums.create(:quorum_id => copy.id)
      end
    end

  end

  def down
    remove_column :groups, :admin_title
    remove_column :quorums, :seq
    Quorum.destroy_all({name: '1 giorno', valutations: nil, ends_at: nil})
    Quorum.destroy_all({name: '3 giorni', valutations: nil, ends_at: nil})
    Quorum.destroy_all({name: '7 giorni', valutations: nil, ends_at: nil})
    Quorum.destroy_all({name: '15 giorni', valutations: nil, ends_at: nil})
    Quorum.destroy_all({name: '30 giorni', valutations: nil, ends_at: nil})
    Quorum.update_all({name: 'fast', description: nil},{name: 'Veloce'})
    Quorum.update_all({name: 'standard', description: nil}, {name: 'Normale'})
    Quorum.update_all({name: 'long', description: nil}, {name: 'long'})
    Quorum.update_all({name: 'good_score', description: nil},{name: 'good_score'})

  end
end
