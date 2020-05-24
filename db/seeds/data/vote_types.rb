VoteType.create(short: 'favorable') { |c| c.id = 1 }.save
VoteType.create(short: 'neutral') { |c| c.id = 2 }.save
VoteType.create(short: 'dissenting') { |c| c.id = 3 }.save
