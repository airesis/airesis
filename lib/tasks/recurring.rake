namespace :airesis do
  namespace :recurring do
    desc 'Calculates group statistics. Usually scheduled once a day at 01:00'
    task groups_statistics: :environment do
      CalculateGroupStatistics.new.perform
    end

    desc 'Calculate users rankings. Usually scheduled once a day at 02:00'
    task users_ranking: :environment do
      CalculateRankings.new.perform
    end

    desc 'Calculates proposals statistics. Usually scheduled once a day at 03:00'
    task proposals_statistics: :environment do
      CountCreatedProposals.new.perform
    end

    desc 'Deletes very old notifications. Usually scheduled once a day at 04:00'
    task delete_old_notifications: :environment do
      DeleteOldNotifications.new.perform
    end

    desc 'Reads received email and creates content in forums and other parts of the application.
          Usually scheduled every minute, requires mailman running'
    task elaborate_emails: :environment do
      ElaborateEmails.new.perform
    end

    desc 'Fix proposals in a wrong status. Usually scheduled every hour.'
    task fix_proposals: :environment do
      FixProposals.new.perform
    end

    desc 'Fix notification workers in a wrong status. Usually scheduled every hour.'
    task fix_workers: :environment do
      FixWorkers.new.perform
    end
  end
end
