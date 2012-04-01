#encoding: utf-8
module StepHelper
  
  #dato un utente, verifica se deve seguire un tutorial
  #per il controller e l'action corrente restituisce,
  #eventualmente, lo step da mostrare 
  def get_next_step(user=current_user)
    tutorial_assignee = current_user.todo_tutorial_assignees.find(:first)
    return check_tutorial_status(tutorial_assignee) if tutorial_assignee
    
  end
  
  def check_tutorial_status(tutorial_assignee)
    tutorial = tutorial_assignee.tutorial
    user = tutorial_assignee.user
    puts "Check stato tutorial #{tutorial.name} per l'utente #{user.login}"
    steps = tutorial.steps
    next_step = nil
    steps.each do |step|
      puts "Check stato step #{step.fragment} per l'utente #{user.login}"

      if (!check_step_condition(step,user))
        next_step = step
        break
      end
    end #each step
    tutorial_assignee.update_attribute(:completed,true) unless next_step #completo se non ci sono step da fare
    session[:next_step_id] = next_step.id if next_step #salvo in sessione l'id dello step attualmente mostrato all'utente
    return next_step
  end
  
  #ritorna true se lo step è già stato fatto dall'utente e può essere saltato 
  def check_step_condition(step,user)
    progress = TutorialProgress.find_by_step_id_and_user_id(step.id,user.id)
    return true unless progress.status == TutorialProgress::TODO
    case step.tutorial_id.to_i 
    when Tutorial::WELCOME
        return welcome_steps(step,user)
      else
        logger.error "Impossibile trovare tutorial_id: " + step.tutorial_id.to_s
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
        return false
      when 3
        return false
      when 4
        return false
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
