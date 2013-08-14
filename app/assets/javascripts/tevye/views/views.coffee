set       = Em.set
get       = Em.get
merge     = Tevye.merge
isPresent = Tevye.isPresent
isBlank   = Tevye.isBlank
assert    = Em.assert
isFile    = (x) -> kindOf(x, specific: true) is "File"
isString  = _.isString

Tevye.SwitchView = Em.View.extend
  templateName: 'controls/switch'
  toggle: ->
    value = !@get('value')
    @$('input').attr 'checked', value
    @set 'value', value

widthClasses = ["none", "full", "half",
                "third", "fourth",
                "fifth", "sixth", "seventh"]

Tevye.ResizableContainerView = Ember.ContainerView.extend
  classNames: ['pane-container']
  didInsertElement: ->
    numChildren = @get('parentView.childViews.length')
    assert(numChildren < 8, "only set up to allow 7 child views")
    @get('parentView.childViews').forEach (viewName) =>
      view = @get("parentView.#{viewName}")
      view.get('classNames').push('pane', widthClasses[numChildren])
      @pushObject(view)

Tevye.ResizableView = Ember.View.extend
  classNames: ["resizable"]
  classNameBindings: ["orientationClass", "directionClass"]
  heightBinding: 'controller.controllers.application.resizeHeight'
  widthBinding: 'controller.controllers.application.resizeWidth'
  didInsertElement: ->
    @_super()
    @$().css('height', @get('height')) if isPresent @get('height')
    @$().css('width', @get('width')) if isPresent @get('width')
  orientationClass: (->
    @get "orientation"
  ).property("orientation")
  directionClass: (->
    @get "direction"
  ).property("direction")
  templateName: "components/resizable"
  orientation: "horizontal"
  direction: "left"
  defaultDirection: (->
    orientation = @get("orientation")
    direction = @get("direction")
    switch
      when orientation is "horizontal" and
           not ["left", "right"].contains(direction)
        @set("direction", "left")
      when orientation is "vertical" and
           not ["top", "bottom"].contains(direction)
        @set("direction", "bottom")
  ).observes("orientation")
  isResizing: false
  mouseDown: (event) ->
    if jQuery(event.target).hasClass("handle")
      event.preventDefault()
      @set('isResizing', true)
      jQuery(window, 'iframe').on('mousemove', jQuery.proxy(@dragMoveHandler, @))
      jQuery(window, 'iframe').on('mouseup', jQuery.proxy(@mouseUpHandler, @))
  dragMoveHandler: (event) ->
    event.preventDefault()
    return unless @get("isResizing")
    if @get("orientation") is "vertical"
      pageY     = event.originalEvent.pageY
      handle    = @$(".handle").height() / 2
      top       = @$().offset().top
      newHeight = Math.max pageY - top + handle, handle
      @set('height', newHeight)
      @$().css("height", newHeight)
    else
      pageX    = event.originalEvent.pageX
      left     = @$().offset().left
      newWidth = if @get("direction") is "left"
          delta = pageX - left
          width = @$().width()
          width - delta
        else
          pageX + left
      @set('width', newWidth)
      @$().css("width", newWidth)
  mouseUpHandler: (event) ->
    if @get('isResizing')
      @set('isResizing', false)
      jQuery(window, 'iframe').unbind('mousemove')
      jQuery(window, 'iframe').unbind('mouseup')

Tevye.Select = Em.Select.extend
  click: (e) ->
    e.stopImmediatePropagation()
    @_super()
Tevye.TextField = Em.TextField.extend()

Tevye.RequiredSwitch = Tevye.SwitchView.extend
  content: (->
    @get('parentView.content')
  ).property('parentView.content')

Tevye.Sortable = Ember.Mixin.create
  tagName: 'ul'
  classNames: ['sortable-container']
  contentBinding: 'sortableContent.arrangedContent'
  draggedContent: null
  reorderedItems: Em.ArrayProxy.create(content: [])
  isDragging: false

