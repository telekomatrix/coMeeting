var hidden = true;
var button_text;

$('#meeting_date').datepicker({
  dateFormat: 'dd/mm/yy'
});

/*$(document).on("focus", "[data-behaviour~='datepicker']", function(e){
    $(this).datepicker({"format": "yyyy-mm-dd", "weekStart": 1, "autoclose": true});
});*/

function checkNameOrEmail(){
  if($("#creator_email").val() != "" || $("#creator_name").val() != ""){
    $("#new").removeClass("pending-button");
    $("#new").addClass("confirm-button");
    $('#new').attr('title', t[locale]['confirm_title']);
  }
  else{
    $("#new").removeClass("confirm-button");
    $("#new").addClass("pending-button");
    $('#new').attr('title', t[locale]['pending_title']);
  }
}

$("#creator_email").live('keyup', checkNameOrEmail);
$("#creator_name").live('keyup', checkNameOrEmail);

$("#new").click(function(e){
  if (hidden){
    $("#new").removeClass("home-button");
    $("#new").addClass("pending-button");
    $('#new').attr('title', t[locale]['pending_title']);
    $(".home_info").hide();
    $("#form").slideDown(800, function(){
        button_text = $("#new").text();
        $(this).find('input').filter(':first').focus();
    });
    hidden = false;
    e.preventDefault();
  }
  else if($("#creator_email").val() == "" && $("#creator_name").val() == ""){
    e.preventDefault();
  }
});

$("#cancel").click(function(e){
  if (!hidden){
    $("#form").slideUp(800, function(){
        button_text = $("#new").text();
        $("#new").removeClass("pending-button");
        $("#new").removeClass("confirm-button");
        $("#new").addClass("home-button");
        $(".home_info").fadeIn(2000);
    });
    hidden = true;
  }
  //resetForm($('#new_meeting'));
  e.preventDefault();
});

function resetForm($form){
  $form.find('input:text, input:password, input:file, select').val('');
  $form.find('input:radio, input:checkbox')
    .removeAttr('checked').removeAttr('selected');
};