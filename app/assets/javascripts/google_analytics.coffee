class @GoogleAnalytics
  @load: ->
    return if Airesis.googleAnalyticsId is ''
    # Google Analytics depends on a global _gaq array. window is the global scope.
    ((i, s, o, g, r, a, m) ->
      i["GoogleAnalyticsObject"] = r
      i[r] = i[r] or ->
          (i[r].q = i[r].q or []).push arguments

      i[r].l = 1 * new Date()

      a = s.createElement(o)
      m = s.getElementsByTagName(o)[0]

      a.async = 1
      a.src = g
      m.parentNode.insertBefore a, m
    ) window, document, "script", "//www.google-analytics.com/analytics.js", "ga"


    # If Turbolinks is supported, set up a callback to track pageviews on page:change.
    # If it isn't supported, just track the pageview now.
    if typeof Turbolinks isnt 'undefined' and Turbolinks.supported
      document.addEventListener "page:change", (->
        GoogleAnalytics.trackPageview()
      ), true
    else
      GoogleAnalytics.trackPageview()

  @trackPageview: (url) ->
    unless GoogleAnalytics.isLocalRequest()
      if url
        window.ga('send', 'pageview', window.location.pathname)
      else
        window.ga('create', Airesis.googleAnalyticsId, 'auto')
        window.ga('send', 'pageview')

  @isLocalRequest: ->
    GoogleAnalytics.documentDomainIncludes "local"

  @documentDomainIncludes: (str) ->
    document.domain.indexOf(str) isnt -1
