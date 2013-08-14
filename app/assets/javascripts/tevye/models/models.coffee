reject     = _.reject
assert     = Em.assert
isEmpty    = Em.isEmpty
isArray    = _.isArray
isString   = _.isString
isObject   = _.isObject
isFunc     = _.isFunction
isNumber   = _.isNumber
each       = _.each
first      = _.first
promiseKey = "_promise"
errorsKey  = "_errors"
merge      = Tevye.merge
isBlank    = Tevye.isBlank
isPresent  = Tevye.isPresent
Promise    = RSVP.Promise # old api
modelCache = {}
singularize = (value) ->
  _(value).singularize().value()
parseErrors = (response) ->
  JSON.parse(response.responseText).errors
compact = (array) ->
  array.compact().subtract `undefined`

resource = (modelklass) ->
  assert(isString(modelklass.resources),
    modelklass.toString() + " has no property: resources")
  singularize(modelklass.resources)

setProperties = (attrs, model) ->
  assert(isObject(attrs), "attrs must be a valid object")
  Ember.run ->
    each attrs, (value, key) ->
      if isArray(value) and value.length > 0 and isObject(first value)
        value = Tevye.Collection.create({
          content: value.map (x) ->
            Em.Object.create x
        })
      model.set(key.camelize(), value)
  model

urlParams = (attributes) ->
  return "" if isBlank(attributes) or isEmpty(attributes)
  ret = []
  keys = _.keys(attributes).sort()
  keys.forEach (key) ->
    value = attributes[key]
    ret.push("#{key.underscore()}=#{value}")
  if ret.length > 0 then "?#{ret.join('&')}"  else ""

endpoint = "/tevye"
serverUrl = (route) -> "#{endpoint}/#{route}"

ajax = (model, type, attributes, options) ->
  promise                     = new Promise()
  route                       = serverUrl(model.resources)
  serverData                  = {}
  serverData[resource(model)] =
    if type is 'PUT' then _.omit(attributes, 'id')
    else attributes
  unless isEmpty(attributes.id)
    route += "/#{attributes.id}"
  jQuery.ajax
    url: route + urlParams(options)
    data: serverData
    dataType: "json"
    type: type
    success: (json) -> promise.resolve(json)
    error: (json) -> promise.reject(json)
  promise

findCached = (klass, id, options) ->
  (allCache(klass, options) or Em.A()).find (item) ->
    item.get("id") is id

cacheKey = (klass, options) ->
  key = klass.toString()
  params = urlParams(options)
  key += params unless isEmpty(params)
  key

createAll = (klass, options) ->
  if isBlank(allCache(klass, options))
    modelCache[cacheKey(klass, options)] = Tevye.Collection.create
      content: Em.A()

allCache = (klass, options) ->
  modelCache[cacheKey(klass, options)]

addToAll = (klass, model, options) ->
  createAll(klass, options)
  cache = allCache(klass, options)
  cached = findCached(klass, model.get("id"), options)
  newId = model.get("id")
  allCache(klass, options).addObject model if isEmpty(cached)

getAll = (klass, options) ->
  createAll(klass, options)
  allCache(klass, options)

underscoreProperties = (object) ->
  ret = {}
  each object, (value, key) ->
    ret[key.underscore()] = value
  ret

getAssociatedIds = (model, idFields) ->
  ids = []
  if isArray(idFields)
    idFields.each (name) ->
      ids = compact(ids.add(model.get(name))).unique()
  else
    ids = model.get(idFields)
  ids

associationOptions = (model, modelKlass, requiredParam) ->
  options = {}
  if isString(requiredParam)
    resourceName = requiredParam.underscore()
    options[resourceName] = model.get(requiredParam)
  else if isArray(requiredParam)
    requiredParam.forEach (field) ->
      options[field.underscore()] = model.get(field)
  else if model.constructor is modelKlass
    options = model.get("options")
  options

belongsToOptions = associationOptions
hasManyOptions = associationOptions

hasMany = (klassName, opts) ->
  assert isPresent(opts.keyField), "must supply a key field"
  (->
    modelKlass = Em.get(klassName)
    ids        = getAssociatedIds(@, opts.keyField)
    options    = hasManyOptions(@, modelKlass, opts.requiredParam)
    ret        = Tevye.Collection.create(content: Em.A())
    collection = modelKlass.findAll(options)
    unless collection.isPromising()
      cachedIds = collection.map (item) -> item.get("id")
      if _.difference(ids, cachedIds).length > 0
        collection = modelKlass.fetchAll(options)
    promise = new Promise()
    ret.set(promiseKey, promise)

    collection.then (items) =>
      related = items.filter (item) ->
        ids.contains item.get("id")
      ret.addObjects(related)
      ret.set(promiseKey, null)
      promise.resolve(ret)
    , (error) ->
      ret.set(promiseKey, null)
      promise.reject(error)
    ret
  ).property(opts.keyField, "#{opts.keyField}.@each")

