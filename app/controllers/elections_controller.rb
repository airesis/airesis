#encoding: utf-8
class ElectionsController < ApplicationController
  require 'vote-schulze'
  
  before_filter :check_group, :only => [:new, :create]
  
  before_filter :load_election, :except => [:index,:new,:create]
  #load_and_authorize_resource 
  
  def show
    
  end
  
    
  def vote_page
       
  end
     
  def new
     @election = Election.new
     @events = Event.all
     respond_to do |format|
       format.html # new.html.erb
      #format.xml  { render :xml => @group }
      end
  end
  
  def create
    begin
      Election.transaction do
          @group.elections.build(params[:election])
          @group.save!
      end
      
      respond_to do |format|
          flash[:notice] = 'Hai creato il l''elezione'
          format.html { redirect_to(@group) }
          #format.xml  { render :xml => @group, :status => :created, :location => @group }
      end 
      
    rescue ActiveRecord::ActiveRecordError => e
      respond_to do |format|
        flash[:error] = 'Errore nella creazione dell''elezione.'
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
    @group = Group.find_by_id(params[:group_id])
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
  
  def load_election
    @election = Election.find(params[:id])
  end
     
end
