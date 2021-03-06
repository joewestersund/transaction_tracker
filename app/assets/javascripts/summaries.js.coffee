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

    currencyFormat = d3.format('$,')  # $5.13 or -$1,000

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
      currencyFormat(d)
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

    #bind the data to d3
    #and add the data series to the chart
    data_series = d3.select('#graph')
    .selectAll('.data_series')
    .data(data).enter()
    .append('g')
    .attr('class', 'data_series')

    data_series.append('path')
    .attr('class', 'line')
    .attr('d', (d) ->
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

    #tooltip for circles in graph
    tip = d3.tip()
    .attr('class', 'd3-tip')
    .html((d,i,seriesNum) ->
      date = "#{d[0].getMonth()+1}/#{d[0].getDate()}/#{d[0].getFullYear()}"
      "<span><div>#{date}</div><div>#{currencyFormat(d[1])}</div><div>#{dataWithSeriesNames.series_names[seriesNum]}</div></span>"
    )

    chart.call(tip) #start d3-tip tooltip code

    circleSize = 4
    circleSizeHover = 6

    #show circles to mark each data point
    markers = data_series.selectAll('circle').data((d, i) ->
      d
    ).enter().append('circle')
    .attr('cx', (d) ->
      xScale d[0]
    ).attr('cy', (d) ->
      yScale d[1]
    ).attr('r', circleSize)
    .attr 'fill', (d, i, seriesNum) ->
      color dataWithSeriesNames.series_names[seriesNum]
    .on('mouseover', tip.show)
    .on('mouseout',tip.hide)

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


$(document).on('turbolinks:load', ready)


