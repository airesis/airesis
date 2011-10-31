#encoding: utf-8
class AdminController < ApplicationController
  
  before_filter :admin_required#, :only => [:new, :create, :destroy]

  def index
   
  end
  
  def show        
   
  end
  
  #calcola il ranking degli utenti
  def calculate_ranking
    
    @users = User.find(:all)
    @users.each do |user|
      
    numcommenti = user.proposal_comments.count
    numproposte = user.proposals.find(:all, :conditions => ["proposal_state_id in (?)",[1,2,3,4]]).count
    numok = user.proposals.find_all_by_proposal_state_id(6).count
    puts "commenti:"+numcommenti.to_s + " proposte:" + numproposte.to_s + " ok:" + numok.to_s
    user.rank = numcommenti + 2*(numproposte) + 10*(numok)
    user.save
    end  
    
    
    respond_to do |format|
      format.html {
        flash[:notice] = 'Ranking ricalcolato per '+ @users.count.to_s+' utenti'
        redirect_to admin_panel_path
      }
    end
  end
  
  #cambia lo stato delle proposte
  def change_proposals_state
    counter = 0
    denied = 0
    accepted = 0
    #scorri le proposte in votazione che devono essere chiuse
    voting = Proposal.find(:all, :joins => [:vote_period], :conditions => ['proposal_state_id = 4 and current_timestamp > events.endtime'], :readonly => false)
    
    voting.each do |proposal| #per ciascuna proposta da chiudere
      vote_data = proposal.vote 
      if (!vote_data) #se non ha i dati per la votazione creali
       vote_data = ProposalVote.new(:proposal_id => proposal.id, :positive => 0, :negative => 0, :neutral => 0)
       vote_data.save
      end
      positive = vote_data.positive
      negative = vote_data.negative
      neutral = vote_data.neutral
      votes = positive + negative + neutral
      if (positive > negative)  #se ha avuto più voti positivi allora diventa ACCETTATA
        proposal.proposal_state_id = PROP_ACCEPT
        accepted+=1
      elsif (positive <= negative)  #se ne ha di puù negativi allora diventa RESPINTA
        proposal.proposal_state_id = PROP_RESP
        denied+=1
      end  
     
      proposal.save
    
    end if voting
        
    #prendo tutte le proposte che ad oggi devono essere votate e le passo in stato IN VOTAZIONE
    events = Event.find(:all, :conditions => ['event_type_id = 2 and current_timestamp between starttime and endtime and proposals.proposal_state_id = 3'], :include => [:proposals])
    
    events.each do |event|
      event.proposals.each do |proposal|
        proposal.proposal_state_id = PROP_VOTING
        counter+=1
        proposal.save
        vote_data = proposal.vote 
        if (!vote_data) #se non avesse i dati per la votazione creali
          vote_data = ProposalVote.new(:proposal_id => proposal.id, :positive => 0, :negative => 0, :neutral => 0)
          vote_data.save
        end        
      end
    end if events
    
    respond_to do |format|
      format.html {        
        flash[:notice] = denied.to_s + ' proposte sono state RESPINTE, ' + accepted.to_s + ' proposte sono state ACCETTATE, ' + counter.to_s + ' proposte sono passate in VOTAZIONE'
        redirect_to admin_panel_path
      }
    end
  end
  
end
