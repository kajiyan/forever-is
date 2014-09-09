(function() {
  (function(window, document, $) {
    var $document, $window, ns;
    ns = $.TypeCanvas = {};
    $window = $(window);
    $document = $(document);
    ns.TypeCanvas = (function() {
      TypeCanvas.prototype.defaults = {
        size: {
          width: null,
          height: null
        },
        colorMode: "RGB",
        clearBackground: true
      };

      function TypeCanvas($el, options) {
        this.$el = $el;
        if (this.$el == null) {
          this.$el = $("<canvas>");
          $("body").prepend(this.$el);
        }
        this.el = this.$el[0];
        this.options = $.extend({}, this.defaults, options);
        if (!this.el || !this.el.getContext) {
          $.error("It does not support the canvas");
          return false;
        }
        this.setup();
        this.update();
      }

      TypeCanvas.prototype.setup = function() {
        this.context = this.el.getContext("2d");
        return this._size();
      };

      TypeCanvas.prototype._size = function() {
        this.el.width = this.options.size.width != null ? this.options.size.width : $window.innerWidth();
        return this.el.height = this.options.size.height != null ? this.options.size.height : $window.innerHeight();
      };

      TypeCanvas.prototype.update = function(method) {
        if (method == null) {
          method = function() {};
        }
        return method();
      };

      TypeCanvas.prototype.draw = function(method) {
        if (method == null) {
          method = function() {};
        }
        if (this.options.clearBackground) {
          this.context.clearRect(0, 0, $window.width(), $window.height());
        }
        return method();
      };

      TypeCanvas.prototype.mouseMoved = function(method, translate) {
        if (translate == null) {
          translate = "page";
        }
        if (method == null) {
          $.error("Some error TypeCanvas mouseMoved() object.");
        }
        switch (translate) {
          case "page":
            this.$el.on({
              "mousemove": function(e) {
                return method(e.pageX, e.pageY);
              }
            });
            break;
          case "client":
            this.$el.on({
              "mousemove": function(e) {
                return method(e.clientX, e.clientY);
              }
            });
            break;
          case "offset":
            this.$el.on({
              "mousemove": function(e) {
                return method(e.offsetX, e.offsetY);
              }
            });
            break;
          default:
            el.on({
              "mousemove": function(e) {
                return method(e.pageX, e.pageY);
              }
            });
        }
      };

      TypeCanvas.prototype.resize = function(width, height) {
        this.el.width = this.options.size.width != null ? this.options.size.width : width;
        return this.el.height = this.options.size.height != null ? this.options.size.height : height;
      };

      TypeCanvas.prototype.getElement = function() {
        return this.$el;
      };

      TypeCanvas.prototype.getContext = function() {
        return this.context;
      };

      TypeCanvas.prototype.getHeight = function() {
        return this.$el.height();
      };

      TypeCanvas.prototype.getWidth = function() {
        return this.$el.width();
      };

      return TypeCanvas;

    })();
    $.fn.typeCanvas = function(options) {
      return this.each(function(i, el) {
        var $el, instance;
        $el = $(el);
        instance = new ns.TypeCanvas($el, options);
        $el.data("typeCanvas", instance);
      });
    };
    return $.TypeCanvas = ns.TypeCanvas;
  })(window, document, jQuery);

}).call(this);

//# sourceMappingURL=typeCanvas.js.map
