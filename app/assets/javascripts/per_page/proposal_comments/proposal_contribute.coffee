class @ProposalContribute
  constructor: (@id, @sectionId)->
    @contribute = $("[data-contribute][data-id=#{@id}]")
  integrate: =>
    @hide()
    @decreaseCount()
  hide: =>
    @contribute.fadeOut()
  decreaseCount: =>
    if @sectionId
      contributeButton = $("[data-contribute-button][data-section_id=#{@sectionId}]");
      numContributes = parseInt(contributeButton.data('contributes_num'));
      contributeButton.data('contributes_num',numContributes-1);
      $('.contribute-button-num', contributeButton).
      text("(#{contributeButton.data('unread_contributes_num')}/#{contributeButton.data('contributes_num')})")
