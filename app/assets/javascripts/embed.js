var autoFit = function(){
  $('#find-map').width($('#plan').outerWidth()-$('#park').outerWidth());
  $('#find-map').height($('html').outerHeight()-$('.embed-header').outerHeight());    

  if($('body').width() < 500){
    $('body .embed, #plan-embed').addClass('tablet');
  } else {
    $('body .embed, #plan-embed').removeClass('tablet');
  }
  if($('body').width() < 300){
    $('body .embed, #plan-embed').addClass('phone');
  } else {
    $('body .embed, #plan-embed').removeClass('phone');
    $('#trail-list').outerHeight($('body').outerHeight()-$('#park-header').outerHeight()-$('.embed-header').outerHeight()-$('.legend').outerHeight());      
  }
}

$(function(){
  $(window).resize(function(){
    autoFit();
    TNT.find.map.fitBounds(TNT.parklatlngbounds);
  });
  
  $('#more-desc-link').click(function(){
    $('.short-description').hide();
    $('.full-description').show();
  });
  $('#less-desc-link').click(function(){
    $('.full-description').hide();
    $('.short-description').show();
  });
  autoFit();
  $(window).load(function(){
    
    autoFit();  
  });
  
});