Tevye.SortableItem = Ember.Mixin.create
  tagName: 'li'
  classNames: ['sortable-item']
  classNameBindings: ['placeholderClass']
  placeholderClass: (->
    parent = @get('parentView')
    if @get('content.id') is parent.get('draggedContent.id') then 'placeholder' else ''
  ).property('parentView.isDragging')
  mouseUp: (e) ->
    parent = @get('parentView')
    parent.set 'isDragging', false
    parent.set 'draggedContent', null
  mouseDown: (e) ->
    return if $(e.target).is('select, input')
    e.preventDefault()
    parent = @get('parentView')
    parent.set 'isDragging', true
    parent.set 'draggedContent', @get('content')
  mouseEnter: (e) ->
    return unless @get('parentView.isDragging')
    target      = @get('content')
    source      = @get('parentView.draggedContent')

    sourceIndex = source.get('position')
    targetIndex = target.get('position')

    target.set 'position', sourceIndex
    source.set 'position', targetIndex

Tevye.CreatableTypeView = Em.Mixin.create
  isCreating: false
  toggleCreating: ->
    isCreating = @get("isCreating")
    @set("isCreating", not isCreating)
  buttonBaseClass: "new btn btn-mini"
  resourceClass: (->
    @get('controller.resourceName')
  ).property('controller.resourceName')
  buttonClass: (->
    base = @get("buttonBaseClass")
    base += " #{@get('resourceClass')}"
    if @get("isCreating")
      base += " btn-danger"
    else base += "  btn-primary"
    base
  ).property('isCreating')
  iconClass: (->
    if @get('isCreating') then 'glyphicon glyphicon-remove-circle'
    else 'glyphicon glyphicon-plus'
  ).property("isCreating")
  createItem: (value) ->
    controller = @get('controller')
    controller.createItem(title: value)

Tevye.PreviewView = Em.View.extend
  templateName: 'components/preview'
  $iframe: -> @$("iframe")[0]
  classNames: ['preview-view']
  iframeSrc: (->
    host = document.location.host
    url  = @get('controller.content.url')
    "http://#{host}/#{url}"
  ).property('controller.content.id')
  reload: (->
    if @get('controller.needsReload')
      @$iframe().src = @$iframe().src
    @set('controller.needsReload', false)
  ).observes('controller.needsReload')

Tevye.CustomFieldTypeSelect = Tevye.Select.extend
  optionValuePath: "content.value"
  optionLabelPath: "content.name"
  valueBinding: "parentView.newFieldType"
  name: 'new-custom-field-type'
  content: (->
    for key, value of Tevye.ContentType.fieldValueTypes
      value: key
      name: key.split('_').map((x) ->
        String::capitalize.call(x)
      ).join(' ')
  ).property()

Tevye.ContentTypeFormView = Em.View.extend Tevye.CreatableTypeView,
  resourceClass: 'custom-field'
  classNames: ['custom', 'form', 'content-type-form']
  templateName: 'content_type/form'
  newFieldType: 'text'
  createItem: (value) ->
    controller = @get('controller')
    controller.addCustomField(title: value, field_type: @get('newFieldType'))

Tevye.CustomFieldsEditView = Em.CollectionView.extend Tevye.Sortable,
  createChildView: (viewClass, attrs) ->
    @_super Tevye.CustomFieldEditView, merge(attrs,
      customField: attrs.content)

Tevye.CustomFieldEditView = Em.ContainerView.extend Tevye.SortableItem,
  classNames: ["panel"]
  classNameBindings: ['fieldClass']
  fieldClass: (->
    "#{@get('content.name').replace('_','-')}-field-panel"
  ).property('content.name')
  childAttrs: (->
    contentType: @get("contentType")
    content: @get("content")
  ).property("customField", "contentType")
  typeView: (->
    fieldEditView = Tevye.ContentType.fieldTypes[@get("content.type")]
    foundView = if isBlank(fieldEditView)
        Em.View.extend(template: Em.Handlebars.compile(""))
      else Em.get(fieldEditView)
    childView = foundView.extend(@get("childAttrs"))
    childView
  ).property("childAttrs")
  baseView: (->
    Tevye.CustomFieldBaseEditView.extend @get("childAttrs")
  ).property("childAttrs")
  childViews: ["baseView", "typeView"]

