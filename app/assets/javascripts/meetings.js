$(document).ready(function() {

  locale = $("#locale").val();

  if (locale != undefined){
    if (locale=="pt")
      locale = PT;
    else
      locale = EN;

    $('#date_picker').DatePicker({
      flat: true,
      format: 'd/m/Y',
      date: $('#meeting_date').val(),
      locale: locale,
      calendars: 1,
      onChange: function(formated, dates){
        $('#meeting_date').val(formated);
      }
    });
  }
  
  creator = $("#creator").val();
  if (creator != undefined){
    participation_id = $("input#token").val();

    $('#minutes')
    .autoResize({
      maxHeight: 1000,
      minHeight: 50
    });

    $('#static_minutes')
    .autoResize({
      maxHeight: 1000,
      minHeight: 50
    });

    if (creator == "true") {
      _initMinutesListener();
      $('#minutes').tabby();
    }
    else {
      setInterval("getMinutes()", 5000);
    }
  }
});


function updateMinutes() {
  $.ajax({
    type    : "POST",
    url     : "/meetings/update_minutes",
    data    : { authenticity_token: $('meta[name="csrf-token"]').attr('content'), id: participation_id, minutes: $('#minutes').val() },
  });
}

function getMinutes() {
  $.ajax({
    type    : "GET",
    url     : "/meetings/get_minutes",
    data    : { id: participation_id },
  });
}


// idle.js (c) Alexios Chouchoulas 2009
// Released under the terms of the GNU Public License version 2.0 (or later).
  
var _idleTimeout = 5000;  // 5 seconds
 
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


$("#attending a").click(function(){
  $(this).parent().slideUp();
});