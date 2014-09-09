unless window.console?
  window.console = log: $.noop

window.onload = () ->
  $("body").addClass("js-fadeIn")
 
$ ->
  h = {}
  tf = new $.TypeFrameWork()
 
  # --------------------------------------------------------------
  tf.setup ->
    # --------------------------------------------------------------
    # coordinate
    coordinate =
      obj: do ->
        result = {}
        result.root = $("#js-content")
        result.link = result.root.find(".coordinate-inner")
        return result;
      setup: () ->
        coordinate.obj.link.on("click"
          , (e) ->
            e.preventDefault()
            $.colorbox(
              iframe: true
              href: $(this).attr("href")
              width: 1286
              height: 706
              speed: 200
              transition: "fade"
            )
        )

    # --------------------------------------------------------------
    # mouse
    h.mouse =
      state:
        control: false
        nowpos:
          x: 0
          y: 0
        oldpos:
          x: 0
          y: 0
      thread:
        state:
          loopTime: 1000
          counter: 1
        obj: new $.TypeThread
          frameRate: 1
        setup: () ->
          h.mouse.thread.obj.setup()
          h.mouse.thread.obj.update ->
            callNum = (h.mouse.thread.state.counter % h.mouse.thread.state.loopTime + h.mouse.thread.state.loopTime) % h.mouse.thread.state.loopTime
            console.log callNum

            if h.mouse.state.oldpos.x is h.mouse.state.nowpos.x and
              h.mouse.state.oldpos.y is h.mouse.state.nowpos.y
                if callNum is h.mouse.thread.state.loopTime - 1
                  # loopTimeに指定された秒数操作がないとき
                  h.mouse.state.control = false
                  # 一定の時間操作がなければリダイレクト
                  location.href = "/"
                  console.log "No Control"
            else
              # ユーザーが操作をしているとき
              h.mouse.state.control = true

            # 一秒に一度マウスの座標を記録
            h.mouse.state.oldpos.x = h.mouse.state.nowpos.x
            h.mouse.state.oldpos.y = h.mouse.state.nowpos.y

            h.mouse.thread.state.counter++
      getUserControl: () ->
        return h.mouse.state.control

    # --------------------------------------------------------------
    # side animate
    side =
      state:
        left: null
        right: null
        leftHeight: 0
        rightHeight: 0
      obj: do ->
        result = {}
        result.beforeRoot = $("#js-before-animate")
        result.before = result.beforeRoot.find(".animate")
        result.afterRoot = $("#js-after-animate")
        result.after = result.afterRoot.find(".animate")
        return result
      setup: () ->
        side.state.leftHeight = side.obj.before.height()
        side.state.rightHeight = side.obj.after.height()
        side.waiting()
      waiting: () ->
        thread = new $.TypeThread
          frameRate: 2

        thread.setup()
        thread.update ->
          contentHeight = if $(window).height() > $("#js-l-content-inner").height() then $(window).height() else $("#js-l-content-inner").height()

          $("#js-l-content").css
            "height": contentHeight
            "overflow": "hidden"
      refresh: () ->
        contentHeight = if $(window).height() > $("#js-l-content-inner").height() then $(window).height() else $("#js-l-content-inner").height()

        $("#js-l-content").css
          "height": contentHeight
          "overflow": "hidden"

        beforeCircleHeight = 0
        side.obj.beforeRoot.find('.animate').each () ->
          beforeCircleHeight += $(this).height()

        beforeDiff = contentHeight - beforeCircleHeight

        if beforeDiff > 0 
          addNum = Math.floor(beforeDiff / side.state.rightHeight) + 1
          console.log addNum
          for i in [0..addNum - 1]
            console.log "call"
            side.obj.beforeRoot.append(side.obj.before.clone())


        afterCircleHeight = 0
        side.obj.afterRoot.find('.animate').each () ->
          afterCircleHeight += $(this).height()

        afterDiff = contentHeight - afterCircleHeight

        if afterDiff > 0 
          addNum = Math.floor(afterDiff / side.state.rightHeight) + 1
          console.log addNum
          for i in [0..addNum - 1]
            console.log "call"
            side.obj.afterRoot.append(side.obj.after.clone())

    coordinate.setup()
    h.mouse.thread.setup()

    side.setup()
    side.refresh()
 
  # --------------------------------------------------------------
  tf.update ->
 
  # --------------------------------------------------------------
  tf.draw ->
 
  # --------------------------------------------------------------
  tf.hover ->
 
  # --------------------------------------------------------------
  tf.keyPressed (key) ->
 
  # --------------------------------------------------------------
  tf.keyReleased (key) ->
 
  # --------------------------------------------------------------
  tf.click ->
 
  # --------------------------------------------------------------
  tf.mouseMoved ->
    tf.mouseMoved ->
      tf.setMouseMoved($("#coordinate")
        , (x, y) ->
          # console.log "#{x} : #{y}"
          h.mouse.state.nowpos.x = x
          h.mouse.state.nowpos.y = y
          h.mouse.thread.state.counter = 0
      )

  # --------------------------------------------------------------
  tf.mousePressed ->
 
  # --------------------------------------------------------------
  tf.mouseReleased ->
  
  # --------------------------------------------------------------
  tf.windowScroll (top) ->
 
  # --------------------------------------------------------------
  tf.windowResized (w, h) ->
 
  # --------------------------------------------------------------
  tf.fullScreenChange (full) ->