Tevye.CustomFieldBaseEditView = Em.View.extend
  templateName: "fields/edit"

Tevye.CustomFieldTypeEditView = Em.View.extend
  templateName: (->
    "fields/edit/#{@get('content.type')}"
  ).property("content")

Tevye.TextFieldEditView = Tevye.CustomFieldTypeEditView.extend
  formats: ["html", "plain"]

selectOptions = (options) ->
  [label: "Nothing Selected", value: ''].addObjects options

Tevye.RelationTarget = Em.Mixin.create
  allTypes: (->
    Tevye.ContentType.findAll(site_id: @get("content.contentType.siteId"))
  ).property()
  inverseSelectOptions: (->
    types   = @get("allTypes")
    type    = types.find (type) =>
      type.get("id") is @get("content.target_type_id")
    options =
      if isPresent type
        targetFields = type.get("entriesCustomFields").filter (field) =>
          @get("allowedTargets").contains field.get("type")
        targetFields.map (field) ->
          label: field.get("label")
          value: field.get("name")
      else []
    selectOptions options
  ).property("allTypes.@each", "content.target_type_id")
  typeSelectOptions: (->
    types   = @get("allTypes")
    selectOptions types.map (type) ->
      value: type.get("id")
      label: type.get("name")
  ).property("allTypes.@each")

Tevye.ManyToManyFieldEditView = Tevye.CustomFieldTypeEditView.extend Tevye.RelationTarget,
  allowedTargets: ["many_to_many"]

Tevye.HasManyFieldEditView = Tevye.CustomFieldTypeEditView.extend Tevye.RelationTarget,
  allowedTargets: ["belongs_to"]

Tevye.BelongsToFieldEditView = Tevye.CustomFieldTypeEditView.extend Tevye.RelationTarget,
  allowedTargets: ["has_many"]

Tevye.NewOptionTextField = Tevye.TextField.extend
  insertNewline: (e) ->
    locale       = @get('controller.locale')
    name         = {}
    name[locale] = @get("value")
    options      = @get("parentView.content.select_options")
    updated      = options.addObject(name: name)
    @set("parentView.content.select_options", updated)
    @set("parentView.isAdding", false)

Tevye.SelectFieldEditView = Tevye.CustomFieldTypeEditView.extend
  id: (->
    name = @get('content.name')
    "#{name}-options"
  ).property('content.name')
  translatedOptions: (->
    locale = @get('controller.locale')
    options = @get('content.select_options')
    _.map options, (option) ->
      label: option.name[locale]
      value: option.id
  ).property('content.select_options.@each')
  addButtonClass: (->
    'btn add-option ' + unless @get('isAdding')
      'btn-success'
    else 'btn-danger'
  ).property('isAdding')
  addButtonIconClass: (->
    'glyphicon ' + unless @get('isAdding')
      'glyphicon-ok-sign'
    else 'glyphicon-remove-circle'
  ).property('isAdding')
  isAdding: false
  toggleAdding: -> @set("isAdding", not @get("isAdding"))
  removeOption: (id) ->
    options = @get("content.select_options").filter (x) ->
      x.id isnt id
    @set('content.select_options', options)

Tevye.ContentEntryFormView = Em.View.extend
  classNames: ["custom", "form"]
  templateName: "content_entry/form"

Tevye.ContentEntryAttributesView = Em.CollectionView.extend
  contentBinding: "contentType.entriesCustomFields"
  createChildView: (viewClass, attrs) ->
    typeName = Tevye.ContentType.fieldValueTypes[attrs.content.get('type')]
    foundView = if isBlank(typeName) then null else Em.get(typeName)
    retView = (foundView or Tevye.CustomFieldValueView).extend
      contentType: @get("contentType")
      contentEntry: @get("contentEntry")
      customField: attrs.content
    @_super retView, attrs

