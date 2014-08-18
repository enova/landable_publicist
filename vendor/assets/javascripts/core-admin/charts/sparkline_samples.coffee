$ ->
  colors = $.map Theme.colors, (item) -> item

  tooltipLabels =
    names:
      0: 'Automotive'
      1: 'Locomotive'
      2: 'Unmotivated'
      3: 'Three'
      4: 'Four'
      5: 'Five'

  initPieChart = ->
    width = $(".spark-pie").width()

    width = 200 if width > 200

    $(".spark-pie").sparkline([55,100,220,180],
      type: 'pie'
      height: width
      sliceColors: colors
      tooltipFormat: '<span style="color: {{color}}">&#9679;</span> {{offset:names}} ({{percent.1}}%)'
      tooltipValueLookups: tooltipLabels
    )

  #here goes a hack for the sparkline bar chart to make it somewhat responsive:

  initBarChart = (data, object) ->
    currentWidth = object.width()
    barCount = data.length
    barSpacing = 5
    widthLeftForBars = currentWidth-(barCount-1)*barSpacing
    barWidth = widthLeftForBars/barCount

    object.sparkline data,
      type: "bar"
      barColor: Theme.colors.blue
      height: 200
      barWidth: barWidth
      barSpacing: barSpacing
      tooltipSuffix: "$ income received"

  barChartDataset = [4, 1, 5, 7, 9, 9, 8, 7, 6, 6, 4, 7, 8, 4, 3, 2, 2, 5, 6, 7]
  lineChartDataset = [6, 3, 8, 5, 8, 4, 3, 2, 7, 6, 6, 4, 7, 2, 5, 6, 7, 2, 4, 11]

  initLineChart = ->
    $(".spark-composite").sparkline lineChartDataset,
      composite: true
      fillColor: false
      lineColor: Theme.colors.red
      width: "100%"
      height: '200'
      spotColor: Theme.colors.lightBlue
      lineWidth: 3
      maxSpotColor: Theme.colors.red
      highlightSpotColor: Theme.colors.orange
      highlightLineColor: Theme.colors.orange
      chartRangeMin: 0
      spotRadius: 4
      drawNormalOnTop: false
      tooltipSuffix: " orders sent"

  initBarChart(barChartDataset, $(".spark-composite"))
  initLineChart()
  initPieChart()

  $(window).resize ->
    initBarChart(barChartDataset, $(".spark-composite"))
    initLineChart()
    initPieChart()


  #here goes the animated chart with mouse speed
  drawMouseSpeedDemo = ->
    mrefreshinterval = 100 # update display every 100ms
    lastmousex = -1
    lastmousey = -1
    lastmousetime = undefined
    mousetravel = 0
    mpoints = []
    mpoints_max = 30
    $("html").mousemove (e) ->
      mousex = e.pageX
      mousey = e.pageY
      mousetravel += Math.max(Math.abs(mousex - lastmousex), Math.abs(mousey - lastmousey))  if lastmousex > -1
      lastmousex = mousex
      lastmousey = mousey

    mdraw = ->
      md = new Date()
      timenow = md.getTime()
      if lastmousetime and lastmousetime isnt timenow
        pps = Math.round(mousetravel / (timenow - lastmousetime) * 1000)
        mpoints.push pps
        mpoints.splice 0, 1  if mpoints.length > mpoints_max
        mousetravel = 0
        $(".spark-mouse").sparkline mpoints,
          type: 'line'
          width: "100%"
          height: '200'
          chartRangeMin: 0
          chartRangeMax: 3000
          lineColor: Theme.colors.blue
          fillColor: Theme.colors.lightBlue
          spotColor: Theme.colors.lightBlue
          lineWidth: 3
          maxSpotColor: Theme.colors.red
          highlightSpotColor: Theme.colors.orange
          highlightLineColor: Theme.colors.orange
          spotRadius: 4
          drawNormalOnTop: false
          tooltipSuffix: " pixels per second"

      lastmousetime = timenow
      setTimeout mdraw, mrefreshinterval
    setTimeout mdraw, mrefreshinterval

  drawMouseSpeedDemo() if  $(".spark-mouse").length > 0