belongsTo = (klassName, opts) ->
  assert(isPresent(opts.keyField), "must supply a key field")
  (->
    modelKlass = Em.get(klassName)
    options    = belongsToOptions(this, modelKlass, opts.requiredParam)
    modelKlass.find(@get(opts.keyField), options)
  ).property(opts.keyField)

immediatePromise = (resolveVal) ->
  promise = new Promise()
  setZeroTimeout ->
    unless resolveVal.isError()
      promise.resolve(resolveVal)
    else
      promise.reject(resolveVal.get(errorsKey))
  promise

modelSuccess = (model, response, promise) ->
  setProperties(response[resource(model.constructor)], model)
  model.set(promiseKey, null)
  promise.resolve(model)

modelError = (model, response, promise) ->
  try
    error = JSON.parse(response.responseText)
  catch e
    error = message: response.responseText
  model.set(errorsKey, error or id: "Not Found")
  model.set(promiseKey, null)
  promise.reject(error)

isPromising = ->
  isPresent(@get(promiseKey))

getPromise = ->
  promise = @get(promiseKey)
  promise = immediatePromise(this) unless @isPromising()
  promise

Tevye.Collection = Em.ArrayProxy.extend Em.SortableMixin,
  isError: -> false
  promise: getPromise
  isPromising: isPromising
  sortProperties: ["position"]
  sortAscending: true
  then: (success, error) ->
    @promise().then(success, error)

Tevye.Model = Ember.Object.extend
  isError: ->
    not isBlank(@get(errorsKey))
  then: (success, error) ->
    @promise().then(success, error)
  errors: (->
    if isPresent(@get(errorsKey))
      ret = Em.Object.create()
      attribute_errors = @get(errorsKey).errors
      ret.set(key, value) for key, value of attribute_errors
      ret
    else
      null
  ).property(errorsKey)
  promise: getPromise
  isPromising: isPromising
  options: (-> {}).property()
  destroyModel: (options) ->
    id = @get("id")
    ajax(@constructor, "DELETE", id: id, options).then =>
      @destroy()
  update: (attributes, options) ->
    underscored     = underscoreProperties(attributes)
    underscoredOpts = underscoreProperties(options or {})
    finalOpts       = merge(id: @get("id"), underscoredOpts)
    data            = merge(finalOpts, underscored)
    promise         = new Promise()
    @set(promiseKey, promise)
    ajax(@constructor, "PUT", data, options).then (json) =>
      modelSuccess(@, json, promise)
    , (errors) =>
      modelError(@, errors, promise)
    @

Tevye.Model.reopenClass
  clearCache: (options) ->
    if @ is Tevye.Model
      modelCache = {}
    else
      delete modelCache[cacheKey(@, options)]
  findAll: (options) ->
    allCache(@, options) or @fetchAll(options)
  fetchAll: (options) ->
    self    = @
    data    = options or {}
    promise = new Promise()
    all     = getAll(@, options)
    all.set(promiseKey, promise)
    PreloadStore.get(@resources + urlParams(options), ->
      jQuery.getJSON(serverUrl(self.resources), data)
    ).then (records) ->
      records[self.resources].forEach (record) ->
        model = self.create(id: record.id, options)
        setProperties(record, model)
        addToAll(self, model, options)
      all.set(promiseKey, null)
      promise.resolve(all)
    , (error) ->
      all.set(promiseKey, null)
      promise.reject(error)
    all

  find: (id, options) ->
    assert(not isEmpty(id), "id parameter cannot be empty")
    found = null
    unless isEmpty(allCache(this, options))
      found = first allCache(this, options).filter((entry) ->
        entry.get("id") is id
      )
    found or @fetch(id, options)

  fetch: (id, options) ->
    assert(not isEmpty(id), "id parameter cannot be empty")
    assert(isNumber(id), "id parameter must be a number")
    model   = @create(id: id, options)
    data    = options or {}
    promise = new Promise()
    model.set promiseKey, promise
    jQuery.getJSON(serverUrl("#{@resources}/#{id}"), data).then (json) ->
      modelSuccess(model, json, promise)
    , (errors) ->
      modelError(model, errors, promise)
    addToAll(@, model, options)
    model

  create: (attributes, options) ->
    assert(not isBlank(@resources), "Models require a resource")
    unless isEmpty(attributes.id)
      model = findCached(@, attributes.id, options)
      if isBlank(model)
        attrs = id: attributes.id
        attrs["#{singularize(@resources).camelize()}Id"] = attributes.id
        model = @_super(attrs)
      return setProperties(attributes, model)
    promise = new Promise()
    model = @_super()
    model.set(promiseKey, promise)
    ajax(@, "POST", attributes, options).then (json) ->
      modelSuccess(model, json, promise)
    , (errors) ->
      modelError(model, errors, promise)
    addToAll(this, model, options)
    model