Tevye.CustomFieldValueView = Em.View.extend
  templateName: (->
    type = @get "customField.type"
    "fields/values/#{type}"
  ).property("customField")
  valueSuffix: ""
  valuePath: (->
    type = @get('customField.type')
    name = switch
      when /has_many|many_to_many/.test type
        _.singularize @get('customField.name').camelize()
      else @get('customField.name').camelize()
    suffix = @get('valueSuffix')
    "contentEntry.#{name}#{suffix}"
  ).property("contentEntry", "contentType", "customField")
  value: (->
    @get @get('valuePath')
  ).property('valuePath')

Tevye.FileValueView = Tevye.CustomFieldValueView.extend
  srcUrl: 'http://placehold.it/350x150'
  valueObserver: (->
    value = @get('value')
    switch
      when isFile value
        reader = new FileReader()
        reader.onload = (e) =>
          @set 'srcUrl', e.target.result
        reader.readAsDataURL value
      when isString value
        @set 'srcUrl', value
  ).observes('value')

Tevye.TextValueView = Tevye.CustomFieldValueView.extend()

cancel = (e) ->
  e.stopPropagation()
  e.preventDefault()
  e

Tevye.FileDrop = Em.View.extend
  fileDrop: 'file-drop'
  classNameBindings: ['fileDrop', 'active']
  active: (->
    if @get('isHover') then 'active' else ''
  ).property('isHover')
  dragEnter: cancel
  dragLeave: cancel.andThen (e) ->
    @set 'isHover', false
  templateName: 'controls/file'
  dragOver: cancel.andThen (e) ->
    @set 'isHover', true
  drop: cancel.andThen (e) ->
    @set 'isHover', false
    files = e.dataTransfer.files
    if files and files.length > 0
      @set 'parentView.value', files[0]

Tevye.StringValueView = Tevye.CustomFieldValueView.extend()
Tevye.DateValueView = Tevye.CustomFieldValueView.extend()
Tevye.RelationView = Tevye.CustomFieldValueView.extend
  associatedTypeEntriesBinding: "associatedType.entries"
  associatedType: (->
    Tevye.ContentType.find @get("customField.target_type_id"),
      site_id: @get("contentType.siteId")
  ).property()

associatedEntries = (->
  associated = @get("value")
  entries = @get("associatedTypeEntries")
  entries.filter (x) -> associated.contains x.get("id")
).property("associatedTypeEntries.@each", "value.@each")

availableEntries = (->
  used = @get("value")
  entries = @get("associatedTypeEntries")
  entries.filter (x) -> not used.contains x.get('id')
).property('associatedTypeEntries.@each', 'value.@each')

Tevye.ManyRelationView = Tevye.RelationView.extend
  valueSuffix: "Ids"
  associatedEntries: associatedEntries
  availableEntries: availableEntries
  deleteRelation: (entry) ->
    ids = @get('value')
    index = ids.indexOf entry.get('id')
    ids.removeAt index if index >= 0
  addRelation: ->
    selectView = @get("childViews.firstObject")
    selectView._change()
    selection = selectView.get("selection")
    @get('value').addObject(selection.id)

Tevye.ManyToManyValueView = Tevye.ManyRelationView.extend()
Tevye.HasManyValueView = Tevye.ManyRelationView.extend()

Tevye.BelongsToSelect = Em.Select.extend
  associatedTypeEntriesObserver: (->
    Em.run.next =>
      value = @get('parentView.value')
      @$().val(value) if @$("option[value='#{value}']").length > 0
  ).observes("parentView.associatedTypeEntries.@each")
  change: -> @set 'parentView.value', @get('value')

Tevye.BelongsToValueView = Tevye.RelationView.extend
  valueSuffix: "Id"
  associatedEntry: (->
    entry = @get('associatedTypeEntries').find (x) => x.get('id') is @get("value")
    if isPresent(entry) then entry
    else Em.Object.create(value: null)
  ).property("associatedTypeEntries.@each", "value")
  selectOptions: (->
    entries = @get("associatedTypeEntries")
    selectOptions entries.map (entry) ->
      label: entry.get("label")
      value: entry.get("id")
  ).property("associatedTypeEntries.@each")

