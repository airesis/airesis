window.QuorumsIndex =
  init: ->
    $('[data-quorum-check]').on 'click', ->
      QuorumsIndex.switchOption($(this),
        "/groups/#{QuorumsIndex.groupId}/quorums/#{$(this).data('quorum-check')}/change_status")
    $('[data-change-default-anonimity]').on 'click', ->
      QuorumsIndex.switchOption($(this), QuorumsIndex.changeDefaultAnonimityUrl)
    $('[data-change-default-visible-outside]').on 'click', ->
      QuorumsIndex.switchOption($(this), QuorumsIndex.changeDefaultVisibleOutsideUrl)
    $('[data-change-default-secret-vote]').on 'click', ->
      QuorumsIndex.switchOption($(this), QuorumsIndex.changeDefaultSecretVoteUrl)
    $('[data-change-default-advanced-options]').on 'click', ->
      QuorumsIndex.switchOption($(this), QuorumsIndex.changeDefaultAdvancedOptionsUrl)
  switchOption: (element, url)->
    active = element.is(':checked')
    $.ajax
      data:
        active: active
      url: url
      dataType: 'script'
      type: 'post'
