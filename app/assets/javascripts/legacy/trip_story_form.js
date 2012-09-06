$(function(){
  var initTripDate = function(date){
    var now = new Date();
    if(typeof date != 'undefined'){
      now = date;
    }
    var month = zeroPad(now.getMonth() + 1, 2);
    var day = zeroPad(now.getDate(), 2);
    var tripDate = month + '/' + day + '/' + now.getFullYear();
    $('#id_happened_at').val(tripDate);

    $("#id_happened_at").datepicker({
      maxDate: 0,
      showButtonPanel: true
    });
  };

  $('#id_story').ckeditor({height: '200px',width:'500px'});
  initTripDate();
})