Tevye.SelectValueSelect = Em.Select.extend
  didInsertElement: ->
    value = @get('parentView.value')
    @$().val(value) if @$("option[value='#{value}']").length > 0
  change: ->
    path = @get('parentView.valuePath')
    @set "parentView.#{path}", @get('value')
    @set 'parentView.value', @get('value')

Tevye.SelectValueView = Tevye.CustomFieldValueView.extend
  selectOptions: (->
    locale = @get('controller.locale')
    options = @get("customField.select_options")
    selectOptions options.map (option) ->
      label: option.name[locale]
      value: option.id
  ).property("customField.select_options")

Tevye.BooleanValueView = Tevye.CustomFieldValueView.extend
  offValue: (->
    not @get("value")
  ).property("value")
  onValue: (->
    @get "value"
  ).property("value")
  unsetValue: -> @set("value", false)
  setValue: -> @set("value", false)

Tevye.CodeView = Em.View.extend Tevye.CreatableTypeView,
  resourceClass: (->
    @get('resource')
  ).property('resource')
  showAssetSelect: true
  showAssetSelectLabel: true
  toggleLabelSelect: -> @set('showAssetSelectLabel', not @get('showAssetSelectLabel'))
  createItem: (value) ->
    controller = @get('controller')
    controller.createItem(name: value)
  destroySelected: ->
    id = @get('selectedAsset.id')
    controller = @get('controller')
    controller.destroyItem(id)
  showCreateDelete: true
  classNames: ["code-text-area"]
  templateName: "components/code"
  valueBinding: null
  modeBinding: null
  inserted: false
  mirror: null
  updateAsset: Em.K
  didInsertElement: ->
    return if @get('inserted') or isBlank(@$())
    @set('inserted', true)
    codeMirror = CodeMirror (el) =>
      $(el).appendTo @$('.mirror')
    ,
      value: @get('value') or ''
      mode: @get('mode')
      extraKeys:
        "Cmd-S": (e) =>
          Em.run =>
            @set('value', @get("mirror").doc.getValue())
            @set('controller.needsReload', true)
          @updateAsset(e)
    @set('mirror', codeMirror)
    @_super()
  showErrors: (->
    false
  ).property('errors')
  modeObserver: (->
    mirror     = @get('mirror')
    return if isBlank(mirror)
    mode       = @get('mode')
    mirror.setOption('mode', mode)
  ).observes('mode', 'mirror')
  valueObserver: (->
    mirror     = @get("mirror")
    return if isBlank(mirror)
    value      = @get("value") or ""
    mirror.doc.setValue(value)
  ).observes('value', 'mirror')
  willDestroyElement: ->
    mirror = @get("mirror")
    $(mirror.display.wrapper).remove() if isPresent(mirror)
    @_super()

Tevye.PageDrag = Ember.Mixin.create
  attributeBindings: "draggable"
  dragUp: (event) ->
    jQuery(document).unbind('mousemove')
    jQuery(document).unbind('mouseup')
    @set('isDragging', false) if @get('isDragging')
    @set('isDown', false) if @get('isDown')
    if isPresent(@$dragShadow)
      @$dragShadow.remove()
      @$dragShadow = null
  dragMove: (event) ->
    root = @rootView()
    return unless get(root, 'isDown')
    unless get(root, 'isDragging')
      @$dragShadow = @$().clone()
      @$dragShadow.css
        position: 'fixed'
        opacity: 0.5
      @$dragShadow.appendTo(@get('parentView').$())
      set(root, 'isDragging', true)
      set(root, 'dragPage', @get('content'))
    @$dragShadow.css('top', event.originalEvent.clientY)
    @$dragShadow.css('left', event.originalEvent.clientX + 30)
  mouseDown: (event) ->
    event.preventDefault()
    return if event.target?.tagName?.toLowerCase() is 'i'
    root = @rootView()
    unless get(root, 'isDown')
      set(root, 'isDown', true)
      jQuery(document).on('mousemove', jQuery.proxy(@dragMove, @))
      jQuery(document).on('mouseup', jQuery.proxy(@dragUp, @))
  dragStart: (event) ->
    rootView = @rootView()
    rootView.set("draggedPageId", @get("content.id"))
    rootView.set("draggedSiteId", @get("content.siteId"))
    event.stopImmediatePropagation()

