$ ->
  #Display horizontal graph

  #tooltip function
  showTooltip = (x, y, contents, areAbsoluteXY) ->
    rootElt = "body"
    $("<div id=\"tooltip3\" class=\"tooltip\">" + contents + "</div>").css(
      position: "absolute"
      display: "none"
      top: y - 35
      left: x - 5
      "z-index": "9999"
      color: "#fff"
      "font-size": "11px"
      opacity: 0.8
    ).prependTo(rootElt).show()
  previousPoint = undefined
  d1_h = []
  i = 0

  while i <= 3
    d1_h.push [parseInt(Math.random() * 30), i]
    i += 1
  d2_h = []
  i = 0

  while i <= 3
    d2_h.push [parseInt(Math.random() * 30), i]
    i += 1
  d3_h = []
  i = 0

  while i <= 3
    d3_h.push [parseInt(Math.random() * 30), i]
    i += 1
  ds_h = new Array()
  ds_h.push
    data: d1_h
    bars:
      horizontal: true
      show: true
      barWidth: 0.2
      order: 1

  ds_h.push
    data: d2_h
    bars:
      horizontal: true
      show: true
      barWidth: 0.2
      order: 2

  ds_h.push
    data: d3_h
    bars:
      horizontal: true
      show: true
      barWidth: 0.2
      order: 3

  $.plot $("#placeholder1_hS"), ds_h,
    grid:
      hoverable: true


  #add tooltip event
  $("#placeholder1_hS").bind "plothover", (event, pos, item) ->
    if item
      unless previousPoint is item.datapoint
        previousPoint = item.datapoint

        #delete de prГ©cГ©dente tooltip
        $(".tooltip").remove()
        x = item.datapoint[0]

        #All the bars concerning a same x value must display a tooltip with this value and not the shifted value
        if item.series.bars.order
          i = 0

          while i < item.series.data.length
            x = item.series.data[i][0]  if item.series.data[i][3] is item.datapoint[0]
            i++
        y = item.datapoint[1]
        showTooltip item.pageX + 5, item.pageY + 5, x + " = " + y
    else
      $(".tooltip").remove()
      previousPoint = null

