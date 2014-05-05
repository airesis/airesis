#encoding: utf-8
class ElectionsController < ApplicationController
  require 'vote-schulze'
  
  layout "groups"

  #l'utente deve aver fatto login
  before_filter :admin_required
  before_filter :authenticate_user!, except: [:index]

    
  before_filter :load_election, except: [:index,:new,:create]
  before_filter :check_vote, only: [:vote_page, :show]
  
  before_filter :load_group
  
  #load_and_authorize_resource 
  
  def show
    authorize! :read, @election
    @group = @election.groups.first
    @page_title = @election.event.title
    #se l'elezione è terminata e non ho ancora calcolato i risultati, fallo ora.
    if (@election.event.is_past? && (@election.score_calculated == false))
      Election.transaction do
        if (@election.candidates.count > 0)
          votesstring = ""; #stringa da passare alla libreria schulze_vote per calcolare il punteggio
          @election.schulze_votes.each do |vote|
            #in ogni riga inserisco la mappa del voto ed eventualmente il numero se più di un utente ha espresso la stessa preferenza
            if (vote.count > 1)
              votesstring += "#{vote.count}=#{vote.preferences}\n"
            else
              votesstring += "#{vote.preferences}\n"
            end
          end #fine ciclo voti
          #calcolo il risultato
          num_candidates = @election.candidates.count
          vs = SchulzeBasic.do votesstring, num_candidates 
          #ordino i candidati secondo l'id crescente (così come vengono restituiti dalla libreria)
          candidates_sorted = @election.candidates.sort{|a,b| a.id <=> b.id}          
          candidates_sorted.each_with_index do |c,i|
            c.score = vs.ranks[i].to_i
            c.save!
          end
        end
        @election.score_calculated = true
        @election.save!
      end #fine transazione    
    end         
  end

  #calcola il risultato dell'elezione
  def calculate_results
    raise Exception if @election.candidates.count == 0
    votesstring = ""; #stringa da passare alla libreria schulze_vote per calcolare il punteggio
    @election.schulze_votes.each do |vote|
      #in ogni riga inserisco la mappa del voto ed eventualmente il numero se più di un utente ha espresso la stessa preferenza
      if (vote.count > 1)
        votesstring += "#{vote.count}=#{vote.preferences}\n"
      else
        votesstring += "#{vote.preferences}\n"
      end
    end
    
    #calcolo il risultato
    vs = SchulzeBasic.do votesstring, @election.candidates.count
    #ordino i candidati secondo l'id crescente (così come vengono restituiti dalla libreria)
    candidates_sorted = @election.candidates.sort{|a,b| a.id <=> b.id}
    message  ="" #messaggio da mostrare
    candidates_sorted.each_with_index do |c,i|
      message += "#{c.user.fullname} (#{c.id}) ha ottenuto un punteggio di #{vs.ranks[i]} \n "
    end
    respond_to do |format|
        flash[:warn] = message
        format.html { render action: "show" }
        format.js {
          render :update do |page|
            page.replace_html "flash_messages", partial: 'layouts/flash', locals: {flash: flash}
          end 
        }   
     end
  end

  
  protected
  def load_election
    @election = Election.find_by_id(params[:id], include: :event)
  end
  
  def check_vote
    @has_voted = (@election.voters.include? current_user)        
  end

end
