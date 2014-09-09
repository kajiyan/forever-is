do (window, document, $=jQuery) ->
  unless window.console?
    window.console = log: $.noop
 
  sn = $.typeApp = {}
  $ ->
    CONSTANT =
      maxWidth: 1920
      maxHeight: 1080
      minWidth: 980
      minHeight: 600

    # ============================================================
    # EventFrame
    class sn.Event
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
    # NowCanvas
    class sn.NowCanvas extends sn.Event
      defaults:
        socketIO: null

      constructor: (@$el, options) ->
        @options = $.extend {}, @defaults, options

        width = if @$el.parent().innerWidth() < CONSTANT.minWidth then CONSTANT.minWidth else @$el.parent().innerWidth()
        height = if @$el.parent().innerHeight() < CONSTANT.minHeight then CONSTANT.minHeight else @$el.parent().innerHeight()

        @inputMode = false

        # Soket On data
        @socketPos = []

        # Insert data
        @keyData = {}

        # Mouse position
        @pos =
          x: 0
          y: 0

        @frameRate = 24
        @loopTime = 10 * @frameRate # 本番は乱数
        @counter = 1
        @thread = new $.TypeThread
          frameRate: @frameRate

        @tc = new $.TypeCanvas(
          @$el,
          size:
            "width": width
            "height": height
        )
      setup: () ->
        # setup deferred
        # defer = new $.Deferred
        # return new $.Deferred (defer) =>

        # socket のID
        @socketID = @options.socketIO.socketID

        # canvasに描画する画像を用意する
        @images = []
        @imgLoader = new $.ImgLoader
          srcs: ["/images/image1.jpg"]

        # 画像を読みこむごとに配列へ追加する
        @imgLoader.on "itemload"
          , ($img) =>
            @images.push $img
        
        # すべての読み込みが完了したらdeferredオブジェクトの状態を変える
        @imgLoader.on "allload"
          , ($img) =>
            defer.resolve()

        # insert するデータを格納する配列
        @keyData.pos = []

        @thread.setup()
        @thread.update =>
          callNum = (@counter % @loopTime + @loopTime) % @loopTime
          if callNum is @loopTime - 1

            console.log @inputMode
            console.log @keyData.pos

            # inputMode ならメモリを開放する
            if @inputMode
              # Insert
              @options.socketIO.socket.emit "c-to-s-add-position", @keyData

              @keyData.pos = []
              nextInterval = 10 + Math.floor(Math.random() * 50)
            else
              nextInterval = 4 + Math.floor(Math.random() * 4)

            console.log "nextInterval - #{nextInterval}"
            # 間隔を再定義する
            @loopTime = nextInterval * @frameRate
            @inputMode = !@inputMode
          
          if @inputMode
            @keyData.pos.push(@pos)
          
          @counter++

        @options.socketIO.socket.on "s-to-c-now-position"
          , (data) =>
            @socketPos.push(data)
            console.log "broadcast positiont"
            console.log data
        @options.socketIO.socket.on "s-to-c-disconnect"
          , (socketID) =>
            # 切断されたユーザーのsocketIDが返ってくる
            @socketPos = _.reject @socketPos
              , (item) ->
                return item.socketID is socketID

        # 画像の読み込みを開始する
        @imgLoader.load()

        # deferred オブジェクトを返す
        return defer.promise()

        # Canvasで使う Imageオブジェクトを生成
        # @img = new Image()
        # @img.onload = () =>
        #   @tc.context.drawImage(@img, 0, 0)

        # @img.src = "/images/image1.jpg"
        # @tc.context.drawImage(@img, 0, 0)

        # console.log @img

        # 画像を描画
        # @tc.context.drawImage(@img, 0, 0)

      update: () ->
        # @tc.update =>
        #   # IDを基準にユニークな配列にする
        #   @socketPos = _(@socketPos).chain()
        #     .reverse()
        #     .uniq (obj, key, i) ->
        #       return obj.socketID
        #     .value()

          # @socketPos = _.uniq @socketPos
          #   , (obj, key, i) ->
          #     return obj.socketID
      draw: () ->
        # @tc.draw =>
        #   for value, i in @socketPos
        #     @tc.context.beginPath()
        #     @tc.context.fillStyle = "#ffffff"
        #     @tc.context.arc(value.x, value.y, 10, (Math.PI / 180 * 0), (Math.PI / 180 * 360), true)
      
        #     @tc.context.lineWidth = 1
        #     @tc.context.strokeStyle = "#000000"
        #     @tc.context.stroke()
        #     @tc.context.fill()

          # console.log "draw"

          # @socketPos = []
      putMousePos: () ->
        @inputMode = true

      mouseMoved: (x, y) ->
        @pos =
          "x": x
          "y": y

        # イベント送信
        @options.socketIO.socket.emit "c-to-s-now-position", @pos
      windowResized: (width, height) ->
        @tc.resize(width, height)


    # ============================================================
    # MemoryIs
    class sn.MemoryIs
      constructor: () ->

    # ============================================================
    # PastCanvas
    class sn.PastCanvas extends sn.Event
      constructor: (@$el, options) ->
        @tc = new $.TypeCanvas(
          @$el,
          size:
            "width": width
            "height": height
        )

    # ============================================================
    # SocketIO
    class sn.SocketIO
      constructor: (url) ->
        @socket = io.connect(url)
        @socketID = null
        @socketDefer = new $.Deferred()

        @socket.on "connect"
          , () =>
            console.log "socket connect"
            @socket.emit "c-to-s-connect", {}

        @socket.on "s-to-c-connect"
          , (socketID) =>
            @socketID = socketID
            @socketDefer.resolve()

        @socketDefer.promise()




    # ============================================================
    # TypeFrameWork
    sn.tf = new $.TypeFrameWork
      frameRate: 24
    
    socketIO = new sn.SocketIO("http://192.168.33.10:3000/");
    
    isNowCanvas = new sn.NowCanvas($("#js-is-now-canvas"),
      "socketIO": socketIO
    )

    isPastCanvas = new sn.NowCanvas($("#js-is-past-canvas"))

    # --------------------------------------------------------------
    sn.tf.setup ->
      sn.tf.setMousePressed $(window)
        , (x, y) ->
          socketIO.socket.emit "c-to-s-get-position", "x: #{x} y: #{y}"
          console.log "x: #{x} y: #{y}"

      $.when(
        socketIO.socketDefer
      ).then(
        ->
          isNowCanvas.setup()
          console.log "--- app init ---"
      )

      # testArray = [
      #   {x: 100, y: 100, socketID: "ChpG65h_87d-5lz0AAAB"}
      #   {x: 100, y: 100, socketID: "ChpG65h_87d-5lz0AAAB"}
      #   {x: 343, y: 51, socketID: "ChpG65h_87d-5lz0AAAB"}
      # ]

      # console.log _.uniq testArray
      #   , (obj, key, i) ->
      #     return obj.socketID
   
    # --------------------------------------------------------------
    sn.tf.update ->
      isNowCanvas.update()
   
    # --------------------------------------------------------------
    sn.tf.draw ->
      isNowCanvas.draw()
   
    # --------------------------------------------------------------
    sn.tf.hover ->
   
    # --------------------------------------------------------------
    sn.tf.keyPressed (key) ->
   
    # --------------------------------------------------------------
    sn.tf.keyReleased (key) ->
   
    # --------------------------------------------------------------
    sn.tf.click ->
   
    # --------------------------------------------------------------
    sn.tf.mouseMoved ->
      sn.tf.setMouseMoved isNowCanvas.$el, (x, y) =>
        isNowCanvas.mouseMoved(x, y)
        # typeCanvas.mouseMoved(socketIO.socket, x, y)
   
    # --------------------------------------------------------------
    sn.tf.mousePressed ->
   
    # --------------------------------------------------------------
    sn.tf.mouseReleased ->
    
    # --------------------------------------------------------------
    sn.tf.windowScroll (top) ->
   
    # --------------------------------------------------------------
    sn.tf.windowResized (width, height) ->
      width = if width < CONSTANT.minWidth then CONSTANT.minWidth else width
      height = if height < CONSTANT.minHeight then CONSTANT.minHeight else height
      isNowCanvas.windowResized(width, height)
   
    # --------------------------------------------------------------
    sn.tf.fullScreenChange (full) ->