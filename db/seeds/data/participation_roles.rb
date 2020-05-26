ParticipationRole.create(Hash[GroupAction::LIST.map { |a| [a, true] }]
                             .merge(name: ParticipationRole::ADMINISTRATOR, description: 'Amministratore'))
