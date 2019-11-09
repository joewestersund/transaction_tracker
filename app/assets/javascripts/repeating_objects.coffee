ready = ->
  showHide =(elementID) ->
    thisElement = $('#' + elementID)
    value = thisElement.children("option:selected").val()
    $('.' + elementID + '-' + value).show(100)
    thisElement.find('option').not(":selected").each ->
      value = $(this).val()
      $('.' + elementID + '-' + value).hide(100)
  showHide('repeat-period')
  showHide('end-type')
  $('#end-type').on 'change', () ->
    showHide('end-type')

$(document).on('turbolinks:load', ready)