Tevye.PageDrop = Ember.Mixin.create
  mouseUp: (event) ->
    root = @rootView()
    return unless get(root, 'isDown')
    set(root, 'isDown', false)
    return unless get(root, 'isDragging')
    set(root, 'isDragging', false)
    dragPage = root.get('dragPage')
    newParent = @get('content')
    return if dragPage.get('id') is newParent.get('id')
    @get('controller').reparent(dragPage, newParent)
    set(root, 'dragPage', null)

Tevye.NavigationView = Em.View.extend Tevye.CreatableTypeView,
  templateName: "components/navigation"

Tevye.ContentEntriesListView = Em.View.extend Tevye.CreatableTypeView,
  templateName: "content_entries/list"

Tevye.ContentTypesListView = Em.View.extend Tevye.CreatableTypeView,
  templateName: "content_types/list"

Tevye.ListItemView = Em.View.extend
  tagName: "li"
  select: ->
    controller = @get('parentView.controller')
    controller.set('selected', @get('content'))
  classNameBindings: ['selectedClass']
  selectedClass: (->
    selected = @get('parentView.controller.selected')
    current = @get('content')
    if selected is current then 'selected' else ''
  ).property('parentView.controller.selected')

Tevye.CollectionView = Ember.CollectionView.extend
  tagName: 'ul'
  classNames: ['nav', 'nav-pills', 'nav-stacked']
  itemViewClass: Tevye.ListItemView

Tevye.ContentEntryCollectionView = Tevye.CollectionView.extend()
Tevye.ContentTypeCollectionView = Tevye.CollectionView.extend()
Tevye.NewObjectTextField = Tevye.TextField.extend
  nameBinding: 'textFieldName'
  textFieldName: (->
    "new-#{@get('parentView.resourceClass')}-name"
  ).property('parentView.resourceClass')
  insertNewline: (e) ->
    @get('parentView').createItem(@get('value'))
    @set('parentView.isCreating', false)

Tevye.PagesListView = Em.View.extend Tevye.CreatableTypeView,
  templateName: 'pages/list'
  classNames: ['pages-list']

Tevye.PagesNodeView = Em.View.extend Tevye.PageDrag, Tevye.PageDrop,
  tagName: 'li'
  classNames: ['page']
  classNameBindings: ['nodeTypeClass', 'nodeDepth']
  nodeDepth: (->
    "depth-#{@get('content.depth')}"
  ).property('content.depth')
  nodeTypeClass: (->
    if isBlank @get('rootPage') then 'child' else 'root'
  ).property('rootPage')
  openList: (event) ->
    @set('open', not @get('open'))
  open: false
  childrenClass: (->
    "children #{if @get('open') then '' else 'hide'}"
  ).property('open')
  childPages: (->
    @get('content.children')
  ).property('content.children', 'content.childIds.@each')
  hasChildren: (->
    @get('content.childIds').length > 0
  ).property('content.children', 'content.childIds.@each')
  iconClass: (->
    icon = if @get("open") then 'glyphicon-minus-sign' else 'glyphicon-plus-sign'
    "glyphicon #{icon}"
  ).property('open')
  rootView: ->
    if @get('rootPage') then @
    else @nearestWithProperty('rootPage')
  init: ->
    rootView = unless isBlank(@get('rootPage'))
        @get('parentView')
      else
        @rootView()
    @set('template', get(rootView, 'template'))
    @set('elementId', @get('content.slug'))
    @_super()

Tevye.PagesTreeView = Em.CollectionView.extend
  classNameBindings: ['rootTreeBinding']
  root: true
  rootTreeBinding: (->
    if @get('root') then 'nav nav-pills nav-stacked'
    else 'page-node'
  ).property()
  tagName: 'ul'
  itemViewClass: Tevye.PagesNodeView.extend(rootPage: true)

