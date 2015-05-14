class Airesis.SectionContainer
  @selector: '.section_container'
  constructor: (@id)->
    if @id instanceof jQuery
      @element = @id
      @id = @element.data('section_id')
    else
      @element = $(Airesis.SectionContainer.selector).filter('[data-section_id=' + @id + ']')
    @seqField = @element.find("[name$='[seq]']")
    @titleField = @element.find("[name$='[title]']")
  moveUp: ->
    #console.log 'move up'
    to_exchange = @element.prevAll(Airesis.SectionContainer.selector).first()
    @element.after to_exchange
    ProposalsEdit.updateSequences()
  moveDown: ->
    #console.log 'move down'
    to_exchange = @element.nextAll(Airesis.SectionContainer.selector).first()
    @element.before to_exchange
    ProposalsEdit.updateSequences()
  remove: ->
    @element.find('.remove_button a').click()
    ProposalsEdit.updateSequences()
  setSeq: (val)->
    @seqField.val(val)
    console.log @titleField.val() + " has sequence #{val}"
