$(document).on 'click', '.dropdown.select ul > li > a', () ->
  selected = $ @
  id = selected.data('id')
  dropdown = selected.closest '.dropdown'
  #dropdown.find('li').removeClass 'hidden'
  #if dropdown.find('li').length > 1
  #  selected.closest('li').addClass 'hidden'
  dropdown.find('.dropdown-toggle span.value').text selected.text()
  input = dropdown.find 'input[type=hidden]'
  if input.length
    input.val id
