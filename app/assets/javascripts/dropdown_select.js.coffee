$(document).on 'click', '.dropdown.select ul > li > a', () ->
  selected = $ @
  dropdown = selected.closest '.dropdown'
  dropdown.find('li').removeClass 'hidden'
  selected.closest('li').addClass 'hidden'
  dropdown.find('.dropdown-toggle span.value').text selected.text()
  input = dropdown.find 'input[type=hidden]'
  if input.length
    input.val selected.text()
