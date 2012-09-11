#encoding: utf-8
class ElectionsController < ApplicationController
  require 'vote-schulze'
  
  layout "groups"
  
  #rescue_from Exception, :with => :exception_occurred
  
  #l'utente deve aver fatto login
  before_filter :authenticate_user!, :except => [:index]
  
  before_filter :check_group, :only => [:new, :create, :edit, :update]
    
  before_filter :load_election, :except => [:index,:new,:create]
  before_filter :check_vote, :only => [:vote_page, :show]
  
  before_filter :load_group
  
  #load_and_authorize_resource 
  
  def show
    @group = @election.groups.first
    @page_title = "Elezione"
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
          vs = SchulzeBasic.do votesstring, @election.candidates.count
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
  
  def edit
    
  end
    
  def vote_page
    respond_to do |format|
      flash[:error] = "Hai già votato a questa elezione."
      format.html {
        redirect_to @election
      }
    end if (@has_voted)
  end
  
  #un utente invia il voto per l'elezione
  def vote
    begin
      votes = (JSON.parse params[:data][:votes])
      votes = votes['candidates']
      votestring = ""
  
      votes.sort! {|a,b| b[1] <=> a[1] }    
      
      votes.each_with_index do |vote,index|
        if (index != 0)  
          if (vote[1].to_i == votes[index-1][1].to_i)
            votestring += ","
           else
             votestring += ";"
          end
        end
        votestring += vote[0]
     end
     
   ElectionVote.transaction do
     votes.each do |vote|
        #controlla che gli id di tutti i candidati indicati siano effettivamente partecipanti all'elezione
        raise Exception unless @election.candidates.include? Candidate.find_by_id(vote[0])    
     end
     #salva la votazione dell'utente
     schulz = @election.schulze_votes.find_or_create_by_preferences(votestring)
     schulz.count += 1

    #memorizza che l'utente ha effettuato la votazione
    @election.voters << current_user
    @election.save!    
   end
   respond_to do |format|
      flash[:notice] = "Voto inviato correttamente!"
      format.html { render :action => "show" }              
      format.js {
        render :update do |page|
          page.replace_html "flash_messages", :partial => 'layouts/flash', :locals => {:flash => flash}
        end 
      }  
    end    
   
   rescue Exception => e
      respond_to do |format|
        #magari ha provato a votare due volte!
        flash[:error] = "Errore durante l'inserimento del tuo voto. Spiacenti."
        format.html { render :action => "vote_page" }               
        format.js {
          render :update do |page|
            page.replace_html "flash_messages", :partial => 'layouts/flash', :locals => {:flash => flash}
          end 
        }   
      end        
   end   
  end
     
  def new
     @election = Election.new
     @events = Event.all
     respond_to do |format|
       format.html # new.html.erb
      end
  end
  
  def create
    begin
      Election.transaction do
          @group.elections.build(params[:election])
          @group.save!
      end
      
      respond_to do |format|
          flash[:notice] = "Hai creato il l'elezione"
          format.html { redirect_to(@group) }
      end 
      
    rescue ActiveRecord::ActiveRecordError => e
      respond_to do |format|
        flash[:error] = "Errore nella creazione dell'elezione."
        format.html { render :action => "new" }                
      end        
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
        format.html { render :action => "show" }                
        format.js {
          render :update do |page|
            page.replace_html "flash_messages", :partial => 'layouts/flash', :locals => {:flash => flash}
          end 
        }   
     end  
    #puts vs.ranks
    #puts vs.ranks_abc
    
  end
  
  
  #un semplice test  
  def test_schulze
    puts "Hello everybody. I'm running"
    #vs = SchulzeBasic.do File.open("test/votes/vote4.list")
    #puts vs.ranks
    #puts vs.ranks_abc
    
    
    @test_string = "3=a;c;d;b\n9=b;a;c;d\n8=c;d;a;b\n5=d;a;b;c\n5=d;b;c;a"  
    
    vs = SchulzeBasic.do @test_string, 4
    puts vs.ranks
    puts vs.ranks_abc
    
    puts "and with numbers?"
    
    @test_string2 = "3=1;3;4;2\n9=2;1;3;4\n8=3;4;1;2\n5=4;1;2;3\n5=4;2;3;1"  
    
    vs = SchulzeBasic.do @test_string, 4
    puts vs.ranks
    puts vs.ranks_abc
    
    puts "and with random numbers?"
    
    @test_string2 = "3=10;3;4;7\n9=7;10;3;4\n8=3;4;10;7\n5=4;10;7;3\n5=4;7;3;10"  
    
    vs = SchulzeBasic.do @test_string, 4
    puts vs.ranks
    puts vs.ranks_abc
    
  end
  
  
  
  protected
  
  def check_group
    @group = Group.find_by_id(params[:group_id])
    if !@group
      flash[:error] = "Solo i gruppi possono eseguire questa azione"
      respond_to do |format|
        #format.js { render :update do |page|
        #    page.replace_html "flash_messages", :partial => 'layouts/flash', :locals => {:flash => flash}
        #    page.replace_html "rankingpanelcontainer", :partial => 'proposals/ranking_panel', :locals => {:flash => flash}          
        #  end                  
        #}
        format.html {
          redirect_to groups_path
        }
      end 
    end
    
    if !(can? :create_election, @group)
      flash[:error] = "Non puoi creare elezioni per questo gruppo"
      respond_to do |format|
        #format.js { render :update do |page|
        #    page.replace_html "flash_messages", :partial => 'layouts/flash', :locals => {:flash => flash}
        #    page.replace_html "rankingpanelcontainer", :partial => 'proposals/ranking_panel', :locals => {:flash => flash}          
        #  end                  
        #}
        format.html {
          redirect_to @group
        }
      end 
    end
  end
  
  def load_group
    @group = Group.find_by_id(params[:group_id])
  end
  
  def load_election
    @election = Election.find_by_id(params[:id], :include => :event)
  end
  
  def check_vote
    @has_voted = (@election.voters.include? current_user)        
  end
  
  def exception_occurred(exception)
     flash[:error] = "Errore"
     respond_to do |format|
       format.js { render :update do |page|
                    page.replace_html "flash_messages", :partial => 'layouts/flash', :locals => {:flash => flash}
                  end                  
                  }
       format.html {
         redirect_to :back
       }
     end 
  end  
end
