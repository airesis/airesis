#encoding: utf-8
module StepHelper
  
  #check if there are tutorials to do for the current user
  #the tutorials are assigned to a controller and an action
  #eventualmente, lo step da mostrare 
  def get_next_step(user=current_user)
    tutorial_assignee = current_user.todo_tutorial_assignees.first(:joins => :tutorial, :conditions => "tutorials.action = '#{params[:action]}' and tutorials.controller = '#{params[:controller]}'", :readonly => false)
    check_tutorial_status(tutorial_assignee) if tutorial_assignee
  end
  
  def check_tutorial_status(tutorial_assignee)
    tutorial = tutorial_assignee.tutorial
    user = tutorial_assignee.user
    steps = tutorial.steps
    next_step = nil
    steps.each do |step|
      unless check_step_condition(step,user)
        next_step = step
        break
      end
    end #each step
    tutorial_assignee.update_attribute(:completed,true) unless next_step #completo se non ci sono step da fare
    session[:next_step_id] = next_step.id if next_step #salvo in sessione l'id dello step attualmente mostrato all'utente
    next_step
  end
  
  #ritorna true se lo step è già stato fatto dall'utente e può essere saltato 
  def check_step_condition(step,user)
    progress = TutorialProgress.find_by_step_id_and_user_id(step.id,user.id)
    return true unless (progress.status == TutorialProgress::TODO rescue false)
    case step.tutorial_id.to_i 
     when Tutorial.find_by_name("Welcome Tutorial").id
        status = welcome_steps(step,user)
        if status
          progress.update_attribute(:status,TutorialProgress::DONE)
        end 
        return status
     when Tutorial.find_by_action_and_controller("show","proposals").id
        status = show_proposal_steps(step,user)
        if status
          progress.update_attribute(:status,TutorialProgress::DONE)
        end 
        return status
      else
        logger.error "Impossibile trovare tutorial_id: " + step.tutorial_id.to_s
        return false
    end
    
  end
  
  def show_proposal_steps(step,user)
     case step.index 
      when 0
        return false            
      when 1
        return false
      end
  end
  
  def welcome_steps(step,user)
    case step.index 
      when 0 #il messaggio di benvenuto non viene mostrato dopo X volte che l'utente si è già autenticato al sistema
        return (user.sign_in_count > 5)            
      when 1
        return (user.interest_borders.count > 0)
      when 2
        return (user.group_partecipations.count > 0 || user.group_partecipation_requests.count > 0)
      when 3
        return (user.proposals.count > 0)
      else
        logger.error "Impossibile trovare tutorial_id: " + step.tutotial_id.to_s + ", step_index: " + step.index.to_s 
        return false
    end
  end
  
  #salta uno step del tutorial
  def skip_step(step,user)
    
  end
  
  #segna come completato uno step del tutorial
  def complete_step(step,user)
    logger.info "User #{user.login} has completed fragment #{step.fragment}"
  end
  
end
