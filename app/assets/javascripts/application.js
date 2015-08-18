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
//= require bootstrap-sprockets
//= require_tree .

function initDropdownSelect(classroom_hash)
{
  $('.dropdown.select.classroomType ul > li > a').click(function(){
    var id = $(this).data('id');
    var classrooms = classroom_hash[id];
    $('.dropdown.select.classroom ul').html('');
    if(classrooms.length)
    {
      $('.dropdown.select.classroom span.value').text(classrooms[0][1]);
      $('.dropdown.select.classroom input[type="hidden"]').val(classrooms[0][0]);
    }
    else
    {
      $('.dropdown.select.classroom span.value').text('');
    }
    classrooms.forEach(function(el){
      $('.dropdown.select.classroom ul').append('<li><a href="javascript:" data-id="' + el[0] + '">' + el[1] + '</a></li>');
    });
  });
}
