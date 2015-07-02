window.UsersShow =
  init: ->
    $('[data-participation-tooltip]').each ->
      $(this).qtip
        content: $(this).next('[data-participation-tooltip-text]')
        position:
          viewport: $('#main-copy')
    $('#participation_table').dataTable
      'bPaginate': false
      'bFilter': false
      'bSearchable': false
      'bInfo': false
      'aaSorting': [[2, 'desc']]
      'aoColumns': [null, null, {'iDataSort': 3}, {'bVisible': false}, null]
