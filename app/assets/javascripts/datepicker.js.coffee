ready = ->
  init_datepicker =  () ->
  $('.datepicker').datepicker({ format: 'yyyy-mm-dd', todayBtn: "linked", autoclose: true});

$(document).ready(ready)
$(document).on('page:load', ready)