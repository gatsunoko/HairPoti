function close_like_persons(id) {
  $('.like_persons_area').remove();
  $('#like_users_display'+id+' a').css('pointer-events', 'auto');
  swiper.update();
}