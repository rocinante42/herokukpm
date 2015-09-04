ready = ->
  $(document).on 'click', '.dropdown-wrap .dropdown-action', ->
    false

$(document).ready ready
$(document).on 'page:load', ready