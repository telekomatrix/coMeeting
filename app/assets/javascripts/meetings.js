$(document).ready(function() {
  
  $('#minutes').tabby()
  .autoResize({
    maxHeight: 1000,
    minHeight: 50
  });

  $('#static_minutes')
  .autoResize({
    maxHeight: 1000,
    minHeight: 50
  });
});

