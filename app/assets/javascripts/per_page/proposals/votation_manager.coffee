class Airesis.ProposalVotationManager
  constructor: ->
    @_initSolutionScrollAndTips()
    @_initSchulzeVoteButton()
    @_initVoteButton()
    @_initSortable()
  _initVoteButton: ->
    $('.votebutton').on 'click', ->
      type = $(this).data('vote-type')
      message = if type == Airesis.i18n.proposals.vote.positive then Airesis.i18n.proposals.vote.confirm_positive else if type == Airesis.i18n.proposals.vote.neutral then Airesis.i18n.proposals.vote.confirm_neutral else Airesis.i18n.proposals.vote.confirm_negative
      if confirm(message)
        $('#data_vote_type').val type
        $('.votebutton').fadeOut()
        $('.vote_panel form').fadeOut()
        $('.loading_vote').show()
        $('.vote_panel form').submit()
      false
  _initSchulzeVoteButton: ->
    $('#schulze-submit').on 'click', =>
      votestring = ''
      $('.vote-items').each (c_id, cont)->
        items = $(cont).find('.vote-item')
        return true unless items.length
        votestring += ';' unless votestring is ''
        items.each (item_id, item)->
          if (item_id isnt 0)
            votestring += ','
          votestring += $(item).data('id')
      $('#data_votes').val votestring
      true
  _initSolutionScrollAndTips: ->
    $('.vote_solution_title').each ->
      $(this).on 'click', ->
        scrollToElement $('.solution_main[data-solution_id=' + $(this).parent().data('id') + ']')
        false
      $(this).qtip content: $('.proposal_content[data-id=' + $(this).parent().data('id') + ']').clone()
  _initSortable: ->
    $('.vote-items').each (id, el)=>
      @_checkBoxSiblings($(el).parent())
      @_initSortableBox(el)
  _checkBoxSiblings: (to)->
    next_box = to.nextAll('.vote-items-external')
    prev_box = to.prevAll('.vote-items-external')
    if next_box.length
      @_destroyBoxes(next_box)
    else
      box = @_buildBox()
      to.after(box)
      @_initSortableBox(box.find('.vote-items')[0])
    if prev_box.length
      @_destroyBoxes(prev_box)
    else
      box = @_buildBox()
      to.before(box)
      @_initSortableBox(box.find('.vote-items')[0])
    @_countBoxes()
  _initSortableBox: (el)->
    sortable = Sortable.create el,
      group: 'vote'
      animation: 150
      onAdd: (event)=>
        to = $(event.to).parent()
        @_checkBoxSiblings(to)
  _buildBox: ->
    extBox = $('<div>').attr('class', 'vote-items-external')
    extBox.append('<span class="label primary">')
    box = $('<div>').attr('class', 'vote-items')
    extBox.append(box)
    extBox
  _destroyBoxes: (boxes)->
    firstBox = true
    boxes.each (id, box)->
      items = $(box).find('.vote-items').find('.vote-item')
      if items.length
        firstBox = true
      else
        if firstBox
          firstBox = false
          return true
        else
          $(box).remove()
  _countBoxes: ->
    boxes = $('.vote-items-external')
    top = $(boxes.get(-1)).find('.label').html('-')
    boxes.splice(boxes.length - 1, 1)
    bottom = $(boxes.get(0)).find('.label').html('+')
    boxes.splice(0, 1)
    boxes.each (id, box)->
      $(box).find('.label').html(id + 1)
