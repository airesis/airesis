class ProposalsWorker
  include Sidekiq::Worker, ProposalsModule, NotificationHelper, Rails.application.routes.url_helpers
  sidekiq_options :queue => :high_priority

  ENDTIME='endtime'
  LEFT24='left24'
  LEFT1='left1'
  LEFT24VOTE='left24_vote'
  LEFT1VOTE='left1_vote'

  def perform(*args)
    params = args[0]
    @proposal = Proposal.find(params['proposal_id'])
    case params['action']
      when ENDTIME
        #fa terminare la fase di valutazione di una proposta
        check_phase(@proposal)
      when LEFT24
        #invia una notifica a tutti i partecipanti alla proposta
        # che non hanno dato la loro valutazione o possono cambiarla
        # 24 ore prima della chiusura del dibattito
        notify_24_hours_left(@proposal)
      when LEFT1
        #invia una notifica a tutti i partecipanti alla proposta
        # che non hanno dato la loro valutazione o possono cambiarla
        # 1 ora prima della chiusura del dibattito
        notify_1_hour_left(@proposal)
      when LEFT24VOTE
        #send a notification to all partecipants that can vote the proposal and haven't voted it yet
        # 24 ore prima della chiusura del dibattito
        notify_24_hours_left_to_vote(@proposal)
      when LEFT1VOTE
        #send a notification to all partecipants that can vote the proposal and haven't voted it yet
        # 1 ora prima della chiusura del dibattito
        notify_1_hour_left_to_vote(@proposal)
      else
        puts "==Action not found!=="
    end
  rescue ActiveRecord::RecordNotFound => e
    logger.warn "can't find proposal #{params['proposal_id']}. Has it been deleted?"
  end
end
