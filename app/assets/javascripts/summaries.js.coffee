# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

ready = ->
  toggle_columns = () ->
    show_all = $("input#show_all_columns").is(":checked");
    $(".no_data").toggleClass("hide",!show_all);
  $("input#show_all_columns").bind 'click', (event) => toggle_columns();

  chart_present = ($('svg').length > 0);

  load_chart = () ->
    $.ajax
      type: 'GET'
      contentType: 'application/json; charset=utf-8'
      url: window.location
      dataType: 'json'
      success: (data) ->
        draw_chart data
        return
      error: (result) ->
        chart_error(result)
        return

  draw_chart = (dataWithSeriesNames) ->

    data = dataWithSeriesNames.data

    margin =
      top: 20
      right: 70
      bottom: 30
      left: 70
    width = 960 - (margin.left) - (margin.right)
    height = 350 - (margin.top) - (margin.bottom)

    color = d3.scale.category10()
    color.domain = dataWithSeriesNames.seriesNames

    #convert dates from string to Javascript date format
    parseDate = d3.time.format('%Y-%m-%d').parse
    i=0
    while i<data.length
      j=0
      while j < data[i].length
        data[i][j][0] = parseDate(data[i][j][0])
        j++
      i++

    dataWithSeriesNames.min_x = parseDate(dataWithSeriesNames.min_x)
    dataWithSeriesNames.max_x = parseDate(dataWithSeriesNames.max_x)

    console.log(dataWithSeriesNames)

    xScale = d3.time.scale().range([
      margin.left
      width + margin.left
    ]).domain([
      dataWithSeriesNames.min_x
      dataWithSeriesNames.max_x
    ])

    yScale = d3.scale.linear().range([
      height + margin.top
      margin.top
    ]).domain([
      dataWithSeriesNames.min_y - (dataWithSeriesNames.max_y-dataWithSeriesNames.min_y)*0.05 #make the x axis slightly below the lowest point
      dataWithSeriesNames.max_y
    ])

    xAxis = d3.svg.axis().scale(xScale).orient('bottom')
    yAxis = d3.svg.axis().scale(yScale).orient('left').tickFormat( (d) ->
      d3.format('$,')(d)
    )

    line = d3.svg.line().interpolate('linear').x((d) ->
      xScale d[0]
    ).y((d) ->
      yScale d[1]
    )

    chart = d3.select('#graph').attr('width', width + margin.left + margin.right).attr('height', height + margin.top + margin.bottom)
    chart.append('g').attr('transform', 'translate(' + margin.left + ',' + margin.top + ')')

    chart.append('g').attr('class', 'x axis').attr('transform', 'translate(0,' + (height + margin.top) + ')')
    .call xAxis

    chart.append('g').attr('class', 'y axis').attr('transform','translate('+ margin.left + ',0)').call yAxis

    #add $ to y axis text
    #d3.selectAll('.y.axis').text( (d) ->
    #  console.log(d)
    #  '$' + d
    #)

    #bind the data to d3
    #and add the data series to the chart
    data_series = d3.select('#graph').selectAll('.data_series').data(data).enter().append('g').attr('class', 'data_series')
    data_series.append('path').attr('class', 'line').attr('d', (d) ->
      line d
    ).style 'stroke', (d,i) ->
      color dataWithSeriesNames.series_names[i]

    #show series name text
    data_series.append('text').datum((d,i) ->
      {
        name: dataWithSeriesNames.series_names[i]
        value: d[0] #data is descending, so first data point is the latest.
      }
    ).attr('transform', (d) ->
      'translate(' + xScale(d.value[0]) + ',' + yScale(d.value[1]) + ')'
    ).attr('x', 5).attr('dy', '.35em').text (d) ->
      d.name
    .style 'fill', (d,i) ->
      color dataWithSeriesNames.series_names[i]

    #show circles to mark each data point
    markers = data_series.selectAll('circle').data((d, i) ->
      d
    ).enter().append('circle').attr('cx', (d) ->
      xScale d[0]
    ).attr('cy', (d) ->
      yScale d[1]
    ).attr('r', 4).attr 'fill', (d, i, seriesNum) ->
      color dataWithSeriesNames.series_names[seriesNum]
    .append("svg:title")
    .text (d,i,seriesNum) ->
      return '('+d[0].toDateString()+',$'+d[1]+') ' + dataWithSeriesNames.series_names[seriesNum]

    #show dashed line at y=zero
    chart.append('line')
      .style("stroke", "black")
      .attr("x1", xScale(dataWithSeriesNames.min_x))   #coordinates of 1st point on line
      .attr("y1", yScale(0))
      .attr("x2", xScale(dataWithSeriesNames.max_x))   #coordinates of 2nd point on line
      .attr("y2", yScale(0))
      .style("stroke-dasharray", ("10, 10"))  #pixels of stroke vs pixels left blank

    return

  chart_error = (result) ->
    $('.chart_error').remove()
    $('#graph').after("<div>" + result.statusText+ "<p class='chart_error'>" + result.responseText + "</p></div>")
    console.log result
    return


  if (chart_present)
    load_chart()


$(document).ready(ready)
$(document).on('page:load', ready)


