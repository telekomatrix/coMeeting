var mouse_is_outside = false;

$(document).ready(function() {
  // if ($("#flash > div").length > 0) {
  //   setTimeout(hideFlashMessages, 2500);
  // }
  
  $('#drop-button').click(function(){
    $('#bubble').fadeToggle();
  });

  $('#drop-menu').hover(function(){ 
    mouse_is_outside = false;
  }, function(){ 
    mouse_is_outside = true; 
  });

  $("body").mouseup(function(){ 
    if(mouse_is_outside) $('#bubble').fadeOut();
  });
});

function hideFlashMessages() {
  $('#flash').animate({ opacity: 'toggle', height: 'toggle' }, 2500);
}