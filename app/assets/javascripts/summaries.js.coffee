# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  toggle_columns = () ->
    show_all = $("input#show_all_columns").is(":checked");
    $(".no_data").toggleClass("hide",!show_all);
  $("input#show_all_columns").bind 'click', (event) => toggle_columns();