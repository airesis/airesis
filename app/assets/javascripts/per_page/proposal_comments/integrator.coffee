class @ProposalCommentsIntegrator
  constructor: ->
    @submitField = $('[data-integrated-contributes-list]')
    @submitField.val('')
    @integrated_contributes = []
    $(document).on 'click', '[data-integrate-contribute]', (event)=>
      @integrate_contribute(event.target)
  integrate_contribute: (el) =>
    id = $(el).data('integrate-contribute')
    comment_ = $(el).parents('[data-contribute]')
    inside_ = comment_.find('.proposal_comment')
    if $(el).is(':checked')
      @integrated_contributes.push id
      comment_.fadeTo 400, 0.3
      inside_.attr 'data-height', inside_.outerHeight()
      inside_.css 'overflow', 'hidden'
      inside_.animate {height: '52px'}, 400
      comment_.find('[id^=reply]').each ->
        $(this).attr 'data-height', $(this).outerHeight()
        $(this).css 'overflow', 'hidden'
        $(this).animate {height: '0px'}, 400
    else
      @integrated_contributes.splice @integrated_contributes.indexOf(id), 1
      comment_.fadeTo 400, 1
      inside_.animate {height: inside_.attr('data-height')}, 400, 'swing', ->
        inside_.css 'overflow', 'auto', ->
      comment_.find('[id^=reply]').each ->
        $(this).animate {height: $(this).attr('data-height')}, 400, 'swing', ->
          $(this).css 'overflow', 'auto', ->
    @submitField.val @integrated_contributes
