namespace :airesis do
  namespace :seed_i18n do

    desc 'Dump all Airesis DB I18N Data and split them in a good way.'
    task :dump => :environment do
      locales = ['it', 'en', 'pt', 'de', 'es', 'fr']
      classes = [EventType, GroupAction, NotificationCategory, NotificationType, ProposalCategory, VoteType]
      locales.each do |locale|
        File.open("config/locales/database.#{locale}.yml", 'w') do |f|
          f.puts("#{locale}:")
          f.puts("  db:")
          classes.each do |classe|
            f.puts("    #{classe.class_name.tableize}:")
            classe.all.each do |oggetto|
              f.puts("      #{(oggetto.respond_to? :name) ? oggetto.name : oggetto.short}:")
              oggetto.translations.where(:locale => locale).all.each do |trans|
                f.puts("        description: #{trans.description}")
                if oggetto.respond_to? :email_subject
                  f.puts("        email_subject: #{trans.email_subject}")
                end
              end

            end
          end
        end
      end
    end
  end
end