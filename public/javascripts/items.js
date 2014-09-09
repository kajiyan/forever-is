(function() {
  if (window.console == null) {
    window.console = {
      log: $.noop
    };
  }

  $(function() {
    var h, tf;
    h = {};
    tf = new $.TypeFrameWork({
      frameRate: 1.0
    });
    tf.setup(function() {
      var content;
      content = {
        obj: (function() {
          var result;
          result = {};
          result.root = $("#js-items-detail-wrapper");
          result.grd = result.root.find(".items-grd");
          result.entry = $("#js-items-entry");
          result.entryBtn = result.entry.find(".items-btn");
          return result;
        })(),
        setup: function() {
          var $content;
          $content = content.obj.root.perfectScrollbar();
          $content.scroll(function(e) {
            return content.obj.grd.css({
              top: $content.scrollTop() + (content.obj.root.height() - content.obj.grd.height())
            });
          });
          return content.obj.entryBtn.on("click", function(e) {
            e.preventDefault();
            return parent.location.href = $(this).attr("href");
          });
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
            loopTime: 10000,
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
                  parent.location.href = "/";
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
      content.setup();
      return h.mouse.thread.setup();
    });
    tf.update(function() {});
    tf.draw(function() {});
    tf.hover(function() {});
    tf.keyPressed(function(key) {});
    tf.keyReleased(function(key) {});
    tf.click(function() {});
    tf.mouseMoved(function() {});
    tf.mousePressed(function() {
      return tf.mouseMoved(function() {
        return tf.setMouseMoved($("#items"), function(x, y) {
          h.mouse.state.nowpos.x = x;
          h.mouse.state.nowpos.y = y;
          return h.mouse.thread.state.counter = 0;
        });
      });
    });
    tf.mouseReleased(function() {});
    tf.windowScroll(function(top) {});
    tf.windowResized(function(w, h) {});
    return tf.fullScreenChange(function(full) {});
  });

}).call(this);

//# sourceMappingURL=items.js.map
