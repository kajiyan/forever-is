do (window=window, document=document, $=jQuery) ->
  ns = $.TypeFrameWork = {}
  ns.support = {}

  ns.support.addEventListener = "addEventListener" of document

  $window = $(window)
  $document = $(document)

  FLT_EPSILON = 0.0000001192092896
  
  KEY_CHARS = []
  KEY_CHARS[27] = "Esc"
  KEY_CHARS[8] = "BackSpace"
  KEY_CHARS[9] = "Tab"
  KEY_CHARS[32] = "Space"
  KEY_CHARS[45] = "Insert"
  KEY_CHARS[46] = "Delete"
  KEY_CHARS[35] = "End"
  KEY_CHARS[36] = "Home"
  KEY_CHARS[33] = "PageUp"
  KEY_CHARS[34] = "PageDown"
  KEY_CHARS[38] = "up"
  KEY_CHARS[40] = "down"
  KEY_CHARS[37] = "left"
  KEY_CHARS[39] = "right"

  # ============================================================
  # EventFrame
  # ============================================================
  class ns.Event
    constructor: ->
      @_callbacks = {}

    on: (ev, callback) ->
      evs = ev.split(' ')
      for name in evs
        @_callbacks[name] or= []
        @_callbacks[name].push(callback)
      @

    one: (ev, callback) ->
      @on ev, ->
        @off(ev, arguments.callee)
        callback.apply(@, arguments)

    trigger: (args...) ->
      ev = args.shift()
      list = @_callbacks?[ev]
      return unless list
      for callback in list
        if callback.apply(@, args) is false
          break
      @

    off: (ev, callback) ->
      unless ev
        @_callbacks = {}
        return @

      list = @_callbacks?[ev]
      return this unless list

      unless callback
        delete @_callbacks[ev]
        return this

      for cb, i in list when cb is callback
        list = list.slice()
        list.splice(i, 1)
        @_callbacks[ev] = list
        break
      @

    bind: -> @on.apply @, arguments
    unbind: -> @off.apply @, arguments

  # ============================================================
  # Math
  # ============================================================
  class ns.vec2f
    constructor: (x, y) ->
      @x = x
      @y = y

  # ============================================================
  # typeFrameWork
  # ============================================================
  class ns.TypeFrameWork extends ns.Event
    
    defaults:
      frameRate: 60.0
      resizeInterval: 200

    #--------------------------------------------------------------
    constructor: (options) ->
      @options = $.extend {}, @defaults, options

      window.requestAnimationFrame = do =>
        return window.requestAnimationFrame or window.webkitRequestAnimationFrame or window.mozRequestAnimationFrame or window.oRequestAnimationFrame or window.msRequestAnimationFrame or (callback, fps, element) => window.setTimeout callback, 1000 / @options.frameRate

      window.cancelAnimationFrame = do =>
        return window.cancelAnimationFrame or window.webkitCancelAnimationFrame or window.mozCancelAnimationFrame or window.msCancelAnimationFrame or window.oCancelAnimationFrame or (id) => window.clearTimeout id

      window.getTime = ->
        now = window.perfomance and (perfomance.now or perfomance.webkitNow or perfomance.mozNow or perfomance.msNow or perfomance.oNow)
        return ( now and now.cell perfomance ) or ( new Date().getTime() )

      @updateProcess = null
      @oldFrame = null
      @startTime = window.getTime()

      @els = []

      @_keyPressed = ->
      @_keyReleased = ->
      @_windowResized = ->
      @_windowScroll = ->
      @_orientationChange = $.noop
      @_fullScreenChange = ->

      # $window.on "keydown", @keyPressedProcess
      # $window.on "keyup", @keyReleasedProcess
      $document.on "keydown", @keyPressedProcess
      $document.on "keyup", @keyReleasedProcess
      
      # resize event timer
      @resizeTimer = null;
      $window.on "resize", @windowResizedProcess

      # window scroll event
      $window.on "scroll", @windowScrollProcess

      # randscape change event
      if typeof window.onorientationchange is "object"
        $window.on "orientationchange", @orientationChangeProcess

      $window.on "fullscreenchange webkitfullscreenchange mozfullscreenchange msfullscreenchange", @fullScreenChangeProcess

      if ns.support.addEventListener
        window.addEventListener "devicemotion", @devicemotionProcess

        # window.addEventListener "keypress", @keyPressedProcess
        # window.addEventListener "keyup", @keyReleasedProcess
        # window.addEventListener "resize", @windowResizedProcess

        #if window.DeviceOrientationEvent is true
        #window.addEventListener "devicemotion", @devicemotionProcess

    #--------------------------------------------------------------
    setup: (method = ->) ->
      method()
      return

    #--------------------------------------------------------------
    update: (method = ->) ->
      @lastTime = window.getTime()
      
      currentFrame = Math.floor( (@lastTime-@startTime) / (1000.0/@options.frameRate) % 2 )

      if currentFrame isnt @oldFrame
        method()
        if @_draw?
          @_draw()

      @oldFrame = currentFrame

      @updateProcess = window.requestAnimationFrame =>
        @update method
        return

      return

    #--------------------------------------------------------------
    draw: (method = ->) ->
      @_draw = method
      return


    #--------------------------------------------------------------
    keyPressed: (method = ->) ->
      @_keyPressed = method
      return

    keyPressedProcess: (e) =>
      key = @_keyProcess(e)
      @_keyPressed key
      return

    #--------------------------------------------------------------
    keyReleased: (method = ->) ->
      @_keyReleased = method
      return

    keyReleasedProcess: (e) =>
      key = @_keyProcess(e)
      @_keyReleased key
      return


    #--------------------------------------------------------------
    _keyProcess: (e) =>
      if e isnt null
        keyCode = e.which
        ctrl = if(typeof e.modifiers is 'undefined') then e.ctrlKey else e.modifiers & Event.CONTROL_MASK
        shift = if(typeof e.modifiers is 'undefined') then e.shiftKey else e.modifiers & Event.SHIFT_MASK
        # e.preventDefault()
        # e.stopPropagation()
      else
        keyCode = event.keyCode
        ctrl = event.ctrlKey
        shift = event.shiftKey
        event.returnValue = false
        event.cancelBubble = true

      keyChar = KEY_CHARS[keyCode]

      if !(keyChar?)
        keyChar = String.fromCharCode(keyCode).toUpperCase()

      result =
        "keyCode": keyCode
        "keyChar": keyChar
        "ctrl": ctrl
        "shift": shift

      return result

    #--------------------------------------------------------------
    hover: (method = ->) ->
      method.apply()
      return


    #--------------------------------------------------------------
    setHover: (el, enter, leave) ->
      if not el?
        $.error("Some error TypeFrameWorksetHover() object.");

      if not enter?
        enter = ->

      if not leave?
        leave = ->

      if @type(enter) isnt "function" and @type(leave) isnt "function"
        $.error("Some error TypeFrameWork hover() object.");

      # イベントを定義するオブジェクトを格納
      @els.push el
      el.on
        "mouseenter": (e) -> enter(e, this)
        "mouseleave": (e) -> leave(e, this)

      return


    #--------------------------------------------------------------
    mouseMoved: (method = ->) ->
      method()
      return

    setMouseMoved: (el, method, translate = "page") ->
      if not el? and not method?
        $.error("Some error TypeFrameWork mouseMoved() object.");

      if @type(el) isnt "object" and @type(method) isnt "function"
        $.error("Some error TypeFrameWork mouseMoved() object.");

      @els.push el

      switch translate
        when "page" then el.on "mousemove": (e) -> method(e.pageX, e.pageY)
        when "client" then el.on "mousemove": (e) -> method(e.clientX, e.clientY)
        when "offset" then el.on "mousemove": (e) -> method(e.offsetX, e.offsetY)
        else el.on "mousemove": (e) -> method(e.pageX, e.pageY)

      return


    #--------------------------------------------------------------
    mousePressed: (method = ->) ->
      method()
      return

    setMousePressed: (el, method) ->
      if not el? and not method?
        $.error("Some error TypeFrameWork mousePressed() object.");

      if @type(el) isnt "object" and @type(method) isnt "function"
        $.error("Some error TypeFrameWork mousePressed() object.");

      @els.push el
      el.on
        "mousedown": (e) -> method(e.offsetX, e.offsetY)

      return


    #--------------------------------------------------------------
    click: (method = ->) ->
      method()
      return

    setClick: (el, method) ->
      if not el? and not method?
        $.error("Some error TypeFrameWork mousePressed() object.");

      if @type(el) isnt "object" and @type(method) isnt "function"
        $.error("Some error TypeFrameWork mousePressed() object.");

      @els.push el
      el.on
        "click": (e) -> method(e, this)

      return


    #--------------------------------------------------------------
    mouseReleased: (method = ->) ->
      method()
      return

    setMouseReleased: (el, method) ->
      if not el? and not method?
        $.error("Some error TypeFrameWork mouseReleased() object.");

      if @type(el) isnt "object" and @type(method) isnt "function"
        $.error("Some error TypeFrameWork mouseReleased() object.");

      @els.push el
      el.on
        "mouseup": (e) -> method(e.offsetX, e.offsetY)

      return


    #--------------------------------------------------------------
    windowResized: (method) ->
      @_windowResized = method
      return

    windowResizedProcess: =>
      clearTimeout(@resizeTimer)

      @resizeTimer = setTimeout =>
        w = $window.width()
        h = $window.height()
        @_windowResized w, h
      , @options.resizeInterval
      return

    #--------------------------------------------------------------
    windowScroll: (method) ->
      @_windowScroll = method
      return

    windowScrollProcess: =>
      top = $window.scrollTop()
      @_windowScroll top
      return

    #--------------------------------------------------------------
    _checkLandScape: ->
      userAgent = navigator.userAgent
      if window.orientation? and
        userAgent.indexOf("iPhone") isnt -1 or
        userAgent.indexOf("iPad") isnt -1 or
        userAgent.indexOf("iPod") isnt -1 or
        userAgent.indexOf("Android") isnt -1
          orientation = window.orientation
          if orientation is 0
            return "portrait"
          else
            return "landscape"
      else
        return false

    orientationChange: (method = $.noop) ->
      @_orientationChange = method
      return

    orientationChangeProcess: =>
      @_orientationChange @_checkLandScape()
      return


    #--------------------------------------------------------------
    exit: (callback) ->
      $window.off()

      for els in @els
        els.off()

      if @updateProcess?
        cancelAnimationFrame @updateProcess
        @updateProcess = false

      if @type(callback) is "function"
        callback()
      else
        $.error "Some error TypeFrameWork exit() callback function."

      return null


    #--------------------------------------------------------------
    fullScreen: (support = false, el = document) ->
      if not support
        if (el.fullScreenElement and el.fullScreenElement not null) or (!el.mozFullScreen and !el.webkitIsFullScreen)
          if el.documentElement.requestFullScreen
            el.documentElement.requestFullScreen()
          else if el.documentElement.webkitRequestFullScreen
            el.documentElement.webkitRequestFullScreen()
          else if el.documentElement.mozRequestFullScreen
            el.documentElement.mozRequestFullScreen()
          else if el.msRequestFullscreen
            el.msRequestFullscreen()
          else
            return false

        return true
      else
        if el.requestFullscreen or el.webkitRequestFullscreen or el.mozRequestFullScreen or el.msRequestFullscreen
          return true
        else
          return false


    #--------------------------------------------------------------
    exitFullScreen: (el = document) ->
      if el.exitFullscreen
        el.exitFullscreen()
      else if el.webkitCancelFullScreen
        el.webkitCancelFullScreen()
      else if el.mozCancelFullScreen
        el.mozCancelFullScreen()
      else if el.msExitFullscreen
        el.msExitFullscreen()
      else if el.cancelFullScreen
        el.cancelFullScreen()
      else
        return false

      return true


    #--------------------------------------------------------------
    isFullScreen: (el = document) ->
      if el.fullscreen or el.webkitIsFullScreen or el.mozFullScreen or el.msFullScreen
        return true
      else
        return false


    #--------------------------------------------------------------
    fullScreenChange: (method = ->) ->
      @_fullScreenChange = method
      return

    fullScreenChangeProcess: =>
      @_fullScreenChange @isFullScreen()
      return


    #--------------------------------------------------------------
    devicemotionProcess: (e) =>
      e.preventDefault()

      acceleration = e.acceleration
      accelerationIncludingGravity = e.accelerationIncludingGravity
      rotationRate = e.rotationRate

      @accelerationX = acceleration.x
      @accelerationY = acceleration.y
      @accelerationZ = acceleration.z

      @gravityX = accelerationIncludingGravity.x
      @gravityY = accelerationIncludingGravity.y
      @gravityZ = accelerationIncludingGravity.z

      @rotationA = rotationRate.alpha
      @rotationB = rotationRate.beta
      @rotationG = rotationRate.gamma
      return

    #--------------------------------------------------------------
    type: (obj) ->
      if obj == undefined or obj == null
        return String obj
      classToType = {
        '[object Boolean]': 'boolean',
        '[object Number]': 'number',
        '[object String]': 'string',
        '[object Function]': 'function',
        '[object Array]': 'array',
        '[object Date]': 'date',
        '[object RegExp]': 'regexp',
        '[object Object]': 'object'
      }
      return classToType[Object.prototype.toString.call(obj)]


    #--------------------------------------------------------------
    # Math Helper
    #--------------------------------------------------------------
    vec2f: (x, y) ->
      return new ns.vec2f(x, y)

    random: (args...) ->
      len = args.length

      if len is 0
        num = Math.random()
      else if len is 1
        num = Math.floor( Math.random() * (args[0] + 1) )
      else if len is 2
        num = Math.floor( Math.random() * (args[1] + 1) )
      else
        $.error("Some error TypeFrameWork random() object.");

      return num

    valueMap: (value, inputMin, inputMax, outputMin, outputMax, clamp) ->
      FLT_EPSILON = 0.0000001192092896

      if Math.abs(inputMin - inputMax) < FLT_EPSILON
        $.error "valueMap avoiding possible divide by zero, check inputMin and inputMax: #{inputMin} #{inputMax}"
        return outputMin
      else
        outVal = ((value - inputMin) / (inputMax - inputMin) * (outputMax - outputMin) + outputMin)

        if clamp is true
          if outputMax < outputMin
            if outVal < outputMax
              outVal = outputMax
            else if outVal > outputMin
              outVal = outputMin
          else
            if outVal > outputMax
              outVal = outputMax
            else if outVal < outputMin
              outVal = outputMin

        return outVal

    #--------------------------------------------------------------
    # Path Helper
    #--------------------------------------------------------------
    setPath: (options) ->
      defaults =
        host:           window.location.href
        asset_dir:      "assets"
        css_dir:        "css"
        script_dir:     "script"
        image_dir:      "images"
        fonts_dir:      "fonts"
        pc_dir:         "pc"
        tablet_dir:     "tablet"
        sp_dir:         "sp"
        relative:       "relative"
        deviceIsParent: true
        strictSlash:    false
        root:           null

      @_path = $.extend {}, defaults, options
      return

    get_host_path: ->
      return @_path.host

    get_css_path: (rule, device) ->
      if rule is @_path.relative
        func = @_get_relative_path
       else
        func = @_get_root_path
      return func @_path.css_dir, device

    get_script_path: (rule, device) ->
      if rule is @_path.relative
        func = @_get_relative_path
       else
        func = @_get_root_path
      return func @_path.script_dir, device

    get_image_path: (rule, device) ->
      if rule is @_path.relative
        func = @_get_relative_path
       else
        func = @_get_root_path
      return func @_path.image_dir, device

    get_fonts_path: (rule, device) ->
      if rule is @_path.relative
        func = @_get_relative_path
       else
        func = @_get_root_path
      return func @_path.fonts_dir, device

    _get_relative_path: (asset, device) =>
      fragment = window.location.pathname
      if @_path.root?
        fragment = fragment.replace(@_path.root, "")

      level = fragment.split('/').length - 1
      result = @_get_path asset, device

      i = 0

      while i < level
        result = "../" + result
        i++

      if asset.strictSlash
        result + "/"

      result

    _get_root_path: (asset, device) =>
      result = "/" + @_get_path asset, device
      if asset.strictSlash
        result + "/"

      result

    _get_path: (asset, device) ->
      targetDev = ""
      targetAsset = ""
      switch device
        when @_path.pc_dir then targetDev = @_path.pc_dir
        when @_path.tablet_dir then targetDev = @_path.tablet_dir
        when @_path.sp_dir then targetDev = @_path.sp_dir
        else targetDev = ""

      switch asset
        when @_path.css_dir then targetAsset = @_path.css_dir;
        when @_path.image_dir then targetAsset = @_path.image_dir;
        when @_path.script_dir then targetAsset = @_path.script_dir;
        when @_path.data_dir then targetAsset = asset.data_DIR;
        else throw new Error('asset type fail');

      if targetDev? and targetDev isnt ""
        if @_path.asset_dir is ""
          result = if @_path.deviceIsParent then [targetDev, targetAsset] else [targetAsset, targetDev]
        else
          result = if @_path.deviceIsParent then [@_path.asset_dir, targetDev, targetAsset] else [@_path.asset_dir, targetAsset, targetDev]
      else
        if @_path.asset_dir is ""
          result = [targetAsset]
        else
          result = [@_path.asset_dir, targetAsset]

      result = result.join("/")
      return result 
    #--------------------------------------------------------------
    # END Path Helper
    #--------------------------------------------------------------

    getFrameRate: () ->
      return @options.frameRate

    getResizeInterval: () ->
      return @options.resizeInterval

    getWindowWidth: () ->
      return $window.width()

    getWindowHeight: () ->
      return $window.height()

    getLandscape: () ->
      return @_checkLandScape()


  # ============================================================
  # typeThread
  # ============================================================
  class ns.TypeThread extends ns.Event
    defaults:
      frameRate: 60
    #--------------------------------------------------------------
    constructor: (options) ->
      @options = $.extend {}, @defaults, options
      @updateProcess = $.noop
      @lastTime = null
      @startTime = null
      @oldFrame = null
      @stop = false
    #--------------------------------------------------------------
    setup: () ->
      @startTime = window.getTime()
    #--------------------------------------------------------------
    update: (method = $.noop) ->
      @lastTime = window.getTime()

      currentFrame = Math.floor( (@lastTime - @startTime) / (1000.0 / @options.frameRate) % 2 )
      if currentFrame isnt @oldFrame
        method()
        if @_draw?
          @_draw()
      @oldFrame = currentFrame

      @updateProcess = window.requestAnimationFrame =>
        @update method
        return
      return
    #--------------------------------------------------------------
    draw: (method = $.noop) ->
      @_draw = method
      return
    #--------------------------------------------------------------
    break: () ->
      cancelAnimationFrame @updateProcess

  # ============================================================
  # bridge to plugin
  # ============================================================
  $.TypeFrameWork = ns.TypeFrameWork
  $.TypeThread = ns.TypeThread

