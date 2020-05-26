ProposalState.create(description: 'in valutazione') { |c| c.id = 1 }.save
ProposalState.create(description: 'in attesa di data') { |c| c.id = 2 }.save
ProposalState.create(description: 'in attesa') { |c| c.id = 3 }.save
ProposalState.create(description: 'in votazione') { |c| c.id = 4 }.save
ProposalState.create(description: 'respinta') { |c| c.id = 5 }.save
ProposalState.create(description: 'accettata') { |c| c.id = 6 }.save
ProposalState.create(description: 'revisione e feedback') { |c| c.id = 7 }.save
ProposalState.create(description: 'abbandonata') { |c| c.id = 8 }.save
