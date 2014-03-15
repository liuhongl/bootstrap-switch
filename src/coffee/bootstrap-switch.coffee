do ($ = window.jQuery, window) ->
  "use strict"

  class BootstrapSwitch
    name: "bootstrap-switch"

    constructor: (element, options = {}) ->
      @$element = $ element
      @options = $.extend {}, $.fn.bootstrapSwitch.defaults, options,
        state: @$element.is ":checked"
        size: @$element.data "size"
        animate: @$element.data "animate"
        disabled: @$element.is ":disabled"
        readonly: @$element.is "[readonly]"
        onColor: @$element.data "on-color"
        offColor: @$element.data "off-color"
        onText: @$element.data "on-text"
        offText: @$element.data "off-text"
        labelText: @$element.data "label-text"
      @$on = $ "<span>",
        class: "#{@options.classes.base}-#{@options.classes.handleOn} #{@options.classes.base}-#{@options.onColor}"
        html: @options.onText
      @$off = $ "<span>",
        class: "#{@options.classes.base}-#{@options.classes.handleOff} #{@options.classes.base}-#{@options.offColor}"
        html: @options.offText
      @$label = $ "<label>",
        class: "#{@options.classes.base}-#{@options.classes.label}"
        for: @$element.attr "id"
        html: @options.labelText
      @$wrapper = $ "<div>"
      @$container = $ "<div>",
        class: "#{@options.classes.base}-#{@options.classes.container}"

      # add wrapper classes
      @$wrapper.addClass =>
        classes = ["#{@options.classes.base}"]

        classes.push if @options.state then "#{@options.classes.base}-#{@options.classes.modifiers.on}" else "#{@options.classes.base}-#{@options.classes.modifiers.off}"
        classes.push "#{@options.classes.base}-#{@options.size}" if @options.size?
        classes.push "#{@options.classes.base}-#{@options.classes.modifiers.animate}" if @options.animate
        classes.push "#{@options.classes.base}-#{@options.classes.modifiers.disabled}" if @options.disabled
        classes.push "#{@options.classes.base}-#{@options.classes.modifiers.readonly}" if @options.readonly
        classes.push "#{@options.classes.base}-id-#{@$element.attr("id")}" if @$element.attr "id"
        classes.join " "

      # set up events
      @$element.on "init.bootstrapSwitch", => @options.onInit.apply @$element[0], arguments
      @$element.on "switchChange.bootstrapSwitch", => @options.onSwitchChange.apply @$element[0], arguments

      console.log @$container

      # reassign elements after dom modification
      @$container = @$element.wrap(@$container).parent()
      @$wrapper = @$container.wrap(@$wrapper).parent()

      # insert handles and label and trigger event
      @$element
      .before(@$on)
      .before(@$label)
      .before(@$off)
      .trigger "init.bootstrapSwitch"

      @_elementHandlers()
      @_handleHandlers()
      @_labelHandlers()
      @_formHandler()

      # TODO: @$label.hasClass "label-change-switch" in toggleState

    _constructor: BootstrapSwitch

    state: (value, skip) ->
      return @options.state if typeof value is "undefined"
      return @$element if @options.disabled or @options.readonly

      value = not not value

      @$element.prop("checked", value).trigger "change.bootstrapSwitch", skip
      @$element

    toggleState: (skip) ->
      return @$element if @options.disabled or @options.readonly

      @$element.prop("checked", not @options.state).trigger "change.bootstrapSwitch", skip

    size: (value) ->
      return @options.size if typeof value is "undefined"

      @$wrapper.removeClass "#{@options.classes.base}-#{@options.size}" if @options.size?
      @$wrapper.addClass "#{@options.classes.base}-#{value}"
      @options.size = value
      @$element

    animate: (value) ->
      return @options.animate if typeof value is "undefined"

      value = not not value

      @$wrapper[if value then "addClass" else "removeClass"]("#{@options.classes.base}-#{@options.classes.modifiers.animate}")
      @options.animate = value
      @$element

    disabled: (value) ->
      return @options.disabled if typeof value is "undefined"

      value = not not value

      @$wrapper[if value then "addClass" else "removeClass"]("#{@options.classes.base}-#{@options.classes.modifiers.disabled}")
      @$element.prop "disabled", value
      @options.disabled = value
      @$element

    toggleDisabled: ->
      @$element.prop "disabled", not @options.disabled
      @$wrapper.toggleClass "#{@options.classes.base}-#{@options.classes.modifiers.disabled}"
      @options.disabled = not @options.disabled
      @$element

    readonly: (value) ->
      return @options.readonly if typeof value is "undefined"

      value = not not value

      @$wrapper[if value then "addClass" else "removeClass"]("#{@options.classes.base}-#{@options.classes.modifiers.readonly}")
      @$element.prop "readonly", value
      @options.readonly = value
      @$element

    toggleReadonly: ->
      @$element.prop "readonly", not @options.readonly
      @$wrapper.toggleClass "#{@options.classes.base}-#{@options.classes.modifiers.readonly}"
      @options.readonly = not @options.readonly
      @$element

    onColor: (value) ->
      color = @options.onColor

      return color if typeof value is "undefined"

      @$on.removeClass "#{@options.classes.base}-#{color}" if color?
      @$on.addClass "#{@options.classes.base}-#{value}"
      @options.onColor = value
      @$element

    offColor: (value) ->
      color = @options.offColor

      return color if typeof value is "undefined"

      @$off.removeClass "#{@options.classes.base}-#{color}" if color?
      @$off.addClass "#{@options.classes.base}-#{value}"
      @options.offColor = value
      @$element

    onText: (value) ->
      return @options.onText if typeof value is "undefined"

      @$on.html value
      @options.onText = value
      @$element

    offText: (value) ->
      return @options.offText if typeof value is "undefined"

      @$off.html value
      @options.offText = value
      @$element

    labelText: (value) ->
      return @options.labelText if typeof value is "undefined"

      @$label.html value
      @options.labelText = value
      @$element

    destroy: ->
      $form = @$element.closest "form"

      $form.off("reset.bootstrapSwitch").removeData "bootstrap-switch" if $form.length
      @$container.children().not(@$element).remove()
      @$element.unwrap().unwrap().off(".bootstrapSwitch").removeData "bootstrap-switch"
      @$element

    _elementHandlers: ->
      @$element.on
        "change.bootstrapSwitch": (e, skip) =>
          e.preventDefault()
          e.stopPropagation()
          e.stopImmediatePropagation()

          checked = @$element.is ":checked"

          return if checked is @options.state

          @options.state = checked
          @$wrapper
          .removeClass(if checked then "#{@options.classes.base}-#{@options.classes.modifiers.off}" else "#{@options.classes.base}-#{@options.classes.modifiers.on}")
          .addClass if checked then "#{@options.classes.base}-#{@options.classes.modifiers.on}" else "#{@options.classes.base}-#{@options.classes.modifiers.off}"

          unless skip
            $("[name='#{@$element.attr('name')}']").not(@$element).prop("checked", false).trigger "change.bootstrapSwitch", true if @$element.is ":radio"
            @$element.trigger "switchChange.bootstrapSwitch", [checked]

        "focus.bootstrapSwitch": (e) =>
          e.preventDefault()
          e.stopPropagation()
          e.stopImmediatePropagation()

          @$wrapper.addClass "#{@options.classes.base}-#{@options.classes.modifiers.focused}"

        "blur.bootstrapSwitch": (e) =>
          e.preventDefault()
          e.stopPropagation()
          e.stopImmediatePropagation()

          @$wrapper.removeClass "#{@options.classes.base}-#{@options.classes.modifiers.focused}"

        "keydown.bootstrapSwitch": (e) =>
          return if not e.which or @options.disabled or @options.readonly

          switch e.which
            when 32
              e.preventDefault()
              e.stopPropagation()
              e.stopImmediatePropagation()

              @toggleState()
            when 37
              e.preventDefault()
              e.stopPropagation()
              e.stopImmediatePropagation()

              @state false
            when 39
              e.preventDefault()
              e.stopPropagation()
              e.stopImmediatePropagation()

              @state true

    _handleHandlers: ->
      @$on.on "click.bootstrapSwitch", (e) =>
        @state false
        @$element.trigger "focus.bootstrapSwitch"

      @$off.on "click.bootstrapSwitch", (e) =>
        @state true
        @$element.trigger "focus.bootstrapSwitch"

    _labelHandlers: ->
      @$label.on
        "mousemove.bootstrapSwitch": (e) =>
          return unless @drag

          percent = ((e.pageX - @$wrapper.offset().left) / @$wrapper.width()) * 100
          left = 25
          right = 75

          if percent < left
            percent = left
          else if percent > right
            percent = right

          @$container.css "margin-left", "#{percent - right}%"
          @$element.trigger "focus.bootstrapSwitch"

        "mousedown.bootstrapSwitch": (e) =>
          return if @drag or @options.disabled or @options.readonly

          @drag = true
          @$wrapper.removeClass "#{@options.classes.base}-#{@options.classes.modifiers.animate}" if @options.animate
          @$element.trigger "focus.bootstrapSwitch"

        "mouseup.bootstrapSwitch": (e) =>
          return unless @drag

          @drag = false
          @$element.prop("checked", (parseInt(@$container.css("margin-left"), 10) > -25)).trigger "change.bootstrapSwitch"
          @$container.css "margin-left", ""
          @$wrapper.addClass "#{@options.classes.base}-#{@options.classes.modifiers.animate}" if @options.animate

        "mouseleave.bootstrapSwitch": (e) =>
          @$label.trigger "mouseup.bootstrapSwitch"

        "click.bootstrapSwitch": (e) =>
          e.preventDefault()
          e.stopImmediatePropagation()

          @toggleState()
          @$element.trigger "focus.bootstrapSwitch"

    _formHandler: ->
      $form = @$element.closest "form"

      return if $form.data "bootstrap-switch"

      $form
      .on "reset.bootstrapSwitch", ->
        window.setTimeout ->
          $form
          .find("input")
          .filter( -> $(@).data "bootstrap-switch")
          .each -> $(@).bootstrapSwitch "state", false
        , 1
      .data "bootstrap-switch", true

  $.fn.bootstrapSwitch = (option, args...) ->
    ret = @
    @each ->
      $this = $ @
      data = $this.data "bootstrap-switch"

      $this.data "bootstrap-switch", data = new BootstrapSwitch @, option if not data
      ret = data[option].apply data, args if typeof option is "string"
    ret

  $.fn.bootstrapSwitch.Constructor = BootstrapSwitch
  $.fn.bootstrapSwitch.defaults =
    state: true
    size: null
    animate: true
    disabled: false
    readonly: false
    onColor: "primary"
    offColor: "default"
    onText: "ON"
    offText: "OFF"
    labelText: "&nbsp;"
    classes:
      base: "bootstrap-switch"
      container: "container"
      wrapper: "wrapper"
      handleOn: "handle-on"
      handleOff: "handle-off"
      label: "label"
      modifiers:
        on: "on"
        off: "off"
        focused: "focused"
        animate: "animate"
        disabled: "disabled"
        readonly: "readonly"
    onInit: ->
    onSwitchChange: ->

