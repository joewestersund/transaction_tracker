ready = ->
  $('#clear_filter').on 'click', () ->
    $('.filter input[type="number"]').attr('value','')
    $('.filter input[type="text"]').attr('value','')
    $('.filter select option').attr('selected',false) #deselect all options
    $('.filter select option:first').attr('selected',true) #select the first option
    $('.filter form').submit() #submit the form with the new, blank values

$(document).ready(ready)
$(document).on('page:load', ready)