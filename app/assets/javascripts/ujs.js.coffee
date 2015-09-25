ready = ->
  $(document).on 'click', '.dropdown.select ul > li > a', ->
    id = $(@).data 'id'
    target = $(@).closest('.dropdown.select').data 'target'
    if target
      $("##{target}").val id
    else
      $(this).closest('.dropdown.select').find('input[type="hidden"]').val id
  $('[data-toggle="tooltip"]').tooltip()

$(document).ready ready
$(document).on 'page:load', ready