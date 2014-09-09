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
    tf = new $.TypeFrameWork();
    tf.setup(function() {
      var form, side;
      form = {
        obj: (function() {
          var result;
          result = {};
          result.root = $("#js-entry-form");
          result.nickname = $("#entry-nickname");
          result.mail = $("#entry-mail");
          result.enabled = $("#entry-news-enabled");
          result.submit = $("#js-entry-form-btn");
          result.form = result.root.find(".js-entry-holder");
          result.entryBtn = result.root.find(".entry-form-btn");
          return result;
        })(),
        setup: function() {
          return form.waiting();
        },
        waiting: function() {
          var thread;
          thread = new $.TypeThread({
            frameRate: 30
          });
          thread.setup();
          return thread.update(function() {
            if (form.check.isText(form.obj.nickname).isset && form.check.isText(form.obj.mail).isset && form.check.isCheckBox(form.obj.enabled).isset) {
              return form.obj.submit.prop("disabled", false).removeClass("is-disabled");
            } else {
              return form.obj.submit.prop("disabled", true).addClass("is-disabled");
            }
          });
        },
        check: {
          isText: function($obj, callback) {
            var result, strlen;
            if (callback == null) {
              callback = $.noop;
            }
            result = {};
            strlen = $obj.val().length;
            if ($obj.val().length > 0) {
              result.isset = true;
            } else {
              result.isset = false;
            }
            return result;
          },
          isCheckBox: function($obj, callback) {
            var result;
            if (callback == null) {
              callback = $.noop;
            }
            result = {};
            result.isset = $obj.is(':checked');
            return result;
          }
        }
      };
      h.mouse = {
        state: {
          control: false,
          nowpos: {
            x: 0,
            y: 0
          },
          oldpos: {
            x: 0,
            y: 0
          }
        },
        thread: {
          state: {
            loopTime: 1000,
            counter: 1
          },
          obj: new $.TypeThread({
            frameRate: 1
          }),
          setup: function() {
            h.mouse.thread.obj.setup();
            return h.mouse.thread.obj.update(function() {
              var callNum;
              callNum = (h.mouse.thread.state.counter % h.mouse.thread.state.loopTime + h.mouse.thread.state.loopTime) % h.mouse.thread.state.loopTime;
              console.log(callNum);
              if (h.mouse.state.oldpos.x === h.mouse.state.nowpos.x && h.mouse.state.oldpos.y === h.mouse.state.nowpos.y) {
                if (callNum === h.mouse.thread.state.loopTime - 1) {
                  h.mouse.state.control = false;
                  location.href = "/";
                  console.log("No Control");
                }
              } else {
                h.mouse.state.control = true;
              }
              h.mouse.state.oldpos.x = h.mouse.state.nowpos.x;
              h.mouse.state.oldpos.y = h.mouse.state.nowpos.y;
              return h.mouse.thread.state.counter++;
            });
          }
        },
        getUserControl: function() {
          return h.mouse.state.control;
        }
      };
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
      form.setup();
      h.mouse.thread.setup();
      side.setup();
      return side.refresh();
    });
    tf.update(function() {});
    tf.draw(function() {});
    tf.hover(function() {});
    tf.keyPressed(function(key) {});
    tf.keyReleased(function(key) {});
    tf.click(function() {});
    tf.mouseMoved(function() {
      return tf.mouseMoved(function() {
        return tf.setMouseMoved($("#entry"), function(x, y) {
          h.mouse.state.nowpos.x = x;
          h.mouse.state.nowpos.y = y;
          return h.mouse.thread.state.counter = 0;
        });
      });
    });
    tf.mousePressed(function() {});
    tf.mouseReleased(function() {});
    tf.windowScroll(function(top) {});
    tf.windowResized(function(w, h) {});
    return tf.fullScreenChange(function(full) {});
  });

}).call(this);

//# sourceMappingURL=entry.js.map
