$(function() {
  // $("ul.tabs").tabs(".panes > section");

  $('.home-row h1').each(function(index) {
    $el = $(this)
    $el.html('<span>' + $el.text() + '</span>')
  })

  // mobile
  $('#nav-toggle').on('click',function(e){
    $('#main-nav').toggleClass('expanded');
    $(this).toggleClass('expanded');
  });

});