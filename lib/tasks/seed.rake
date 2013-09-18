namespace :airesis do
  namespace :seed do

    desc 'Dump all Airesis Seed Data and split them in a good way. Take options from config/seed_dump.yml'
    task :dump => :environment do
      num = 0
      File.open("db/seeds/#{num}_aresis_seed.rb", 'w') do |f|
        f.puts("#encoding: utf-8")
        Continente.all.each do |continente|
          f.puts("a = Continente.create(:description => \"#{continente.description}\")")
          continente.statos.each do |stato|
            f.puts(" s#{stato.id} = Stato.create( :description => \"#{stato.description}\", :continente_id => a.id, sigla: \"#{stato.sigla}\", sigla_ext: \"#{stato.sigla_ext}\")")
            stato.translations.each do |trans|
              f.puts("  s#{stato.id}.translations.where(locale: \"#{trans.locale}\").first_or_create.update_attributes(description: \"#{trans.description}\")")
            end
            stato.regiones.each do |regione|
              f.puts("  r#{regione.id} = Regione.create(:description => \"#{regione.description}\", :stato_id => s#{stato.id}.id)")
              regione.provincias.each do |provincia|
                f.puts("   Provincia.create(:description => \"#{provincia.description}\", :regione_id => r#{regione.id}.id, :sigla => \"#{provincia.sigla}\"){ |c| c.id = #{provincia.id}}.save")
                #provincia.comunes.each do |comune|
                #  f.puts("    Comune.create(:description => \"#{comune.description}\", :provincia_id => p#{provincia.id}.id, :regione_id => r#{regione.id}.id, :population => #{comune.population})")
                #end
              end
            end
          end
        end
      end

      Provincia.all.each do |provincia|
        num += 1
        File.open("db/seeds/#{num}_aresis_seed.rb", 'w') do |f|
          f.puts("#encoding: utf-8")
          provincia.comunes.each do |comune|
            f.puts("Comune.create(:description => \"#{comune.description}\", :provincia_id => #{provincia.id}, :regione_id => #{provincia.regione.id}" + (comune.population ? ", :population => #{comune.population}" : "") + ")")
          end
        end
      end

      num += 1


      File.open("db/seeds/#{num}_aresis_seed.rb", 'w') do |f|
        f.puts("#encoding: utf-8")
        EventType.all.each do |type|
            f.puts(" EventType.create( :description => \"#{type.description}\"){ |c| c.id = #{type.id}}.save")
            f.puts(" et#{type.id} = EventType.find(#{type.id})")
            type.translations.each do |trans|
              f.puts(" et#{type.id}.translations.where(locale: \"#{trans.locale}\").first_or_create.update_attributes(description: \"#{trans.description}\")")
            end
        end
        GroupAction.all.each do |action|
          f.puts(" ga#{action.id} = GroupAction.create(name: \"#{action.name}\", description: \"#{action.description}\", seq: #{action.seq})")
          action.translations.each do |trans|
            f.puts(" ga#{action.id}.translations.where(locale: \"#{trans.locale}\").first_or_create.update_attributes(description: \"#{trans.description}\")")
          end
        end
        GroupPartecipationRequestStatus.all.each do |status|
          f.puts("GroupPartecipationRequestStatus.create( :description => \"#{status.description}\" ){ |c| c.id = #{status.id}}.save")
        end

        NotificationCategory.all.each do |category|
          f.puts("nc#{category.id} = NotificationCategory.create(description: \"#{category.description}\", seq: #{category.seq}, short: \"#{category.short}\")")
          category.translations.each do |trans|
            f.puts(" nc#{category.id}.translations.where(locale: \"#{trans.locale}\").first_or_create.update_attributes(description: \"#{trans.description}\")")
          end
          category.notification_types.each do |type|
            f.puts(" NotificationType.create( :description => \"#{type.description}\", :notification_category_id => nc#{category.id}.id ){ |c| c.id = #{type.id }}.save")
            f.puts(" nt#{type.id} = NotificationType.find(#{type.id})")
            type.translations.each do |trans|
              f.puts(" nt#{type.id}.translations.where(locale: \"#{trans.locale}\").first_or_create.update_attributes({description: \"#{trans.description}\", email_subject: \"#{trans.email_subject}\"})")
            end
          end
        end
        ProposalCategory.all.each do |category|
          f.puts(" pc#{category.id} = ProposalCategory.create(:description => \"#{category.description}\" ){ |c| c.id = #{category.id} }.save")
          f.puts(" pc#{category.id} = ProposalCategory.find(#{category.id})")
          category.translations.each do |trans|
            f.puts(" pc#{category.id}.translations.where(locale: \"#{trans.locale}\").first_or_create.update_attributes(description: \"#{trans.description}\")")
          end
        end
        ProposalState.all.each do |state|
          f.puts("ProposalState.create( :description => \"#{state.description}\" ){ |c| c.id = #{state.id} }.save")
        end
        ProposalType.all.each do |type|
          f.puts("ProposalType.create( :description => \"#{type.description}\", :name => \"#{type.name}\" ){ |c| c.id = #{type.id} }.save")
        end
        RankingType.all.each do |rank|
          f.puts("RankingType.create( :description => \"#{rank.description}\" ){ |c| c.id = #{rank.id} }.save")
        end

        Tutorial.all.each do |tutorial|
          f.puts("tut#{tutorial.id} = Tutorial.create( :action => \"#{tutorial.action}\", :controller => \"#{tutorial.controller}\", :name => \"#{tutorial.name}\", :description => \"#{tutorial.description}\")")
          tutorial.steps.each do |step|
            f.puts("Step.create( :tutorial_id => tut#{tutorial.id}.id, :index => #{step.index}, :title => \"#{step.title}\", :content => \"#{step.content}\", :required => \"#{step.required}\", :fragment => \"#{step.fragment}\")")
          end
        end

        UserType.all.each do |usertype|
          f.puts("UserType.create( description: \"#{usertype.description}\", :short_name => \"#{usertype.short_name}\" ){ |c| c.id = #{usertype.id}}.save")
        end

        Quorum.public.each do |quorum|
          f.puts("Quorum.create(name: \"#{quorum.name}\", percentage: #{quorum.percentage || 'nil'}, minutes: #{quorum.minutes || 'nil'}, condition: \"#{quorum.condition || 'nil'}\", good_score: #{quorum.good_score || 'nil'}, bad_score: #{quorum.bad_score || 'nil'}, public: true, seq: #{quorum.seq || 'nil'})")
        end

        f.puts("PartecipationRole.create(:name => \"amministratore\", :description => \"Amministratore\"){ |c| c.id = 2 }.save")

        VoteType.all.each do |votetype|
          f.puts("VoteType.create( :description => \"#{votetype.description}\"){ |c| c.id = #{votetype.id} }.save")
        end

        Configuration.all.each do |configuration|
          f.puts("Configuration.create(name: \"#{configuration.name}\", value: 1)")
        end
      end


    end
  end
end