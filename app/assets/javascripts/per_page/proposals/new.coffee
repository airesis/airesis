window.ProposalsNew =
  skippedSuggestionStep: false
  groupId: null
  init: ->
    input = $('#proposal_interest_borders_tkn')
    input.tokenInput Airesis.paths.interest_borders.index, {
      propertyToSearch: 'text'
      crossDomain: false
      prePopulate: input.data("pre")
      hintText: Airesis.i18n.interestBorders.hintText
      noResultsText: Airesis.i18n.interestBorders.noResultsText
      searchingText: Airesis.i18n.interestBorders.searchingText
      preventDuplicates: true
      allowTabOut: true
    }

    input = $('#proposal_tags_list')
    input.tokenInput Airesis.paths.tags.index, {
      theme: "facebook"
      crossDomain: false
      allowFreeTagging: true
      minChars: 3,
      hintText: Airesis.i18n.tags.hintText
      searchingText: Airesis.i18n.tags.searchingText
      preventDuplicates: true
      allowTabOut: true
      tokenValue: "name"
    }

    $('#proposal_proposal_category_id').select2 {
      minimumResultsForSearch: -1
      templateResult: formatCategory
      templateSelection: formatCategory
      escapeMarkup: (m)->
        return m
      }
    .on 'select2:close', ->
      $('#new_proposal').formValidation 'revalidateField', 'proposal[proposal_category_id]'

    new Airesis.QuorumSelector()
