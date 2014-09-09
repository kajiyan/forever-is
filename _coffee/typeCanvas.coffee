do (window=window, document=document, $=jQuery) ->
  ns = $.TypeCanvas = {}

  $window = $(window)
  $document = $(document)

  class ns.TypeCanvas
    defaults:
      size:
        width: null
        height: null
      colorMode: "RGB"
      clearBackground: true


    #--------------------------------------------------------------
    constructor: (@$el, options) ->
      if not @$el?
        @$el = $("<canvas>")
        $("body").prepend(@$el)

      @el = @$el[0]
      @options = $.extend {}, @defaults, options

      if(not @el or not @el.getContext)
        $.error "It does not support the canvas"
        return false

      @setup()
      @update()


    #--------------------------------------------------------------
    setup: () ->
      @context = @el.getContext("2d")
      @_size()


    #--------------------------------------------------------------
    _size: () ->
      @el.width = if @options.size.width? then @options.size.width else $window.innerWidth()
      @el.height = if @options.size.height? then @options.size.height else $window.innerHeight()


    #--------------------------------------------------------------
    update: (method = ->) ->
      method()


    #--------------------------------------------------------------
    draw: (method = ->) ->
      if @options.clearBackground
        @context.clearRect(0, 0, $window.width(), $window.height())
      method()


    #--------------------------------------------------------------
    mouseMoved: (method, translate = "page") ->
      if not method?
        $.error("Some error TypeCanvas mouseMoved() object.");

      switch translate
        when "page" then @$el.on "mousemove": (e) -> method(e.pageX, e.pageY)
        when "client" then @$el.on "mousemove": (e) -> method(e.clientX, e.clientY)
        when "offset" then @$el.on "mousemove": (e) -> method(e.offsetX, e.offsetY)
        else el.on "mousemove": (e) -> method(e.pageX, e.pageY)

      return


    #--------------------------------------------------------------
    resize: (width, height) ->
      @el.width = if @options.size.width? then @options.size.width else width
      @el.height = if @options.size.height? then @options.size.height else height


    #--------------------------------------------------------------
    getElement: ->
      return @$el


    #--------------------------------------------------------------
    getContext: ->
      return @context


    #--------------------------------------------------------------
    getHeight: ->
      return @$el.height()


    #--------------------------------------------------------------
    getWidth: ->
      return @$el.width()

  # ============================================================
  # bridge to plugin
  # ============================================================
  $.fn.typeCanvas = (options) ->
    @each (i, el) ->
      $el = $(el)
      instance = new ns.TypeCanvas $el, options
      $el.data "typeCanvas", instance
      return

  $.TypeCanvas = ns.TypeCanvas