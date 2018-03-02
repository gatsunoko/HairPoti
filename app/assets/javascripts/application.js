// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery.turbolinks
//= require jquery_ujs
//= require infinite-scroll.pkgd.min
//= require turbolinks
//= require popper
//= require bootstrap-sprockets
//= require_tree .

function img_blank(picture_id) {
  $.ajax({
      url: '/conflict/img_blank',
      type: 'GET',
      data: {
        picture_id: picture_id
      },
    })
    .done(function(response){
    })
    .fail(function(xhr){
    });
}

$(document).on('turbolinks:load', function() {
  var menuHeight = $("#haeder").height();
  var startPos = 0;
  $(window).scroll(function(){
    var currentPos = $(this).scrollTop();
    if (currentPos > startPos) {
      if($(window).scrollTop() >= 200) {
        $("#haeder").css("top", "-" + menuHeight + "px");
      }
    } else {
      $("#haeder").css("top", 0 + "px");
    }
    startPos = currentPos;
  });
});