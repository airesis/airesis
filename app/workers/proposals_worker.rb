class ProposalsWorker
  include Sidekiq::Worker, Rails.application.routes.url_helpers, GroupsHelper, ProposalsHelper
  sidekiq_options queue: :high_priority

  ENDTIME = 'endtime'
  LEFT24 = 'left24'
  LEFT1 = 'left1'
  LEFT24VOTE = 'left24_vote'
  LEFT1VOTE = 'left1_vote'

  def perform(*args)
    params = args[0]
    proposal = Proposal.lock.find(params['proposal_id'])
    case params['action']
    when ENDTIME
      # fa terminare la fase di valutazione di una proposta
      proposal.check_phase
    when LEFT24
      # invia una notifica a tutti i partecipanti alla proposta
      # che non hanno dato la loro valutazione o possono cambiarla
      # 24 ore prima della chiusura del dibattito
      NotificationProposalTimeLeft.perform_async(proposal.id, '24_hours')
    when LEFT1
      # invia una notifica a tutti i partecipanti alla proposta
      # che non hanno dato la loro valutazione o possono cambiarla
      # 1 ora prima della chiusura del dibattito
      NotificationProposalTimeLeft.perform_async(proposal.id, '1_hour')
    when LEFT24VOTE
      # send a notification to all participants that can vote the proposal and haven't voted it yet
      # 24 ore prima della chiusura del dibattito
      NotificationProposalTimeLeftVote.perform_async(proposal.id, '24_hours_vote')
    when LEFT1VOTE
      # send a notification to all participants that can vote the proposal and haven't voted it yet
      # 1 ora prima della chiusura del dibattito
      NotificationProposalTimeLeftVote.perform_async(proposal.id, '1_hour_vote')
    else
      puts '==Action not found!=='
    end
  rescue ActiveRecord::RecordNotFound
    logger.warn "can't find proposal #{params['proposal_id']}. Has it been deleted?"
  end
end
