module StepsHelper
  # check if there are tutorials to do for the current user
  # the tutorials are assigned to a controller and an action
  # eventualmente, lo step da mostrare
  def get_next_step(_user = current_user)
    @tutorial_controller ||= params[:controller]
    @tutorial_action ||= params[:action]
    tutorial_assignee = current_user.todo_tutorial_assignees.
                        joins(:tutorial).
                        where('tutorials.action = ? AND tutorials.controller = ?', @tutorial_action, @tutorial_controller).
                        readonly(false).first
    check_tutorial_status(tutorial_assignee) if tutorial_assignee
  end

  def check_tutorial_status(tutorial_assignee)
    tutorial = tutorial_assignee.tutorial
    user = tutorial_assignee.user
    steps = tutorial.steps
    next_step = nil
    steps.each do |step|
      unless check_step_condition(step, user)
        next_step = step
        break
      end
    end
    if next_step
      next_step = check_show_condition(next_step, user)
    else
      tutorial_assignee.update_attribute(:completed, true)
    end
    next_step
  end

  # check if we have to show the step now, in that page, at that user
  # is different from check step condition. check step condition check
  # if the user already saw the step or if has already done some actions.
  # this check, for example, if the show users page is of the current_user.
  # We do not show the tutorial on another user page
  def check_show_condition(step, user)
    case step.fragment
    when 'users_show'
      params[:id].to_i == user.id ? step : nil
    else
      step
    end
  end

  # ritorna true se lo step è già stato fatto dall'utente e può essere saltato
  def check_step_condition(step, user)
    progress = TutorialProgress.find_by(step_id: step.id, user_id: user.id)
    return true unless begin
                          progress.status == TutorialProgress::TODO
                       rescue StandardError
                         false
                        end

    case step.tutorial_id.to_i
    when Tutorial.find_by(name: 'Welcome Tutorial').id
      status = welcome_steps(step, user)
      progress.update_attribute(:status, TutorialProgress::DONE) if status
      status
    when Tutorial.find_by(action: 'show', controller: 'proposals').id
      status = show_proposal_steps(step, user)
      progress.update_attribute(:status, TutorialProgress::DONE) if status
      status
    else
      logger.error 'Impossibile trovare tutorial_id: ' + step.tutorial_id.to_s
      false
    end
  end

  def show_proposal_steps(step, _user)
    case step.index
    when 0
      false
    when 1
      false
    end
  end

  def welcome_steps(step, user)
    case step.index
    when 0 # il messaggio di benvenuto non viene mostrato dopo X volte che l'utente si è già autenticato al sistema
      (user.sign_in_count > 5)
    when 1
      (user.interest_borders.count > 0)
    when 2
      (user.group_participations.count > 0 || user.group_participation_requests.count > 0)
    when 3
      (user.proposals.count > 0)
    else
      logger.error 'Impossibile trovare tutorial_id: ' + step.tutorial_id.to_s + ', step_index: ' + step.index.to_s
      false
    end
  end
end
