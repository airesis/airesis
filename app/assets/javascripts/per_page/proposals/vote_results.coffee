window.ProposalsVoteResults =
  init: ->
    @.showVoteResults()
    $('[data-plot]').each ->
      dataa = [
        [ProposalsVoteResults.positive, $(this).data('positive')]
        [ProposalsVoteResults.neutral, $(this).data('neutral')]
        [ProposalsVoteResults.negative, $(this).data('negative')]
      ]
      ProposalsVoteResults.plot1 = $.jqplot('vote-results-chart', [dataa],
        seriesColors: ['#4bb2c5', '#c5b47f', '#EAA228']
        seriesDefaults:
          renderer: jQuery.jqplot.PieRenderer
          rendererOptions:
            showDataLabels: true
        legend:
          show: false
          location: 'e')
      $(document).on 'opened.fndtn.reveal', '[data-reveal]', ->
        ProposalsVoteResults.plot1.replot()

  showVoteResults: ->
    $('[data-votes-table]').dataTable 'oLanguage':
      'sLengthMenu': 'Mostra _MENU_ utenti per pagina'
      'sSearch': 'Cerca:'
      'sZeroRecords': 'Nessun utente, spiacente..'
      'sInfo': 'Sto mostrando da _START_ a _END_ di _TOTAL_ utenti'
      'sInfoEmpty': 'Sto mostrando 0 utenti'
      'sInfoFiltered': '(filtrati da un totale di _MAX_ utenti)'
      'oPaginate':
        'sPrevious': 'Pagina precedente'
        'sNext': 'Pagina successiva'
    $('.dataTables_wrapper label').css('font-weight', 'normal').css 'font-size', '12px'
    $('#cast_table').dataTable
      'oLanguage':
        'sLengthMenu': 'Mostra _MENU_ voti per pagina'
        'sSearch': 'Cerca:'
        'sZeroRecords': 'Nessun voto, spiacente..'
        'sInfo': 'Sto mostrando da _START_ a _END_ di _TOTAL_ voti'
        'sInfoEmpty': 'Sto mostrando 0 voti'
        'sInfoFiltered': '(filtrati da un totale di _MAX_ voti)'
        'oPaginate':
          'sPrevious': 'Pagina precedente'
          'sNext': 'Pagina successiva'
      'bFilter': false
    $('#cast_table_wrapper label').css('font-weight', 'normal').css 'font-size', '12px'
