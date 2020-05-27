module Admin
  class PanelController < Admin::ApplicationController
    include ManagerActions

    # calculate user rating
    def calculate_rankings
      AdminHelper.calculate_ranking
      flash[:notice] = 'OK'
      redirect_to admin_panel_path
    end

    # change proposal states
    def change_proposals_state
      # check all proposals in debate and expired and close the debate
      Proposal.invalid_debate_phase.each(&:check_phase)

      # check all proposals waiting and put them in votation
      Proposal.invalid_waiting_phase.each do |proposal|
        EventsWorker.new.start_votation(proposal.vote_period.id)
      end

      # check all proposals in votation that has to be closed but are still in votation and the period has passed
      Proposal.invalid_vote_phase.each(&:close_vote_phase)

      flash[:notice] = 'Stato proposte aggiornato'
      redirect_to admin_panel_path
    end

    def calculate_user_group_affinity
      AffinityHelper.calculate_user_group_affinity
      flash[:notice] = 'Affinità calcolate'
      redirect_to admin_panel_path
    end

    def delete_old_notifications
      deleted = AdminHelper.delete_old_notifications
      flash[:notice] = 'Notifiche eliminate: ' + deleted.to_s
      redirect_to admin_panel_path
    end

    # invia una mail di prova tramite resque e redis
    def test_redis
      ResqueMailer.delay.test_mail
      flash[:notice] = 'Test avviato'
      redirect_to admin_panel_path
    end

    # invia una notifica di prova tramite resque e redis
    def test_notification
      if params[:alert_id].to_s != ''
        ResqueMailer.delay.notification(params[:alert_id])
      else
        NotificationType.all.each do |type|
          notification = type.notifications.order('created_at desc').first
          alert = notification.alerts.first if notification
          ResqueMailer.delay.notification(alert.id) if alert
        end
      end
      flash[:notice] = 'Test avviato'
      redirect_to admin_panel_path
    end

    def test_exceptions
      raise StandardError, 'Test this exception!'
    end

    # esegue un job di prova tramite resque_scheduler
    def test_scheduler
      ProposalsWorker.perform_at(15.seconds.from_now, proposal_id: 1)
      flash[:notice] = 'Test avviato'
      redirect_to admin_panel_path
    rescue Exception => e
      puts e.backtrace
    end

    def write_sitemap
      Rake::Task['sitemap:refresh'].invoke
      flash[:notice] = 'Sitemap aggiornata.'
      redirect_to admin_panel_path
    end

    def proposals_stats
      ret = Proposal.voted.
            joins(:solutions).
            group('proposals.id').
            having('count(solutions.*) > 1').count.map do |proposal_id, count|
        proposal = Proposal.find(proposal_id)
        { proposal_id: proposal_id,
          solutions_count: count,
          votes_count: proposal.user_votes_count,
          solutions: proposal.solutions.map(&:id).join(','),
          preferences: proposal.schulze_votes.map { |vote| { count: vote.count, data: vote.preferences } } }
      end
      File.open('stat.json', 'w') { |f| f.puts JSON.pretty_generate(ret) }
    end
  end
end
