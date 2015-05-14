class Airesis.ProposalNavigator
  constructor: ->
    @navigators = $('.navigator')
    @solution_navigators = @navigators.find('.sol_nav')
    @section_navigators = @navigators.find('.sec_nav')
    @solution_section_navigators = @navigators.find('.sol_sec_nav')
    @move_up_selector = '.move_up'
    @move_down_selector = '.move_down'
    @remove_selector = '.remove'

    $(document).on 'click', '[data-scroll-to-section]', ->
      ProposalsEdit.scrollToSection(@)

    @solution_navigators.addClass 'collapsed expanded'
    @solution_navigators.on 'click', (event) ->
      if this is event.target
        $(this).toggleClass 'expanded'
        $(this).children('ul').toggle()
        solution = new Airesis.SolutionContainer($(this).data('solution_id'))
        solution.toggle !solution.element.data('compressed')
    $('[data-navigator-expand]').click =>
      @toggleSolutionNavigators(true)
    $('[data-navigator-collapse]').click =>
      @toggleSolutionNavigators(false)

    @section_navigators.on('click', @move_up_selector, =>
      @.moveUpSection(`$(this)`)
    ).on('click', @move_down_selector, =>
      @.moveDownSection(`$(this)`)
    ).on('click', @remove_selector, =>
      @.removeSection(`$(this)`)
    )

    @solution_section_navigators.on('click', @move_up_selector, =>
      @.moveUpSection(`$(this)`)
    ).on('click', @move_down_selector, =>
      @.moveDownSection(`$(this)`)
    ).on('click', @remove_selector, =>
      @.removeSection(`$(this)`)
    )

    @solution_navigators.on('click', '.sol.move_up', =>
      @.moveUpSolution(`$(this)`)
    ).on('click', '.sol.move_down', =>
      @.moveDownSolution(`$(this)`)
    ).on 'click', '.sol.remove', =>
      @.removeSolution(`$(this)`)
  # navigator methods
  collapsed_solution_navigators: ->
    @solution_navigators.filter('.collapsed')
  toggleSolutionNavigators: (expand)->
    @collapsed_solution_navigators().toggleClass('expanded',expand)
    @collapsed_solution_navigators().children('ul').toggle(expand)
    ProposalsEdit.toggleSolutions !expand
  getSectionActionSubject: (list_element)->
    section_id = list_element.data('section_id')
    new Airesis.SectionContainer(section_id)
  getSolutionActionSubject: (list_element)->
    solution_id = list_element.data('solution_id')
    new Airesis.SolutionContainer(solution_id)
  moveDownNavigatorElement: (list_element)->
    list_element_ex = list_element.next()
    list_element.before list_element_ex
  moveUpNavigatorElement: (list_element)->
    list_element_ex = list_element.prev()
    list_element.after list_element_ex
  moveUpSection: (section)->
    list_element = section.parent()
    @moveUpNavigatorElement(list_element)
    to_move = @getSectionActionSubject(list_element)
    to_move.moveUp()
  moveDownSection: (section)->
    list_element = section.parent()
    @moveDownNavigatorElement(list_element)
    to_move = @getSectionActionSubject(list_element)
    to_move.moveDown()
  removeSection: (section)->
    list_element = section.parent()
    list_element.remove()
    to_remove = @getSectionActionSubject(list_element)
    to_remove.remove()
  moveUpSolution: (solution)->
    list_element = solution.parent()
    @moveUpNavigatorElement(list_element)
    to_move = @getSolutionActionSubject(list_element)
    to_move.moveUp()
  moveDownSolution: (solution)->
    list_element = solution.parent()
    @moveDownNavigatorElement(list_element)
    to_move = @getSolutionActionSubject(list_element)
    to_move.moveDown()
  removeSolution: (solution)->
    list_element = solution.parent()
    list_element.remove()
    to_remove = @getSolutionActionSubject(list_element)
    to_remove.remove()
