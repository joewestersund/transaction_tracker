ready = ->
  $('#show_filter').on 'click', () ->
    $('.filter').toggleClass('hidden')

$(document).on('turbolinks:load', ready)