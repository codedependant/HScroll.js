class hScroll 
  
  constructor: (element, options={})->
    @element = if element.nodeType? then element else document.querySelector(element)
      
    @mouseover = false
    @mouseX = 0
    @targetScrollLeft = 0
    @speed = options.speed or 100
    @transform = options.transform or false
    
    @element.style.overflow = "hidden"
    
    @element.addEventListener "mouseover", @_mouseOverHandler
    @element.addEventListener "mouseout", @_mouseOutHandler
    @element.addEventListener "mousemove", @_mouseMoveHandler
    
    @_updateScrollPosition()
  
  _mouseOverHandler: (event)=>
    @mouseover = true
  
  _mouseOutHandler: (event)=>
    @mouseover = false
    
  _mouseMoveHandler: (event)=>
    @mouseX = event.clientX - @element.offsetLeft
  
  _trackMousePosition: ->
    elementWidth = if @transform then @element.parentNode.offsetWidth else @element.offsetWidth
      
    position = @mouseX/elementWidth
    scaledPosition = position*2-1
    scrollDelta = Math.pow(scaledPosition, 7)
    scrollDelta = Math.round(scrollDelta*1000)/1000
    @targetScrollLeft +=  scrollDelta*@speed
    @targetScrollLeft = Math.max(0, Math.min(@targetScrollLeft, @element.scrollWidth-elementWidth))
  

  _updateScrollPosition: =>
    @animationFrameID = requestAnimationFrame =>
      @_update()
      @animationFrameID = requestAnimationFrame @_updateScrollPosition
    
  _update: ->
    @_trackMousePosition() if @mouseover
    if @transform
      @element.style.transform = "translateX(#{-@targetScrollLeft}px)"
    else
      @element.scrollLeft = @targetScrollLeft
    
  destroy: ->
    cancelAnimationFrame @animationFrameID
    @element.removeEventListener "mouseover", @_mouseOverHandler
    @element.removeEventListener "mouseout", @_mouseOutHandler
    @element.removeEventListener "mousemove", @_mouseMoveHandler
    @

