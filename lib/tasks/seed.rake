namespace :airesis do
  namespace :seed do

    desc 'Dump all Airesis Seed Data and split them in a good way.'
    task dump: :environment do
      def filename(num)
        "db/new_seeds/#{num}_airesis_seed.rb"
      end

      num = 0
      File.open(filename(num), 'w') do |f|
        f.puts("#encoding: utf-8")
        Continente.all.each do |continente|
          f.puts("a#{continente.id} = Continente.create(description: \"#{continente.description}\")")
          continente.translations.each do |trans|
            f.puts("  a#{continente.id}.translations.where(locale: \"#{trans.locale}\").first_or_create.update_attributes(description: \"#{trans.description}\")")
          end
          continente.statos.each do |stato|
            f.puts(" s#{stato.id} = Stato.create( description: \"#{stato.description}\", continente_id: a#{continente.id}.id, sigla: \"#{stato.sigla}\", sigla_ext: \"#{stato.sigla_ext}\")")
            stato.translations.each do |trans|
              f.puts("  s#{stato.id}.translations.where(locale: \"#{trans.locale}\").first_or_create.update_attributes(description: \"#{trans.description}\")")
            end
            stato.regiones.each do |regione|
              f.puts("  r#{regione.id} = Regione.create(description: \"#{regione.description}\", stato_id: s#{stato.id}.id, continente_id: a#{continente.id}.id)")
              regione.provincias.each do |provincia|
                f.puts("   Provincia.create(description: \"#{provincia.description}\", regione_id: r#{regione.id}.id, stato_id: s#{stato.id}.id, continente_id: a#{continente.id}.id, sigla: \"#{provincia.sigla}\"){ |c| c.id = #{provincia.id}}.save")
              end
            end
          end
        end
      end

      Provincia.all.each do |provincia|
        num += 1
        File.open(filename(num), 'w') do |f|
          f.puts("#encoding: utf-8")
          provincia.comunes.each do |comune|
            f.puts("Comune.create(description: \"#{comune.description}\", provincia_id: #{provincia.id}, regione_id: #{provincia.regione.id}, stato_id: #{provincia.stato.id}, continente_id: #{provincia.continente.id} " + (comune.population ? ", population: #{comune.population}" : "") + ")")
          end
        end
      end

      num += 1


      File.open(filename(num), 'w') do |f|
        f.puts("#encoding: utf-8")
        EventType.active.all.each do |type|
            f.puts(" EventType.create( name: \"#{type.name}\", color: \"#{type.color}\"){ |c| c.id = #{type.id}}.save")
        end
        GroupAction.all.each do |action|
          f.puts("GroupAction.create(name: \"#{action.name}\")")
        end
        GroupParticipationRequestStatus.all.each do |status|
          f.puts("GroupParticipationRequestStatus.create( description: \"#{status.description}\" ){ |c| c.id = #{status.id}}.save")
        end

        NotificationCategory.all.each do |category|
          f.puts("nc#{category.id} = NotificationCategory.create(seq: #{category.seq}, short: \"#{category.short}\")")

          category.notification_types.each do |type|
            f.puts("NotificationType.create( name: \"#{type.name}\", notification_category_id: nc#{category.id}.id ){ |c| c.id = #{type.id }}.save")
          end
        end
        ProposalCategory.all.each do |category|
          f.puts("ProposalCategory.create(name: \"#{category.name}\", seq: #{category.seq} ){ |c| c.id = #{category.id} }.save")
        end
        ProposalState.all.each do |state|
          f.puts("ProposalState.create( description: \"#{state.description}\" ){ |c| c.id = #{state.id} }.save")
        end
        ProposalType.all.each do |type|
          f.puts("ProposalType.create( active: \"#{type.active}\", name: \"#{type.name}\", color: \"#{type.color}\" ){ |c| c.id = #{type.id} }.save")
        end
        RankingType.all.each do |rank|
          f.puts("RankingType.create( description: \"#{rank.description}\" ){ |c| c.id = #{rank.id} }.save")
        end

        Tutorial.all.each do |tutorial|
          f.puts("tut#{tutorial.id} = Tutorial.create( action: \"#{tutorial.action}\", controller: \"#{tutorial.controller}\", name: \"#{tutorial.name}\")")
          tutorial.steps.each do |step|
            f.puts("Step.create( tutorial_id: tut#{tutorial.id}.id, index: #{step.index}, title: \"#{step.title}\", content: \"#{step.content}\", required: \"#{step.required}\", fragment: \"#{step.fragment}\", format: \"#{step.format}\")")
          end
        end

        UserType.all.each do |usertype|
          f.puts("UserType.create( description: \"#{usertype.description}\", short_name: \"#{usertype.short_name}\" ){ |c| c.id = #{usertype.id}}.save")
        end

        Quorum.visible.each do |quorum|
          f.puts("Quorum.create(name: \"#{quorum.name}\", percentage: #{quorum.percentage || 'nil'}, minutes: #{quorum.minutes || 'nil'}, good_score: #{quorum.good_score || 'nil'}, bad_score: #{quorum.bad_score || 'nil'}, vote_percentage: #{quorum.vote_percentage || 'nil'}, vote_minutes: #{quorum.vote_minutes || 'nil'}, vote_good_score: #{quorum.vote_good_score || 'nil'}, t_percentage: \"#{quorum.t_percentage}\", t_minutes: \"#{quorum.t_minutes}\", t_good_score: \"#{quorum.t_good_score}\", t_vote_percentage: \"#{quorum.t_vote_percentage}\", t_vote_minutes: \"#{quorum.t_vote_minutes}\", t_vote_good_score: \"#{quorum.t_vote_good_score}\", public: true, seq: #{quorum.seq || 'nil'})")
        end

        f.puts("ParticipationRole.create(name: \"amministratore\", description: \"Amministratore\"){ |c| c.id = 2 }.save")

        VoteType.all.each do |votetype|
          f.puts("VoteType.create( short: \"#{votetype.short}\"){ |c| c.id = #{votetype.id} }.save")
        end

        ProposalVotationType.all.each do |votetype|
          f.puts("ProposalVotationType.create( short_name: \"#{votetype.short_name}\", description: \"#{votetype.description}\"){ |c| c.id = #{votetype.id} }.save")
        end

        Configuration.all.each do |configuration|
          f.puts("Configuration.create(name: \"#{configuration.name}\", value: 1)")
        end

        SysCurrency.all.each do |currency|
          f.puts("SysCurrency.create(description: \"#{currency.description}\")")
        end

        SysLocale.all.each do |locale|
          f.puts("SysLocale.create(key: \"#{locale.key}\", host: \"#{locale.host}\", territory_type: \"#{locale.territory_type}\", territory_id: \"#{locale.territory_id}\"" + (locale.lang ? ", lang: \"#{locale.lang}\"" : "") +")")
        end

        SysMovementType.all.each do |currency|
          f.puts("SysMovementType.create(description: \"#{currency.description}\")")
        end


        #f.puts("@u = User.create(user_type_id: 1, name: 'Administrator', surname: 'Admin', email: \"#{APP_EMAIL_ADDRESS}\", login: 'admin', confirmed_at: Time.now)")

      end
    end
  end
end