###

# document

# ============================================================
# hover method
# hover (jQuery Element, enter Event, leave Event)

# example

  tf.hover $("#js-index-nav").find("a"),
    (e, index) ->
      $(e.target).css "display", "none"
      console.log index
    (e, index) ->
      #e.target.css "opacty", 1
      console.log "leave"



# ============================================================
# example
  # mousemove method
  # mousemove (jQuery Element, moved Event)

  tf.mouseMoved ->
    tf.setMouseMoved($("#content"), (x, y) -> console.log "x: #{x} y: #{y}", option translate)


# ============================================================
# example
  # mousePressed method
  # mousePressed (jQuery Element, moved Event)

  tf.mousePressed ->
    tf.setMousePressed($("#content"), (x, y) -> console.log "x: #{x} y: #{y}")


# ============================================================
# example
  # mouseReleased method
  # mouseReleased (jQuery Element, moved Event)

  tf.mouseReleased ->
    tf.setMouseReleased($("#content"), (x, y) -> console.log "x: #{x} y: #{y}")


# ============================================================
# example
  # windowResized method
  # windowResized

  tf.windowResized (w, h) ->
    console.log "w: #{w} h: #{h}"


# ============================================================
# example
  # exit method
  # exit
  
  TypeFrameWork instance
  
  instance = instance.exit callbackFunction

  return null


  tf = new $.TypeFrameWork
  tf = tf.exit ->
    console.log "callback"


# ============================================================
# TypeThread example
  t = new $.TypeThread
      frameRate: 1
    t.setup()
    t.update ->
      console.log ""
###