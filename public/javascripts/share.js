(function() {
  if (window.console == null) {
    window.console = {
      log: $.noop
    };
  }

  window.onload = function() {
    return $("body").addClass("js-fadeIn");
  };

  $(function() {
    var h, tf;
    h = {};
    tf = new $.TypeFrameWork({
      frameRate: 30.0
    });
    tf.setup(function() {
      var share, side;
      h.conectWin = null;
      window.addEventListener("message", function(e) {
        console.log(e.data);
        if ((e.data.callback != null) && e.data.callback.status === 1) {
          if ((h.conectWin != null) && !h.conectWin.closed) {
            h.conectWin.close();
            h.conectWin = null;
            return location.href = "/share-complete/twitter/" + $("#js-selectID").val();
          }
        }
      }, false);
      share = {
        obj: (function() {
          var result;
          result = {};
          result.root = $("#js-share-list");
          result.facebook = result.root.find(".share-facebook");
          result.twitter = result.root.find(".share-twitter");
          return result;
        })(),
        setup: function() {
          share.obj.twitter.on("click", function(e) {
            var options, posX, posY, url, winHeight, winWidth, windowName;
            e.preventDefault();
            windowName = "shareWindow";
            url = $(this).attr("href");
            winWidth = "1182";
            winHeight = "680";
            posX = (screen.width - winWidth) / 2;
            posY = (screen.height - winHeight) / 2;
            options = "width=" + winWidth + ", height=" + winHeight + ", left=" + posX + ", top=" + posY;
            h.conectWin = window.open(url, windowName, options);
            return h.conectWin.focus();
          });
          return console.log("setup");
        }
      };
      share.setup();
      side = {
        state: {
          left: null,
          right: null,
          leftHeight: 0,
          rightHeight: 0
        },
        obj: (function() {
          var result;
          result = {};
          result.beforeRoot = $("#js-before-animate");
          result.before = result.beforeRoot.find(".animate");
          result.afterRoot = $("#js-after-animate");
          result.after = result.afterRoot.find(".animate");
          return result;
        })(),
        setup: function() {
          side.state.leftHeight = side.obj.before.height();
          side.state.rightHeight = side.obj.after.height();
          return side.waiting();
        },
        waiting: function() {
          var thread;
          thread = new $.TypeThread({
            frameRate: 2
          });
          thread.setup();
          return thread.update(function() {
            var contentHeight;
            contentHeight = $(window).height() > $("#js-l-content-inner").height() ? $(window).height() : $("#js-l-content-inner").height();
            return $("#js-l-content").css({
              "height": contentHeight,
              "overflow": "hidden"
            });
          });
        },
        refresh: function() {
          var addNum, afterCircleHeight, afterDiff, beforeCircleHeight, beforeDiff, contentHeight, i, _i, _j, _ref, _ref1, _results;
          contentHeight = $(window).height() > $("#js-l-content-inner").height() ? $(window).height() : $("#js-l-content-inner").height();
          $("#js-l-content").css({
            "height": contentHeight,
            "overflow": "hidden"
          });
          beforeCircleHeight = 0;
          side.obj.beforeRoot.find('.animate').each(function() {
            return beforeCircleHeight += $(this).height();
          });
          beforeDiff = contentHeight - beforeCircleHeight;
          if (beforeDiff > 0) {
            addNum = Math.floor(beforeDiff / side.state.rightHeight) + 1;
            console.log(addNum);
            for (i = _i = 0, _ref = addNum - 1; 0 <= _ref ? _i <= _ref : _i >= _ref; i = 0 <= _ref ? ++_i : --_i) {
              console.log("call");
              side.obj.beforeRoot.append(side.obj.before.clone());
            }
          }
          afterCircleHeight = 0;
          side.obj.afterRoot.find('.animate').each(function() {
            return afterCircleHeight += $(this).height();
          });
          afterDiff = contentHeight - afterCircleHeight;
          if (afterDiff > 0) {
            addNum = Math.floor(afterDiff / side.state.rightHeight) + 1;
            console.log(addNum);
            _results = [];
            for (i = _j = 0, _ref1 = addNum - 1; 0 <= _ref1 ? _j <= _ref1 : _j >= _ref1; i = 0 <= _ref1 ? ++_j : --_j) {
              console.log("call");
              _results.push(side.obj.afterRoot.append(side.obj.after.clone()));
            }
            return _results;
          }
        }
      };
      side.setup();
      return side.refresh();
    });
    tf.update(function() {
      if (h.conectWin != null) {
        return h.conectWin.postMessage("api call", "http://yoox-10th.com");
      }
    });
    tf.draw(function() {});
    tf.hover(function() {});
    tf.keyPressed(function(key) {});
    tf.keyReleased(function(key) {});
    tf.click(function() {});
    tf.mouseMoved(function() {});
    tf.mousePressed(function() {});
    tf.mouseReleased(function() {});
    tf.windowScroll(function(top) {});
    tf.windowResized(function(w, h) {});
    return tf.fullScreenChange(function(full) {});
  });

}).call(this);

//# sourceMappingURL=share.js.map
