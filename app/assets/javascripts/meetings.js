$(document).ready(function() {
  // locale = $('#locale').val();

  // if (locale != undefined){
  //   if (locale=='pt')
  //     locale = PT;
  //   else
  //     locale = EN;

  //   $('#date_picker').DatePicker({
  //     flat: true,
  //     format: 'd/m/Y',
  //     date: $('#meeting_date').val(),
  //     locale: locale,
  //     calendars: 1,
  //     onChange: function(formated, dates){
  //       $('#meeting_date').val(formated);
  //     }
  //   });
  // }
  
  if (is_creator != undefined){
    // $('#minutes')
    // .autoResize({
    //   maxHeight: 500,
    //   minHeight: 490,
    //   maxWidth: 560,
    //   minWidth: 560
    // });
    // I guess if everything has a fixed size then this is not needed?

    if (is_creator == 'true') {
      _initMinutesListener();
      $('#minutes').tabby();
    }
    else {
      setInterval('getMinutes()', 4000);
    }
  }
});


function updateMinutes() {
  $.ajax({
    type    : 'POST',
    url     : '/meetings/'+participation_id+'/update_minutes',
    data    : { authenticity_token: $('meta[name="csrf-token"]').attr('content'), minutes: $('#minutes').val() },
  });
}

function getMinutes() {
  /*$.ajax({
    type    : 'GET',
    url     : '/meetings/'+participation_id+'/show_minutes'
  });*/
}


// idle.js (c) Alexios Chouchoulas 2009
// Released under the terms of the GNU Public License version 2.0 (or later).
  
var _idleTimeout = 4000;  // 5 seconds
 
var _idleNow = false;
var _idleTimestamp = null;
var _idleTimer = null;
 
function setIdleTimeout(ms){
    _idleTimeout = ms;
    _idleTimestamp = new Date().getTime() + ms;
    if (_idleTimer != null) {
    clearTimeout (_idleTimer);
    }
    _idleTimer = setTimeout(_makeIdle, ms + 50);
};
 
function _makeIdle(){
  var t = new Date().getTime();
  if (t < _idleTimestamp) {
    _idleTimer = setTimeout(_makeIdle, _idleTimestamp - t + 50);
    return;
  }
  _idleNow = true;
  updateMinutes();
};
 
function _active(event){
    var t = new Date().getTime();
    _idleTimestamp = t + _idleTimeout;
 
  if(_idleNow){
    setIdleTimeout(_idleTimeout);
  }
 
  _idleNow = false;
};
 
function _initMinutesListener(){
  var doc = $(document);
  doc.ready(function(){
    try {
      doc.keydown(_active);
    } catch (err) { }
  });
};


$('#attending a').click(function(){
  $(this).parent().slideUp();
});


var topicNumber = document.getElementById('topicNumber');
var topicsDiv = document.getElementById("topicsDiv");

/* Add new on key up */
$('#topicsDiv div:last-child input').live('keyup', function(){
    if ($(this).val() != "") {
      var num = parseInt(topicNumber.value);
      var newDiv = document.createElement('div');
      newDiv.innerHTML = "<input class='text_field_no_border' name='meeting[topics][]' type='text' placeholder='" + t[locale]['new_topic'] + "'> <img src='/assets/buttons/buttonXpart.png' alt='' class='delete_button clickable'>";
      topicsDiv.appendChild(newDiv);

      topicNumber.value = num + 1;
    }
  });

/* Remove topic on click*/
$('#topicsDiv img').live('click', function(){
  if(topicsDiv.childElementCount > 1){
    $(this).parent().remove();
  }
  else{
    $(this).prev().val('');
  }
});

/* Remove topic input when blank and out of focus*/
$('#topicsDiv div:not(:last-child) input').live('focusout', function(){
  if($(this).val() == ''){
    $(this).parent().remove();
  }  
});


var participantNumber = document.getElementById('participantNumber');
var participantsDiv = document.getElementById("participantsDiv");

/* Add participant on click */
$('#participantsDiv div:last-child input').live('keyup', function(){
    if ($(this).val() != "") {
      var num = parseInt(participantNumber.value);
      var newDiv = document.createElement('div');
      newDiv.innerHTML = "<input class='text_field_no_border' name='participants[]' type='text' placeholder='" + t[locale]['new_participant'] + "'> <img src='/assets/buttons/buttonXpart.png' alt='' class='delete_button clickable'>";
      participantsDiv.appendChild(newDiv);
      participantNumber.value = num + 1;
    }
  });

/* Remove participant on click */
$('#participantsDiv img').live('click', function(){
  if(participantsDiv.childElementCount > 1){
    $(this).parent().remove();
  }
  else{
    $(this).prev().val('');
  }
});

/* Remove topic input when blank and out of focus*/
$('#participantsDiv div:not(:last-child) input').live('focusout', function(){
  if($(this).val() == ''){
    $(this).parent().remove();
  }  
});


$('#edit').click(function(){
  $("#form").slideUp(800, function(){
    $("#dlp").hide();
    $("#confirm").removeClass('home-button');
    $("#confirm").addClass('confirm-button');
    $("#confirm").show();
    $("#form-edit").slideDown(800, function(){

    });
  });
});

$('#cancel').click(function(){
  $("#form-edit").slideUp(800, function(){
    $("#confirm").hide();
    $("#dlp").show();
    $("#form").slideDown(800, function(){
    });
  }); 
});

$('#edite').click(function(){
  alert('a');
  if( $('span#presence').val() == "Going"){
    $('span#presence').val('Not Going');
  }
  else if($('#presence').val() == "Not Going"){
    $('span#presence').val('Going'); 
  }
  else{
    $('span#presence').val('Going'); 
  }
});

$('span.participant_email img').live('click', function(){
  $(this).slideToggle('slow', function() {
    $(this).slideToggle();
  });
});

