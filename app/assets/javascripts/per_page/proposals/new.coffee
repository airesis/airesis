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

    quorum_ = $('#proposal_quorum_id')
    quorum_.select2
      minimumResultsForSearch: -1
      templateResult: formatQuorum
      templateSelection: formatQuorumSelection
      escapeMarkup: (m) ->
        m
    quorum_.on 'change', (e) ->
      selected_ = quorum_.find('option:selected')
      exlanation_ = selected_.data('explanation')
      timefixed_ = selected_.data('time_fixed')
      minutes_ = selected_.data('minutes')
      id_ = selected_.val()
      if exlanation_
        $('#quorum_explanation').html(exlanation_).show()
      else
        $('#quorum_explanation').hide()
      choose_vote = $('#choose_votation')
      if timefixed_
        $.ajax
          url: Airesis.paths.quorums.dates
          data:
            id: id_
            group_id: ProposalsNew.groupId
          success: ->
            choose_vote.show()
            now_ = new Date
            end_ = addMinutes(now_, parseInt(minutes_) + ProposalsNew.debateVoteDifference)
            #votation start time
            upperend_ = upperMinutes(end_, 5)
            #votation end time
            min_votation_end_ = addMinutes(upperend_, 10)
            votation_end_ = addMinutes(upperend_, 2880)
            start_field = $('#proposal_votation_start')
            end_field = $('#proposal_votation_end')
            choose_vote.find('.start_vot').html Airesis.i18n.proposals.debate.end + ' (' + dateToString(upperend_) + ')'
            start_field.fdatetimepicker 'setStartDate', upperend_
            start_field.fdatetimepicker 'setDate', upperend_
            end_field.fdatetimepicker 'setStartDate', min_votation_end_
            end_field.fdatetimepicker 'setDate', votation_end_
      else
        choose_vote.hide()
