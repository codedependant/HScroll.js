class HScroll
  
  constructor: (element, options={})->
    @element = if element.nodeType? then element else document.querySelector(element)
      
    @mouseover        = false
    @mouseX           = 0
    @targetScrollLeft = 0
    @scrollDelta      = 0
    @speed            = options.speed or 100
    @transform        = options.transform or false
    @acceleration     = options.acceleration or .7
    @velocity         = 0
    @position         = 0
    

    @element.addEventListener "mouseover", @_mouseOverHandler
    @element.addEventListener "mouseenter", @_mouseEnterHandler
    @element.addEventListener "mouseleave", @_mouseLeaveHandler
    @element.addEventListener "mousemove", @_mouseMoveHandler

    @_updateWidths()
    window.addEventListener("resize", @_updateWidths)

  _mouseEnterHandler: (event)=>
    @_updateScrollPosition()

  _mouseOverHandler: (event)=>
    @mouseover = true
    @_updateScrollPosition() unless @animationFrameID?


  _mouseLeaveHandler: (event)=>
    @mouseover = false
    @_stopUpdates()
    
  _mouseMoveHandler: (event)=>
    @mouseX = event.clientX - @element.offsetLeft
  
  _trackMousePosition: ->
    position = @mouseX/@elementWidth
    scaledPosition = position*2-1
    @scrollDelta = Math.pow(scaledPosition, 7)
    @scrollDelta = Math.round(@scrollDelta*1000)/1000
    
    @velocity +=  @scrollDelta*@speed
   
    
  _updateScrollPosition: =>
    @animationFrameID = requestAnimationFrame =>
      @_update()
      @animationFrameID = requestAnimationFrame @_updateScrollPosition

  _stopUpdates: ->
    cancelAnimationFrame @animationFrameID
    delete @animationFrameID


  _update: ->
    @velocity += @scrollDelta*20
    @velocity *= @acceleration
    @position += @velocity
    @scrollDelta = 0

    @position = Math.min(Math.max(0, @position), @maxWidth)

    @_trackMousePosition() if @mouseover
    if @transform
      @element.style.transform = "translateX(#{-@position}px)"
    else
      @element.scrollLeft = @position
    
  _updateWidths: ->
    @elementWidth = if @transform then @element.parentNode.offsetWidth else @element.offsetWidth
    @maxWidth = @element.scrollWidth - @element.offsetWidth

  destroy: ->
    @_stopUpdates()
    window.removeEventListener("resize", @_updateWidths)
    @element.removeEventListener "mouseover", @_mouseOverHandler
    @element.removeEventListener "mouseout", @_mouseOutHandler
    @element.removeEventListener "mousemove", @_mouseMoveHandler
    @