Tevye.Site = Tevye.Model.extend
  pages: hasMany("Tevye.Page",
    keyField: "pageIds",
    requiredParam: "siteId")
  contentTypes: hasMany("Tevye.ContentType",
    keyField: "contentTypeIds",
    requiredParam: "siteId")
  themeAssets: hasMany("Tevye.ThemeAsset",
    keyField: "themeAssetIds",
    requiredParam: "siteId")
  images: (->
    assets = @get("themeAssets")
    images = Tevye.Collection.create(content: Em.A())
    assets.then (allAssets) ->
      allAssets.forEach (asset) ->
        if asset.get("folder") is "images"
          images.addObject(asset)
    images
  ).property("themeAssetIds")

Tevye.Site.reopenClass(resources: "sites")
translation = (name) ->
  property = "#{name}Translations"
  (->
    (@get(property) || {})[@get('locale')]
  ).property('locale', property)

Tevye.Page = Tevye.Model.extend
  locale: 'en'
  slug: translation('slug')
  title: translation('title')
  rawTemplate: translation('rawTemplate')
  url: (->
   @get('fullpath').replace('index', '')
  ).property('fullpath')
  options: (->
    site_id: @get("siteId")
  ).property()
  children: hasMany("Tevye.Page",
    keyField: "childIds"
    requiredParam: "siteId")
  parent: belongsTo("Tevye.Page",
    keyField: "parentId"
    requiredParam: "siteId")
  site: belongsTo("Tevye.Site",
    keyField: "siteId")

Tevye.Page.reopenClass(resources: "pages")

Tevye.CustomField = Em.Object.extend
  isLabel: (->
    @get('contentType.labelField') is @get('name')
  ).property('contentType.label')

Tevye.ContentType = Tevye.Model.extend
  options: (->
    site_id: @get("siteId")
  ).property()
  site: belongsTo("Tevye.Site", keyField: "siteId")
  fields: (->
    Tevye.Collection.create
      content: @get('entriesCustomFields').map (x) =>
        Tevye.CustomField.create(merge(x, contentType: @))
  ).property('entriesCustomFields.@each')
  entries: hasMany("Tevye.ContentEntry",
    keyField: "entryIds",
    requiredParam: ["contentTypeId", "siteId"])

Tevye.ContentType.reopenClass
  resources: "content_types"
  fieldTypes:
    text: "Tevye.TextFieldEditView"
    select: "Tevye.SelectFieldEditView"
    has_many: "Tevye.HasManyFieldEditView"
    belongs_to: "Tevye.BelongsToFieldEditView"
    many_to_many: "Tevye.ManyToManyFieldEditView"
  fieldValueTypes:
    text: "Tevye.TextValueView"
    date: "Tevye.DateValueView"
    file: "Tevye.FileValueView"
    string: "Tevye.StringValueView"
    select: "Tevye.SelectValueView"
    boolean: "Tevye.BooleanValueView"
    has_many: "Tevye.HasManyValueView"
    belongs_to: "Tevye.BelongsToValueView"
    many_to_many: "Tevye.ManyToManyValueView"


Tevye.ContentEntry = Tevye.Model.extend
  options: (->
    content_type_id: @get("contentTypeId")
    site_id: @get("siteId")
  ).property()
  site: belongsTo("Tevye.Site",
    keyField: "siteId")
  contentType: belongsTo("Tevye.ContentType",
    keyField: "contentTypeId",
    requiredParam: "siteId")

Tevye.ContentEntry.reopenClass(resources: "content_entries")

Tevye.ThemeAsset = Tevye.Model.extend
  options: (->
    site_id: @get("siteId")
  ).property()
  pages: hasMany("Tevye.Page", keyField: "pageIds", requiredParam: "siteId")
  site: belongsTo("Tevye.Site", keyField: "siteId")

Tevye.ThemeAsset.reopenClass(resources: "theme_assets")
