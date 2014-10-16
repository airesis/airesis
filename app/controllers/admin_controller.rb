#encoding: utf-8

require 'rake'

class AdminController < ManagerController
  include GroupsHelper, NotificationHelper, ProposalsHelper

  before_filter :admin_required

  layout 'users'

  def index

  end

  def show

  end

  #test airesis metis gem
  def test_gem
    AiresisMetis.hi
    flash[:notice] = 'OK'
    redirect_to admin_panel_path
  end

  #calculate user rating
  def calculate_ranking
    AdminHelper.calculate_ranking
    flash[:notice] = 'OK'
    redirect_to admin_panel_path
  end

  #change proposal states
  def change_proposals_state
    #check all proposals in debate and tim expired and close the debate
    Proposal.invalid_debate_phase.each do |proposal| #per ciascuna proposta il cui tempo di valutazione è terminato
      proposal.check_phase
    end

    #check all proposals waiting and put them in votation
    Proposal.invalid_waiting_phase.each do |proposal| #per ciascuna proposta da chiudere
      EventsWorker.new.start_votation(proposal.vote_period.id)
    end

    #check all proposals in votation that has to be closed but are still in votation and the period has passed
    Proposal.invalid_vote_phase.each do |proposal| #per ciascuna proposta da chiudere
      proposal.close_vote_phase
    end

    flash[:notice] = 'Stato proposte aggiornato'
    redirect_to admin_panel_path
  end

  def validate_groups
    AdminHelper.validate_groups
    flash[:notice] = 'Inviato elenco gruppi non validi'
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

  #invia una mail di prova tramite resque e redis
  def test_redis
    ResqueMailer.delay.test_mail
    flash[:notice] = 'Test avviato'
    redirect_to admin_panel_path
  end

  #invia una notifica di prova tramite resque e redis
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
    raise Exception.new("Test this exception!")
  end

  #esegue un job di prova tramite resque_scheduler
  def test_scheduler
    ProposalsWorker.perform_at(15.seconds.from_now, proposal_id: 1)
    flash[:notice] = 'Test avviato'
    redirect_to admin_panel_path
  rescue Exception => e
    puts e.backtrace
  end

  def become
    sign_in User.find(params[:user_id]), bypass: true
    redirect_to root_url # or user_root_url
  end

  def write_sitemap
    Rake::Task["sitemap:refresh"].invoke
    flash[:notice] = 'Sitemap aggiornata.'
    redirect_to admin_panel_path
  end

  def mailing_list

  end

  def send_newsletter
    NewsletterSender.perform_at(30.seconds.from_now, params)
    flash[:notice] = "Newsletter pubblicata correttamente"
    redirect_to controller: 'admin', action: 'mailing_list'
  end

  def upload_sources
    Crowdin::Client.new.upload_sources
    flash[:notice] = 'Sources uploaded'
    redirect_to admin_panel_path
  end

  def update_sources
    Crowdin::Client.new.update_sources
    flash[:notice] = 'Sources updated'
    redirect_to admin_panel_path
  end

  def upload_translations
    Crowdin::Client.new.upload_translations
    flash[:notice] = 'Translation uploaded'
    redirect_to admin_panel_path
  end

  def download_translations
    Crowdin::Client.new.download_translations
    flash[:notice] = 'Translations downloaded'
    redirect_to admin_panel_path
  end

  def extract_delete_zip
    Crowdin::Client.new.extract_zip
    flash[:notice] = 'Translations unzipped and zip deleted'
    redirect_to admin_panel_path
  end

  def proposals_stats
    ret = []
    Proposal.voted.joins(:solutions).group('proposals.id').having('count(solutions.*) > 1').count.map do |proposal_id, count|
      proposal = Proposal.find(proposal_id)
      phash = {proposal_id: proposal_id, solutions_count: count, votes_count: proposal.user_votes.count, solutions: proposal.solutions.map { |s| s.id }.join(',')}
      votes = []
      proposal.schulze_votes.each do |vote|
        votes << {count: vote.count, data: vote.preferences}
      end
      phash[:preferences] = votes
      ret << phash
    end
    File.open('stat.json', 'w') do |f|
      f.puts JSON.pretty_generate(ret)
    end
  end
end
