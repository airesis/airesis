window.UsersAlarmPreferences =
  init: ->
    $('[data-change-notification-block]').on 'click', ->
      UsersAlarmPreferences.change_notification_block(this)
    $('[data-change-email-notification-block]').on 'click', ->
      UsersAlarmPreferences.change_email_notification_block(this)
    $('[data-change-email-block]').on 'click', ->
      UsersAlarmPreferences.change_email_block(this)
  change_notification_block: (el)->
    block_ = !el.checked
    $.ajax
      url: "/notifications/change_notification_block"
      dataType: 'script'
      data: {
        id: el.value
        block: block_
      }
      type: 'post'
    if el.checked
      $('#block_email_' + el.value).removeAttr("disabled").removeAttr("title")
    else
      $('#block_email_' + el.value).attr("disabled", true).attr("title", "Devi attivare la notifica per ricevere l'email")
  change_email_notification_block: (el)->
    block_ = !el.checked
    $.ajax
      url: "/notifications/change_email_notification_block"
      dataType: 'script'
      data: {
        id: el.value
        block: block_
      }
      type: 'post'
  change_email_block: (el)->
    block_ = !el.checked
    $.ajax
      url: "/notifications/change_email_block"
      dataType: 'script'
      data: {
        block: block_
      }
      type: 'post'
