// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require bootstrap-table
//= require bootstrap-sprockets
//= require_tree .

function truncateText(text,length) {
    return text.length > length ? text.substring(0, length - 3) + '...' : text;
}

function initDropdownSelect(classroom_hash)
{
  $('.dropdown.select.classroomType ul > li > a').click(function(){
    var id = $(this).data('id');
    var classrooms = classroom_hash[id];
    var length = 17;
    $('.dropdown.select.classroom ul').html('');
    if(typeof classrooms !== 'undefined' && classrooms.length)
    {
      $('.dropdown.select.classroom span.value').text(truncateText(classrooms[0][1],length));
      $('.dropdown.select.classroom input[type="hidden"]').val(classrooms[0][0]);
      classrooms.forEach(function(el){
        $('.dropdown.select.classroom ul').append('<li><a href="javascript:" data-id="' + el[0] + '">' + truncateText(el[1],length) + '</a></li>');
      });
      $('.dropdown.select.classroom .dropdown-toggle').attr('data-toggle', 'dropdown');
    }
    else
    {
      $('.dropdown.select.classroom span.value').text('');
      $('.dropdown.select.classroom .dropdown-toggle').attr('data-toggle', '');
    }
  });
}

function initUserDropdownSelect()
{
  $('.dropdown.select ul > li > a').off('click').on('click', function(){
    var id   = $(this).data('id');
    var form = $('#updateClassrooms');
    if($(this).closest('.form-group').hasClass('role'))
      form.find('#role_id').val(id);
    if($(this).closest('.form-group').hasClass('school'))
      form.find('#school_id').val(id);
    if($(this).closest('.form-group').hasClass('classroom'))
      form.find('#classroom_id').val(id);
    form.submit();
  });
}

function initTriggerDropdownSelect()
{
  $('.dropdown.select.bubbleGroups ul > li > a').off('click').on('click', function(){
    var id   = $(this).data('id');
    var form = $('#updateBubbles');
    form.find('#bubble_group_id').val(id);
    form.submit();
  });
}

