(function() {
  var __slice = [].slice,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  (function(window, document, $) {
    var sn;
    if (window.console == null) {
      window.console = {
        log: $.noop
      };
    }
    sn = $.typeApp = {};
    return $(function() {
      var CONSTANT, isNowCanvas, isPastCanvas, socketIO;
      CONSTANT = {
        maxWidth: 1920,
        maxHeight: 1080,
        minWidth: 980,
        minHeight: 600
      };
      sn.Event = (function() {
        function Event() {
          this._callbacks = {};
        }

        Event.prototype.on = function(ev, callback) {
          var evs, name, _base, _i, _len;
          evs = ev.split(' ');
          for (_i = 0, _len = evs.length; _i < _len; _i++) {
            name = evs[_i];
            (_base = this._callbacks)[name] || (_base[name] = []);
            this._callbacks[name].push(callback);
          }
          return this;
        };

        Event.prototype.one = function(ev, callback) {
          return this.on(ev, function() {
            this.off(ev, arguments.callee);
            return callback.apply(this, arguments);
          });
        };

        Event.prototype.trigger = function() {
          var args, callback, ev, list, _i, _len, _ref;
          args = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
          ev = args.shift();
          list = (_ref = this._callbacks) != null ? _ref[ev] : void 0;
          if (!list) {
            return;
          }
          for (_i = 0, _len = list.length; _i < _len; _i++) {
            callback = list[_i];
            if (callback.apply(this, args) === false) {
              break;
            }
          }
          return this;
        };

        Event.prototype.off = function(ev, callback) {
          var cb, i, list, _i, _len, _ref;
          if (!ev) {
            this._callbacks = {};
            return this;
          }
          list = (_ref = this._callbacks) != null ? _ref[ev] : void 0;
          if (!list) {
            return this;
          }
          if (!callback) {
            delete this._callbacks[ev];
            return this;
          }
          for (i = _i = 0, _len = list.length; _i < _len; i = ++_i) {
            cb = list[i];
            if (!(cb === callback)) {
              continue;
            }
            list = list.slice();
            list.splice(i, 1);
            this._callbacks[ev] = list;
            break;
          }
          return this;
        };

        Event.prototype.bind = function() {
          return this.on.apply(this, arguments);
        };

        Event.prototype.unbind = function() {
          return this.off.apply(this, arguments);
        };

        return Event;

      })();
      sn.NowCanvas = (function(_super) {
        __extends(NowCanvas, _super);

        NowCanvas.prototype.defaults = {
          socketIO: null
        };

        function NowCanvas($el, options) {
          var height, width;
          this.$el = $el;
          this.options = $.extend({}, this.defaults, options);
          width = this.$el.parent().innerWidth() < CONSTANT.minWidth ? CONSTANT.minWidth : this.$el.parent().innerWidth();
          height = this.$el.parent().innerHeight() < CONSTANT.minHeight ? CONSTANT.minHeight : this.$el.parent().innerHeight();
          this.inputMode = false;
          this.socketPos = [];
          this.keyData = {};
          this.pos = {
            x: 0,
            y: 0
          };
          this.frameRate = 24;
          this.loopTime = 10 * this.frameRate;
          this.counter = 1;
          this.thread = new $.TypeThread({
            frameRate: this.frameRate
          });
          this.tc = new $.TypeCanvas(this.$el, {
            size: {
              "width": width,
              "height": height
            }
          });
        }

        NowCanvas.prototype.setup = function() {
          this.socketID = this.options.socketIO.socketID;
          this.images = [];
          this.imgLoader = new $.ImgLoader({
            srcs: ["/images/image1.jpg"]
          });
          this.imgLoader.on("itemload", (function(_this) {
            return function($img) {
              return _this.images.push($img);
            };
          })(this));
          this.imgLoader.on("allload", (function(_this) {
            return function($img) {
              return defer.resolve();
            };
          })(this));
          this.keyData.pos = [];
          this.thread.setup();
          this.thread.update((function(_this) {
            return function() {
              var callNum, nextInterval;
              callNum = (_this.counter % _this.loopTime + _this.loopTime) % _this.loopTime;
              if (callNum === _this.loopTime - 1) {
                console.log(_this.inputMode);
                console.log(_this.keyData.pos);
                if (_this.inputMode) {
                  _this.options.socketIO.socket.emit("c-to-s-add-position", _this.keyData);
                  _this.keyData.pos = [];
                  nextInterval = 10 + Math.floor(Math.random() * 50);
                } else {
                  nextInterval = 4 + Math.floor(Math.random() * 4);
                }
                console.log("nextInterval - " + nextInterval);
                _this.loopTime = nextInterval * _this.frameRate;
                _this.inputMode = !_this.inputMode;
              }
              if (_this.inputMode) {
                _this.keyData.pos.push(_this.pos);
              }
              return _this.counter++;
            };
          })(this));
          this.options.socketIO.socket.on("s-to-c-now-position", (function(_this) {
            return function(data) {
              _this.socketPos.push(data);
              console.log("broadcast positiont");
              return console.log(data);
            };
          })(this));
          this.options.socketIO.socket.on("s-to-c-disconnect", (function(_this) {
            return function(socketID) {
              return _this.socketPos = _.reject(_this.socketPos, function(item) {
                return item.socketID === socketID;
              });
            };
          })(this));
          this.imgLoader.load();
          return defer.promise();
        };

        NowCanvas.prototype.update = function() {};

        NowCanvas.prototype.draw = function() {};

        NowCanvas.prototype.putMousePos = function() {
          return this.inputMode = true;
        };

        NowCanvas.prototype.mouseMoved = function(x, y) {
          this.pos = {
            "x": x,
            "y": y
          };
          return this.options.socketIO.socket.emit("c-to-s-now-position", this.pos);
        };

        NowCanvas.prototype.windowResized = function(width, height) {
          return this.tc.resize(width, height);
        };

        return NowCanvas;

      })(sn.Event);
      sn.MemoryIs = (function() {
        function MemoryIs() {}

        return MemoryIs;

      })();
      sn.PastCanvas = (function(_super) {
        __extends(PastCanvas, _super);

        function PastCanvas($el, options) {
          this.$el = $el;
          this.tc = new $.TypeCanvas(this.$el, {
            size: {
              "width": width,
              "height": height
            }
          });
        }

        return PastCanvas;

      })(sn.Event);
      sn.SocketIO = (function() {
        function SocketIO(url) {
          this.socket = io.connect(url);
          this.socketID = null;
          this.socketDefer = new $.Deferred();
          this.socket.on("connect", (function(_this) {
            return function() {
              console.log("socket connect");
              return _this.socket.emit("c-to-s-connect", {});
            };
          })(this));
          this.socket.on("s-to-c-connect", (function(_this) {
            return function(socketID) {
              _this.socketID = socketID;
              return _this.socketDefer.resolve();
            };
          })(this));
          this.socketDefer.promise();
        }

        return SocketIO;

      })();
      sn.tf = new $.TypeFrameWork({
        frameRate: 24
      });
      socketIO = new sn.SocketIO("http://192.168.33.10:3000/");
      isNowCanvas = new sn.NowCanvas($("#js-is-now-canvas"), {
        "socketIO": socketIO
      });
      isPastCanvas = new sn.NowCanvas($("#js-is-past-canvas"));
      sn.tf.setup(function() {
        sn.tf.setMousePressed($(window), function(x, y) {
          socketIO.socket.emit("c-to-s-get-position", "x: " + x + " y: " + y);
          return console.log("x: " + x + " y: " + y);
        });
        return $.when(socketIO.socketDefer).then(function() {
          isNowCanvas.setup();
          return console.log("--- app init ---");
        });
      });
      sn.tf.update(function() {
        return isNowCanvas.update();
      });
      sn.tf.draw(function() {
        return isNowCanvas.draw();
      });
      sn.tf.hover(function() {});
      sn.tf.keyPressed(function(key) {});
      sn.tf.keyReleased(function(key) {});
      sn.tf.click(function() {});
      sn.tf.mouseMoved(function() {
        return sn.tf.setMouseMoved(isNowCanvas.$el, (function(_this) {
          return function(x, y) {
            return isNowCanvas.mouseMoved(x, y);
          };
        })(this));
      });
      sn.tf.mousePressed(function() {});
      sn.tf.mouseReleased(function() {});
      sn.tf.windowScroll(function(top) {});
      sn.tf.windowResized(function(width, height) {
        width = width < CONSTANT.minWidth ? CONSTANT.minWidth : width;
        height = height < CONSTANT.minHeight ? CONSTANT.minHeight : height;
        return isNowCanvas.windowResized(width, height);
      });
      return sn.tf.fullScreenChange(function(full) {});
    });
  })(window, document, jQuery);

}).call(this);

//# sourceMappingURL=main.js.map
