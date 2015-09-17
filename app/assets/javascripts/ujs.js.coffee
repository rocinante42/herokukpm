ready = ->
  $(document).on 'click', '.dropdown-wrap .dropdown-action', ->
    false
  $(document).on 'click', '.dropdown.select ul > li > a', ->
    id = $(@).data 'id'
    $(this).closest('.dropdown.select').find('input[type="hidden"]').val id
  $('[data-toggle="tooltip"]').tooltip()

$(document).ready ready
$(document).on 'page:load', ready