#encoding: utf-8
class CandidatesController < ApplicationController
  include StepHelper
  
  layout "groups"

  before_filter :load_group, :only => [:new, :create]
  before_filter :check_group, :only => [:new, :create]
  before_filter :check_election, :only => [:create,:update]
  before_filter :check_user, :only => [:create,:update]

  before_filter :authenticate_user!
  #before_filter :load_election
  #load_and_authorize_resource 
  
  def index

    @step = get_next_step(current_user)
    @group = params[:group_id] ? Group.find(params[:group_id]) : request.subdomain ? Group.find_by_subdomain(request.subdomain) : nil
    raise CanCan::AccessDenied if @group.certified?
    authorize! :view_data, @group
    @page_title = @group.name + ": Area candidature"
  end
  
  def show
    
  end  
  
     
  def new
     @page_title = "Invia una nuova candidatura"
     @candidate = Candidate.new
  end
  
  def create
    begin
      @candidate =  @group.candidates.create(params[:candidate])
      
      respond_to do |format|
          flash[:notice] = "Hai candidato l'utente"
          format.html { redirect_to( group_candidates_url @group) }
          #format.xml  { render :xml => @group, :status => :created, :location => @group }
      end 
      
    rescue ActiveRecord::ActiveRecordError => e
      respond_to do |format|
        flash[:error] = "Errore nella creazione dell'elezione."
        format.html { render :action => "new" }                
      end        
    end  
  end
    
  def test_schulze
    puts "Hello everybody. I'm running"
    vs = SchulzeBasic.do File.open("test/votes/vote4.list")
    puts vs.ranks
    puts vs.ranks_abc
    
    
    @test_string = "3=a;c;d;b\n9=b;a;c;d\n8=c;d;a;b\n5=d;a;b;c\n5=d;b;c;a"  
    
    vs = SchulzeBasic.do @test_string, 4
    puts vs.ranks
    puts vs.ranks_abc
  end
  
  
  
  protected
  
  def check_group
    if !(can? :send_candidate, @group)
      flash[:error] = "Non puoi inviare candidati per questo gruppo"
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
  
  
  def check_election
    @election = Election.find_by_id(params[:candidate][:election_id])
        
    if !(@group.elections.include? @election)
      flash[:error] = "Non puoi inviare candidati a questa elezione"
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
  
  def check_user
    @user = User.find_by_id(params[:candidate][:user_id])
    unless @group.partecipants.include? @user
      flash[:error] = "Non puoi candidare questo utente"
      respond_to do |format|
        format.html {
          redirect_to @group
        }
      end 
    end
  end
  
  
  def load_election
    @election = Election.find(params[:id])
  end
     
end
