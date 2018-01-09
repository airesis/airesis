window.UsersBorderPreferences =
  init: ->
    input = $('#user_interest_borders_tokens')
    input.tokenInput "/interest_borders.json",
        propertyToSearch: 'text'
        crossDomain: false
        prePopulate: input.data("pre")
        hintText: Airesis.i18n.interestBorders.hintText
        noResultsText: Airesis.i18n.interestBorders.noResultsText
        searchingText: Airesis.i18n.interestBorders.searchingText
        preventDuplicates: true
