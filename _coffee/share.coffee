unless window.console?
  window.console = log: $.noop

window.onload = () ->
  $("body").addClass("js-fadeIn")
 
$ ->
  h = {}
  tf = new $.TypeFrameWork
    frameRate: 30.0
 
  # --------------------------------------------------------------
  tf.setup ->

    h.conectWin = null

    # メッセージが送られたときに反応するイベントリスナー
    window.addEventListener("message"
      , (e) ->
        console.log e.data
        if e.data.callback? and e.data.callback.status is 1
          if h.conectWin? and !h.conectWin.closed
            h.conectWin.close()
            h.conectWin = null
            location.href = "/share-complete/twitter/" + $("#js-selectID").val()
            # $.ajax
            #   type: "POST"
            #   url: "http://yoox-10th.com/sns/twitter/post"
            #   data: 
            #     "id": 1
            #     "access_token": e.data.callback.accessToken
            #     "access_token_secret": e.data.callback.accessTokenSecret
            #   cache: false
            #   success: (data, statusText, jqXHR) ->
            #     location.href = "/share-complete/twitter/1"
            #   error: (jqXHR, statusText, error) ->
            #     console.log "error"
            #   complete: () ->
            #     # h.conectWin.close()
      , false
    )

    share = 
      obj: do ->
        result = {}
        result.root = $("#js-share-list")
        result.facebook = result.root.find(".share-facebook")
        result.twitter = result.root.find(".share-twitter")
        return result
      setup: () ->
        share.obj.twitter.on("click"
          , (e) ->
            e.preventDefault()

            windowName = "shareWindow"
            url = $(this).attr("href")
            winWidth = "1182"
            winHeight = "680"
            posX = (screen.width - winWidth) / 2
            posY = (screen.height - winHeight) / 2
            options = "width=#{winWidth}, height=#{winHeight}, left=#{posX}, top=#{posY}"
            
            h.conectWin = window.open(url, windowName, options)
            h.conectWin.focus()
        )

        console.log "setup"

    share.setup()

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

    side.setup()
    side.refresh()
 
  # --------------------------------------------------------------
  tf.update ->
    if h.conectWin?
      h.conectWin.postMessage("api call", "http://yoox-10th.com")
 
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