var hidden = true;
var button_text;

$("#new").click(function(e){
  if (hidden){
    $("#line").toggle(500, function(){
      $("#fields").animate({height: 'toggle' }, 500, function(){
        $("#line").toggle(500);
        button_text = $("#new").text();
        $("#new").text("✓");
        $("#cancel").show();
      });
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
    $(this).hide();
    $("#line").toggle(500, function(){
      $("#fields").animate({height: 'toggle' }, 500, function(){
        $("#line").toggle(500);
        $("#new").text(button_text);
      });
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