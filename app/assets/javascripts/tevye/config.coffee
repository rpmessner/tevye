argsToArray = (args) ->
  Array::slice.call args, 0
Tevye.reopen
  isBlank: (val) -> val is undefined or val is null
  isPresent: (val) -> !Tevye.isBlank(val)
  merge: -> # don't modify first argument, return new hash
    args = argsToArray(arguments)
    args.unshift({})
    _.merge.apply(null, args)

jQuery.event.fixHooks.drop =
  props: ['pageX', 'pageY', 'clientX', 'clientY', 'dataTransfer']

Function::andThen = (argFunction) ->
  invokingFunction = @
  -> argFunction.call @, invokingFunction.apply(@, arguments)
Function::compose = (argFunction) ->
  invokingFunction = @
  -> invokingFunction.call @, argFunction.apply(@, arguments)

# TODO number prefixes
( ->
  # Really primitive kill-ring implementation.
  killRing = []
  addToRing = (str) ->
    killRing.push(str)
    killRing.shift() if killRing.length > 50
  getFromRing = -> killRing[killRing.length - 1] || ""
  popFromRing = ->
    killRing.pop() if killRing.length > 1
    getFromRing()
  # CodeMirror.keyMap.revEmacs =
  #   "Ctrl-X": (cm) -> cm.setOption("keyMap", "emacs-Ctrl-X")
  #   "Ctrl-W": (cm) -> addToRing cm.getSelection(); cm.replaceSelection("")
  #   "Ctrl-Alt-W": (cm) -> addToRing(cm.getSelection()); cm.replaceSelection("")
  #   "Alt-W": (cm) -> addToRing(cm.getSelection()
  #   "Ctrl-Y": (cm) -> cm.replaceSelection(getFromRing())
  #   "Alt-Y": (cm) -> cm.replaceSelection(popFromRing())
  #   "Ctrl-/": "undo", "Shift-Ctrl--": "undo", "Shift-Alt-,": "goDocStart", "Shift-Alt-.": "goDocEnd",
  #   "Ctrl-S": "findNext", "Ctrl-R": "findPrev", "Ctrl-G": "clearSearch", "Shift-Alt-5": "replace",
  #   "Ctrl-Z": "undo", "Cmd-Z": "undo", "Alt-/": "autocomplete", "Alt-V": "goPageUp",
  #   "Ctrl-J": "newlineAndIndent", "Enter": false, "Tab": "indentAuto",
  #   fallthrough: ["basic", "emacsy"]

  # CodeMirror.keyMap["emacs-Ctrl-X"] =
  #   "Ctrl-S": "save", "Ctrl-W": "save", "S": "saveAll", "F": "open", "U": "undo", "K": "close",
  #   auto: "emacs", nofallthrough: true
)()
