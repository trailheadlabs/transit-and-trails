var autoFit = function(){
  $('#find-map').width($('#plan').outerWidth()-$('#park').outerWidth());
  $('#find-map').height($('body').outerHeight()-$('.embed-header').outerHeight()-4);    
  $('#embed-plan-modal').width($('body').outerWidth()-20);
  $('#embed-plan-modal').height($('body').outerHeight()-20);

  if($('body').width() < 500){
    $('body .embed, #plan-embed').addClass('tablet')
  } else {
    $('body .embed, #plan-embed').removeClass('tablet')
  }
  if($('body').width() < 300){
    $('body .embed, #plan-embed').addClass('phone')
  } else {
    $('body .embed, #plan-embed').removeClass('phone')
    $('#trail-list').height($('body').outerHeight()-$('#park-header').outerHeight()-$('.embed-header').outerHeight());      
  }

}

$(function(){
  $(window).resize(function(){
    autoFit();
    TNT.find.map.setCenter(TNT.parklatlngbounds.getCenter(), TNT.find.map.getBoundsZoomLevel(TNT.parklatlngbounds));
  });

  autoFit();
});