Tevye.PagesTreeChildrenView = Tevye.PagesTreeView.extend
  root: false
  itemViewClass: Tevye.PagesNodeView.extend()

Tevye.AssetSelect = Em.Select.extend
  optionValuePath: "content.id"
  optionLabelPath: "content.url"
  focusOut: -> @set('parentView.showAssetSelectLabel', true)
  change: ->
    selected = @get('parentView.assets').find (x) =>
      x.get('id') is @get('value')
    @set('parentView.selectedAsset', selected)

updateAsset = (e) ->
  asset      = @get('selectedAsset')
  controller = @get('controller')
  controller.updateAsset(asset, source: asset.get('originalSource'))

Tevye.CodePane = Tevye.ResizableView.extend
  orientation: "vertical"
  direction: "bottom"
  childViews: ["stylesheetView", "javascriptView", "templateView"]
  stylesheetView: (->
    viewKlass = Tevye.CodeView.extend
      classNames: ['stylesheet-mirror']
      resource: 'stylesheet'
      assetsControllerBinding: 'controller.controllers.themeAssets'
      assetsBinding: "assetsController.stylesheets"
      selectedAssetBinding: "assetsController.selectedStylesheet"
      modeBinding: "assetsController.selectedStylesheet.mode"
      errorsBinding: "assetsController.selectedStylesheet.errors"
      valueBinding: "assetsController.selectedStylesheet.originalSource"
      updateAsset: updateAsset
    viewKlass.create()
  ).property()
  javascriptView: (->
    viewKlass = Tevye.CodeView.extend
      classNames: ['javascript-mirror']
      resource: 'javascript'
      assetsControllerBinding: 'controller.controllers.themeAssets'
      assetsBinding: "assetsController.javascripts"
      selectedAssetBinding: "assetsController.selectedJavascript"
      modeBinding: "assetsController.selectedJavascript.mode"
      errorsBinding: "assetsController.selectedJavascript.errors"
      valueBinding: "assetsController.selectedJavascript.originalSource"
      updateAsset: updateAsset
    viewKlass.create()
  ).property()
  templateView: (->
    viewKlass = Tevye.CodeView.extend
      classNames: ['template', 'template-mirror']
      showAssetSelect: false
      showCreateDelete: false
      errorsBinding: 'controller.errors'
      mode: "htmlembedded"
      valueBinding: "controller.content.rawTemplate"
      updateAsset: (e) ->
        @get('pageController').update rawTemplate: @get('value')
    viewKlass.create()
  ).property()

Tevye.ImageClearing = Em.View.extend
  templateName: 'components/image_clearing'
  classNames: ["clearing-thumbs"]
  tagName: "ul"
  contentObserver: (->
    Foundation.libs.clearing.init(@get('parentView').$()[0])
    @$('img:first').trigger('click.fndtn.clearing')
  ).observes('content', 'content.@each')

Tevye.ModelView = Em.View.extend
  classNameBindings: ['typeName']
  typeName: (->
    name = @get('controller.resourceName')
    name = _.pluralize(name) if @get('controller.plural')
    ["#{name}-view"]
  ).property('controller.content')

Tevye.ApplicationView = Tevye.ModelView.extend
  typeName: 'application-view'

Tevye.ContentEntryView = Tevye.ModelView.extend()
Tevye.ContentEntriesView = Tevye.ModelView.extend()
Tevye.ContentEntryIndexView = Tevye.ModelView.extend()
Tevye.ContentEntriesIndexView = Tevye.ModelView.extend()
Tevye.ContentTypeView = Tevye.ModelView.extend()
Tevye.ContentTypesView = Tevye.ModelView.extend()
Tevye.SitesView = Tevye.ModelView.extend()
Tevye.SiteView = Tevye.ModelView.extend()
Tevye.PageView = Tevye.ModelView.extend()
Tevye.ContentTypesIndexView = Tevye.ModelView.extend()
Tevye.ContentTypeIndexView = Tevye.ModelView.extend()
