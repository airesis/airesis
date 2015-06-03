class Airesis.Searcher
  searchcache: {}
  constructor: ->
    searchcache = {}
    search_f = $('#search_q')
    return unless search_f.length > 0
    search_f.autocomplete
      minLength: 1
      source: (request, response) ->
        term = request.term
        if term of searchcache
          response searchcache[term]
        $.getJSON '/searches', request, (data, status, xhr) ->
          searchcache[term] = data
          response data
      focus: (event, ui) ->
        event.preventDefault()
      select: (event, ui) ->
        window.location.href = ui.item.url
        event.preventDefault()

    search_f.data('uiAutocomplete')._renderMenu = (ul, items) ->
      that = this
      $.each items, (index, item) ->
        if item.type == 'Divider'
          ul.append $('<li class=\'ui-autocomplete-category\'>' + item.value + '</li>')
        else
          that._renderItemData ul, item
        return
      $(ul).addClass('f-dropdown').addClass('medium').css('z-index', 1005).css 'width', '400px'

    search_f.data('uiAutocomplete')._renderItem = (ul, item) ->
      el = $('<li>')
      link_ = $('<a></a>')
      container_ = $('<div class="search_result_container"></div>')
      image_ = $('<div class="search_result_image"></div>')
      container_.append image_
      desc_ = $('<div class="search_result_description"></div>')
      desc_.append '<div class="search_result_title">' + item.label + '</div>'
      text_ = $('<div class="search_result_text">' + '</div>')
      if item.type == 'Blog'
        image_.append item.image
        text_.append '<a href="' + item.user_url + '">' + item.username + '</a>'
      else if item.type == 'Group'
        text_.append '<div class="groupDescription"><img src="' + Airesis.assets.group_participants + '"><span class="count">' + item.participants_num + '</span></div>'
        text_.append '<div class="groupDescription"><img src="' + Airesis.assets.group_proposals + '"><span class="count">' + item.proposals_num + '</span></div>'
        image_.append '<img src="' + item.image + '"/>'
      else
        image_.append '<img src="' + item.image + '"/>'
      desc_.append text_
      container_.append desc_
      container_.append '<div class="clearboth"></div>'
      link_.attr 'href', item.url
      link_.append container_
      el.append link_
      el.appendTo ul
      el
