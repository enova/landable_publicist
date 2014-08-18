#calendar events.
#this is a simple wrapper over the fullcalendar events list that enables events creation and edit
# -> it does not persist anything, I wrote it just for demo purposes
# -> it doesn't have any written tests and it might have bugs, feel free to use it however you wish :)

class @CalendarEvent
  constructor: (@container, add) ->
    @container.bind "dblclick", @handleDoubleClick

    if add?
      input = @container.find("input")
      input.focus()
      input.bind "keyup", @handleInputKeyup
      input.bind "blur", @handleInputBlur
    else
      @makeFullCalendarEventObject()

  handleInputKeyup: (e) =>
    input = $(e.target)
    if e.keyCode == 13
      if input.val().length == 0
        @container.remove()
      else
        @finalizeEvent(input.val())

  handleInputBlur: (e) =>
    input = $(e.target)
    if input.val().length == 0
      @container.remove()
    else
      @finalizeEvent(input.val())

  finalizeEvent: (val) =>
    @container.find("a").html(val)
    @makeFullCalendarEventObject()

  handleDoubleClick: (e) =>
    input = $("<input type='text'>")
    link = $(e.target)
    oldval = link.text()
    input.val(oldval)
    link.html(input)
    input.focus()

    input.bind "keyup", (e) =>
      if e.keyCode == 13
        if input.val().length > 0
          link.html(input.val())
          @makeFullCalendarEventObject()
        else
          link.html(oldval)

    input.bind "blur", (e) =>
      if input.val().length > 0
        link.html(input.val())
        @makeFullCalendarEventObject()
      else
        link.html(oldval)

  makeFullCalendarEventObject: =>
    link = $(@container)
    eventObject = title: $.trim(link.text())
    link.data('eventObject', eventObject);
    link.draggable
      zIndex: 999
      revert: true
      revertDuration: 0

class @CalendarEvents
  constructor:(@container) ->
    @addLink = @container.find("#add-event")
    @container.find("a.external-event").each -> new CalendarEvent($(@))
    @template = "<li><a class='external-event'><input type='text'></a></li>"
    @addLink.bind "click", @handleAddLink

  handleAddLink: =>
    view = $(@template)
    view.insertBefore @addLink.parent()
    new CalendarEvent(view, true)
