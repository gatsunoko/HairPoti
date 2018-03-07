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

function picture_big(link){
  $('.text_area').css('display', 'block');
  $('.square-wrapper').css('width', '100%');
  //画像を大きいのに変更
  $('.link_span img').each( function() {
      $(this)[0]['src'] = $(this)[0]['src'].replace('size=t', 'size=m');
    });
  //　クリックした画像の位置までスクロール
  window.location.href = '#'+link
  // target = $('#'+link);
  // $('html, body').animate({
  //   scrollTop: target.offset().top,
  // }, 0);

  //onClickイベントを削除
  $('.link_span').each( function() {
    $(this)[0]['onclick'] = "";
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

// ページ遷移前にinfinit scrollをdestroyしておかないとターボリンクのせいでスクロールするたびにバックでリクエストが飛ぶので、ページ遷移前に破棄する
// $(document).on('turbolinks:request-start', function() {
//   console.log( 'before_destroy' );
//   $('.infinite_scroll').infiniteScroll('destroy');
// });