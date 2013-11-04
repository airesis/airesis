#encoding: utf-8
class MeetingPartecipationsController < ApplicationController
   #l'utente deve aver fatto login
  before_filter :authenticate_user!
  
  before_filter :load_event
  before_filter :check_not_answered
  before_filter :check_not_past
  
  def create
    meeting = params[:meeting_partecipation]
    @meetingPartecipation = MeetingPartecipation.new(:user_id => current_user.id, :meeting_id => @event.meeting.id, :comment => meeting[:comment], :guests => meeting[:guests], :response => meeting[:response])
    @meetingPartecipation.save!
    
    flash[:notice] = "La tua risposta è stata inviata."
    respond_to do |format|
      format.js { render :update do |page|
                      page.replace_html 'flash_messages', :partial => 'layouts/flash', :locals => {:flash => flash}
                      page.replace_html 'partecipation_panel_container', :partial => 'events/partecipation_panel', :locals => {:event => @event}
                      page.replace_html 'partecipants_container', :partial => 'events/meeting_responses', :locals => {:event => @event}
                      page << "mybox_animate();"
                  end                  
      }
      format.html {
        redirect_to event_path(params[:event_id])
      }
    end
    
    rescue Exception => e
#    log_error(e)
      flash[:error] = t('error.event_answer')
      respond_to do |format|
        format.js { render :update do |page|
                      page.replace_html "flash_messages", :partial => 'layouts/flash', :locals => {:flash => flash}      
                      page.alert @meetingPartecipation.errors.full_messages.join(";")
                    end
        }       
        format.html {
          redirect_to event_path(params[:event_id])
        }
    end
  end
  
  
  protected
  
  def load_event
    @event = Event.find(params[:event_id])
  end
  
  #verifica che l'utente non abbia già risposto alla richiesta di partecipazione
  def check_not_answered
    partecipation = @event.meeting.meeting_partecipations.find_by_user_id(current_user.id)
    if (partecipation)
      flash[:error] = t('error.event_already_answered')
      respond_to do |format|
        format.js { render :update do |page|
                      page.replace_html "flash_messages", :partial => 'layouts/flash', :locals => {:flash => flash}          
                    end                  
        }
        format.html {
          redirect_to event_path(@event)
        }
      end
    end
  end
  
   #verifica che l'evento non sia finito
  def check_not_past
    if (@event.is_past?)
      flash[:error] = t('error.event_past')
      respond_to do |format|
        format.js { render :update do |page|
                      page.replace_html "flash_messages", :partial => 'layouts/flash', :locals => {:flash => flash}          
                    end                  
        }
        format.html {
          redirect_to event_path(@event)
        }
      end
    end
  end
  
end