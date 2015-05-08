window.QuorumsDates =
  init: ->
    $('[data-start-votation]').on 'dblclick', ->
      QuorumsDates.changeStart()

    $('[name="proposal[votation][choise]"]').change ->
      if $(this).val() == 'preset'
        $('.choise_b .inner').css('opacity', 0.6)
        $('.choise_a .inner').css('opacity', 1)
      else
        $('.choise_b .inner').css('opacity', 1)
        $('.choise_a .inner').css('opacity', 0.6)
    $('.radiolabel').click ->
      $('#' + $(this).attr('for')).click()

    $('#proposal_votation_vote_period_id').select2
      minimumResultsForSearch: -1,
      formatResult: formatPeriod,
      formatSelection: formatPeriod,
      escapeMarkup: (m)->
        return m

    $('#proposal_votation_vote_period_id').on "select2-focus", (e)->
      $('#proposal_votation_choise_preset').click()

    $('#proposal_votation_end').fdatetimepicker()

    $('#proposal_votation_start').fdatetimepicker().on 'hide', (event)->
      eventStartTime_ = event.date
      $('#proposal_votation_end').fdatetimepicker("setStartDate", eventStartTime_)
      $('#proposal_votation_end').fdatetimepicker("setDate", addMinutes(eventStartTime_, 2880))
      showOnField($('#proposal_votation_end'), 'Changed!')
      $('#proposal_votation_choise_new').click()

    $('#choose_votation .cancel_action').click ->
      $('#start_preset').show()
      $('#start_choose').hide()
      $('#proposal_votation_start_edited').val(null)

    $('#later').click ->
      later_ = $('#proposal_votation_later')
      if later_.val() is 'true'
        $('#choose_votation .inner').show()
        later_.val('false')
      else
        $('#choose_votation .inner').hide()
        later_.val('true')
      switchText($(this))
      return false
  changeStart: ->
    $('#start_preset').hide()
    $('#start_choose').show()
    $('#proposal_votation_start_edited').val('true')
