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
  $.ajax({
    type    : 'GET',
    url     : '/meetings/'+participation_id+'/show_minutes'
  });
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
/* FIX ME - MARTELADAS */
var localeTopic = null;
var localeParticipant = null;

$('#topicsDiv div:last-child input').live('keyup', function(){
    if ($(this).val() != "") {
      $(this).removeClass('text_field_new');
      $(this).addClass('text_field3');
      var num = parseInt(topicNumber.value);
      var newDiv = document.createElement('div');
      newDiv.innerHTML = "<input class='text_field_new' name='meeting[topics][]' type='text' value='" + localeTopic + "'> <img src='/assets/buttons/buttonXpart.png' alt='' class='clickable'>";
      topicsDiv.appendChild(newDiv);

      topicNumber.value = num + 1;
    }
  });

$('#topicsDiv div:last-child input').live('click',function(){
  if(localeTopic == null){
    localeTopic = $(this).val();
  }
  $(this).val('');
});

$('#topicsDiv div:last-child input').live('focusout',function(){
  if($(this).val() == ""){
    $(this).removeClass('text_field3');
    $(this).addClass('text_field_new');
    $(this).val(localeTopic);
  }
});

$('#topicsDiv img').live('click', function(){
  if(topicsDiv.childElementCount > 2){
    $(this).parent().remove();
  }
  else{
    $(this).prev().val('');
  }
});


var participantNumber = document.getElementById('participantNumber');
var participantsDiv = document.getElementById("participantsDiv");


$('#participantsDiv div:last-child input').live('keyup', function(){
    if ($(this).val() != "") {
      $(this).removeClass('text_field_new');
      $(this).addClass('text_field3');
      var num = parseInt(participantNumber.value);
      var newDiv = document.createElement('div');
      newDiv.innerHTML = "<input class='text_field_new' name='participants[]' type='text' value='" + localeParticipant + "'> <img src='/assets/buttons/buttonXpart.png' alt='' class='clickable'>";
      participantsDiv.appendChild(newDiv);
      participantNumber.value = num + 1;
    }
  });

$('#participantsDiv div:last-child input').live('click',function(){
  if(localeParticipant == null){
    localeParticipant = $(this).val();
  }
  $(this).val('');
});

$('#participantsDiv div:last-child input').live('focusout',function(){
  if($(this).val() == ""){
    $(this).removeClass('text_field3');
    $(this).addClass('text_field_new');
    $(this).val(localeParticipant);
  }
});

$('#participantsDiv img').live('click', function(){
  if(participantsDiv.childElementCount > 2){
    $(this).parent().remove();
  }
  else{
    $(this).prev().val('');
  }
});

$('.participantDiv img').live('click', function(){

})


$('#edit').click(function(){
  $("#form").slideUp(800, function(){
    $("#dlp").hide();
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
