# describe "Rev.SwitchView", ->
#   switchView = undefined
#   context = undefined
#   async = new AsyncSpec(this)
#   beforeEach ->
#     runs ->
#       context = Em.Object.create(
#         slug: "hi"
#         boolValue: false
#       )
#       switchView = Rev.SwitchView.create(
#         valueBinding: "content.boolValue"
#         content: context
#       )

#     waits 10

#   # afterEach ->
#   #   switchView.destroy()
#   #   switchView = null

#   # it "should be created", ->
#   #   expect(switchView).toBeDefined()

#   describe "rendering", ->
#     beforeEach ->
#       Ember.run ->
#         switchView.append()


#     async.it "should reset value when switched", (done) ->
#       waitForRender ->
#         click switchView.$("#" + switchView.get("onId"))
#         expect(context.get("boolValue")).toBeTruthy()
#         click switchView.$("#" + switchView.get("offId"))
#         expect(context.get("boolValue")).toBeFalsy()
#         done()



