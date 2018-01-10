window.ParticipationRolesIndex =
  init: ->
    $(document).on 'click', '[data-action-abilitation]', ->
      $(@).closest('form').submit();

