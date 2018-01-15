ready = ->
  init_datepicker =  () ->
  $('.datepicker').datepicker({ format: 'yyyy-mm-dd', todayBtn: "linked", autoclose: true});

$(document).on('turbolinks:load', ready)