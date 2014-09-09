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
    # content
    form =
      obj: do ->
        result = {}
        result.root = $("#js-entry-form")
        result.nickname = $("#entry-nickname")
        result.mail = $("#entry-mail")
        result.enabled = $("#entry-news-enabled")
        result.submit = $("#js-entry-form-btn")
        result.form = result.root.find(".js-entry-holder")
        result.entryBtn = result.root.find(".entry-form-btn")
        return result;
      setup: () ->
        form.waiting()
      waiting: () ->
        thread = new $.TypeThread
          frameRate: 30

        thread.setup()
        thread.update ->
          if form.check.isText(form.obj.nickname).isset and
            form.check.isText(form.obj.mail).isset and 
            form.check.isCheckBox(form.obj.enabled).isset
              form.obj.submit
                .prop("disabled", false)
                .removeClass("is-disabled")
          else
            form.obj.submit
                .prop("disabled", true)
                .addClass("is-disabled")

      check:
        isText: ($obj, callback = $.noop) ->
          result = {}
          strlen = $obj.val().length
          if $obj.val().length > 0
            result.isset = true
          else
            result.isset = false
          return result
        isCheckBox: ($obj, callback = $.noop) ->
          result = {}
          result.isset = $obj.is(':checked')
          return result


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


    form.setup()
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
      tf.setMouseMoved($("#entry")
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