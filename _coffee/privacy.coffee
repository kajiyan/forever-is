unless window.console?
  window.console = log: $.noop
 
$ ->
  h = {}
  tf = new $.TypeFrameWork(
      frameRate: 1.0
    )
 
  # --------------------------------------------------------------
  tf.setup ->
    # --------------------------------------------------------------
    # top-content
    content =
      obj: do ->
        result = {}
        result.root = $("#js-content")
        result.grd = result.root.find(".privacy-grd")
        result.footer = $("#js-footer")
        result.btnNo = result.footer.find(".footer-btn-no")
        result.btnYes = result.footer.find(".footer-btn-yes")

        return result;
      setup: () ->
        $content = content.obj.root.perfectScrollbar()

        $content.scroll( (e) ->
          content.obj.grd.css
            top: $content.scrollTop() + (content.obj.root.height() - content.obj.grd.height())
        )

        content.obj.btnNo.on("click"
          , (e) ->
            e.preventDefault()
            parent.$.fn.colorbox.close()
        )

        content.obj.btnYes.on("click"
          , (e) ->
            e.preventDefault()
            parent.location.href = $(this).attr("href")
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
                  # 一定の時間操作がなければcolorBoxを閉じる
                  parent.$.fn.colorbox.close()
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



    content.setup()
    h.mouse.thread.setup()
 
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
      tf.setMouseMoved($("#privacy")
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