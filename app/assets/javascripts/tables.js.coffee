ready = ->
  $('#show_filter').on 'click', () ->
    $('.filter').toggleClass('hidden')

$(document).ready(ready)
$(document).on('page:load', ready)