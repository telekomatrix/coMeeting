var hidden = true;
var button_text;

$("#new").click(function(e){
  if (hidden){
    $("#form").slideDown(800, function(){
        button_text = $("#new").text();
    });
    hidden = false;
    e.preventDefault();
  }
  else{
    hidden = true;
  }
});


$("#cancel").click(function(e){
  if (hidden){
    //resetForm($('#new_meeting'));
  }
  else{
    $("#form").slideUp(800, function(){
        button_text = $("#new").text();
    });
    //resetForm($('#new_meeting'));
    hidden = true;
  }
  e.preventDefault();
});

function resetForm($form){
  $form.find('input:text, input:password, input:file, select').val('');
  $form.find('input:radio, input:checkbox')
       .removeAttr('checked').removeAttr('selected');
};