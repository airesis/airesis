class @Facebook

  rootElement = null
  eventsBound = false

  @load: ->
    unless $('#fb-root').size() > 0
      initialRoot = $('<div>').attr('id', 'fb-root')
      $('body').prepend initialRoot

    unless $('#facebook-jssdk').size() > 0
      facebookScript = document.createElement("script")
      facebookScript.id = 'facebook-jssdk'
      facebookScript.async = 1
      facebookScript.src = "//connect.facebook.net/#{Facebook.locale()}/sdk.js#xfbml=1&appId=#{Facebook.appId()}&version=v2.0"

      firstScript = document.getElementsByTagName("script")[0]
      firstScript.parentNode.insertBefore facebookScript, firstScript

    Facebook.bindEvents() unless Facebook.eventsBound
    Facebook.subscriptions()

  @subscriptions = ->

  @bindEvents = ->
    if typeof Turbolinks isnt 'undefined' and Turbolinks.supported
      $(document)
      .on('page:fetch', Facebook.saveRoot)
      .on('page:change', Facebook.restoreRoot)
      .on('page:load', ->
        FB?.XFBML.parse()
      )

    Facebook.eventsBound = true

  @saveRoot = ->
    Facebook.rootElement = $('#fb-root').detach()

  @restoreRoot = ->
    if $('#fb-root').length > 0
      $('#fb-root').replaceWith Facebook.rootElement
    else
      $('body').append Facebook.rootElement

  @appId = ->
    $('#fb-root').data('app-id')
  @locale = ->
    $('#fb-root').data('locale')


window.fbAsyncInit = ->
  FB.Event.subscribe 'edge.create', (href, widget)->
    likeable_type = $(widget).data('likeable_type');
    likeable_id = $(widget).data('likeable_id');
    if likeable_type && likeable_id
      $.ajax
        headers: {'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content')},
        data: 'user_like[likeable_id]=' + likeable_id + '&user_like[likeable_type]=' + likeable_type,
        url: $('#fb-root').data('user-like-url'),
        type: 'post'

  FB.Event.subscribe 'edge.remove', (href, widget)->
    likeable_type = $(widget).data('likeable_type')
    likeable_id = $(widget).data('likeable_id')
    if (likeable_type && likeable_id)
      $.ajax
        headers: {'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content')},
        data: 'user_like[likeable_id]=' + likeable_id + '&user_like[likeable_type]=' + likeable_type,
        url: $('#fb-root').data('user-like-url') + '/' + likeable_id,
        type: 'delete'
