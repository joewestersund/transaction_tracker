ready = ->
  $('#clear_filter').on 'click', () ->
    url = $("form:first").attr("action") # the page name, with no params
    window.location.href = url

$(document).on('turbolinks:load', ready)