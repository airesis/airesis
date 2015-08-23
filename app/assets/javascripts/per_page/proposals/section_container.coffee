class Airesis.SectionContainer
  @selector: '.section_container'
  constructor: (param)->
    if param instanceof HTMLElement
      @element = $(param)
    else if param instanceof jQuery
      @element = param
    else
      @element = $(Airesis.SectionContainer.selector).filter("[data-section_id=#{param}]")
    @id = @element.data('section_id')
    @seqField = @element.find("[data-section-seq]")
    @titleField = @element.find("[name$='[title]']")
    @title = @titleField.val()
    @destroyField = @element.find("[data-section-destroy]")
    @editor = @element.find("textarea[name$='[content_dirty]']")
  persisted: ->
    @element.data('persisted')
  destroyCkEditor: ->
    CKEDITOR.instances[@editor.attr('id')].destroy()
  initCkEditor: ->
    editor_ = CKEDITOR.replace(@editor.attr('id'),
      'toolbar': 'proposal'
      'language': Airesis.i18n.locale
      'customConfig': Airesis.assets.ckeditor.config_lite)
    @addEditorEvents(editor_)
  addEditorEvents: (editor_)->
    editor_.on 'lite:init', (event) ->
      #ProposalsEdit.ckedstoogle_[event.editor.name]['first'] = false
      lite = event.data.lite
      #ProposalsEdit.ckedstoogle_[event.editor.name]['editor'] = lite
      lite.toggleShow true  # TODO
      lite.setUserInfo
        id: Airesis.id
        name: Airesis.fullName
      return
    editor_.on 'lite:showHide', (event) ->
      #if !ProposalsEdit.ckedstoogle_[event.editor.name]['first']
      #  ProposalsEdit.ckedstoogle_[event.editor.name]['state'] = event.data.show
      return
    return
  exchange: (toExchange, action)->
    toExchangeContainer = new Airesis.SectionContainer(toExchange)
    toExchangeContainer.destroyCkEditor()
    @destroyCkEditor()
    action.apply();
    @initCkEditor()
    toExchangeContainer.initCkEditor()
    ProposalsEdit.updateSequences()
  moveUp: ->
    #console.log 'move up'
    toExchange = @element.prevAll(Airesis.SectionContainer.selector).first()
    @exchange toExchange, =>
      @element.after toExchange
  moveDown: ->
    #console.log 'move down'
    toExchange = @element.nextAll(Airesis.SectionContainer.selector).first()
    @exchange toExchange, =>
      @element.before toExchange
  remove: ->
    if confirm Airesis.i18n.proposals.edit.removeSectionConfirm
      if @persisted()
        @destroyField.val(1)
        @element.fadeOut()
      else
        @element.fadeOut ->
          @element.remove()
      ProposalsEdit.updateSequences()
      return true
    else
      return false
  setSeq: (val)->
    @seqField.val(val)
    #console.log @titleField.val() + " has sequence #{@seqField.val()}"
