$(function(){

  $('#trailhead-select').change(function(){
    TNT.plan.setEndLatLng($(this).val());
    var selectedOption = $(this).find(':selected');
    TNT.plan.trailhead = {id: selectedOption.data('trailheadId')};
    $("#zimride_url").val(selectedOption.data('zimrideUrl'));
  });

  // setup event handlers
  $('#the-plan').submit(function(event) {
      try {
        TNT.plan.codeAddress();
      } catch(e) {
        //alert(e.message);
      }

      return false;
    });

  $("#get-directions-button").click(function(){
    TNT.plan.showDirections(false);
    return false;
  })

  $('#return-trip-button').click(function(){
    TNT.plan.showDirections(true);
    return false;
  })

  $("#transit-mode").click(function(){
    TNT.plan.directionMode = 'transit';
    $('#transit-router').removeAttr('disabled');
    $(".plan-type a").removeClass("active")
    $(".pt1").addClass("active");
    $("#zimride-router").hide();
    $("#transit-router").show();
    return false;
  });

  $("#biking-mode").click(function(){
    TNT.plan.directionMode = 'biking';
    $('#transit-router').attr('disabled','disabled');
    $(".plan-type a").removeClass("active")
    $(".pt2").addClass("active");
    $("#zimride-router").hide();
    $("#transit-router").show();
    return false;
  });

  $("#walking-mode").click(function(){
    TNT.plan.directionMode = 'walking';
    $('#transit-router').attr('disabled','disabled');
    $(".plan-type a").removeClass("active")
    $(".pt3").addClass("active");
    $("#zimride-router").hide();
    $("#transit-router").show();
    return false;
  });

  $("#driving-mode").click(function(){
    TNT.plan.directionMode = 'driving';
    $('#transit-router').attr('disabled','disabled');
    $(".plan-type a").removeClass("active")
    $(".pt4").addClass("active");
    $("#zimride-router").hide();
    $("#transit-router").show();
    return false;
  });

  $("#rideshare-mode").click(function(){
    TNT.plan.directionMode = 'rideshare';
    $('#transit-router').attr('disabled','disabled');
    $(".plan-type a").removeClass("active")
    $(".rideshare").addClass("active");
    $("#transit-router").hide();
    $("#zimride-router").show();
    return false;
  });

});


var TNT = TNT || {};

TNT.plan = {
  mode: 'trip',
  directionMode: 'transit',
  map: null,
  startLatLng: null,

  geocoder: null,
  tripLine: null,
  startLine: null,
  endLine: null,

  // Setup the plan points
  tripStartLatLng: null,
  tripEndLatLng: null,
  startFromLatLng: null,
  returnToLatLng: null,

  //Markers
  tripStartMarker: null,
  tripEndMarker: null,
  trailheadMarker: null,
  returnToMarker: null,

  returnMode: false,

  trailhead: null,
  campground: null,
  trip: null,

  // Initialize google maps and the rounded corners
  initialize: function() {
      this.init();
      this.initTripDate();
  },

  initializeTrailheadList: function() {
    this.initialize();
    this.mode = 'trailhead';
    this.setEndLatLng($('#trailhead-select').val());
    var selectedOption = $('#trailhead-select').find(':selected');
    TNT.plan.trailhead = {id: selectedOption.data('trailheadId')};
    $("#zimride_url").val(selectedOption.data('zimrideUrl'));
  },

  setEndLatLng: function(latlng){
    var lat = parseFloat(latlng.split(",")[0]);
    var lng = parseFloat(latlng.split(",")[1]);
    this.trailhead_latlng = new google.maps.LatLng(lat,lng);
    this.end_latlng = this.trailhead_latlng;
  },


  initializePoint: function(latitude,longitude){
    this.initialize();
    this.google_router = true;
    this.fiveoneone_router = true;
    this.mode = 'point'
    this.point_latlng = new google.maps.LatLng(latitude,longitude);

    this.end_latlng = new google.maps.LatLng(latitude,longitude);
  },

  initializeTrailhead: function(id){
    this.initialize();
    this.loadTrailheadIntoPlan(id);
    this.mode = 'trailhead';
  },

  initializeCampground: function(id){
    this.initialize();
    this.loadCampgroundIntoPlan(id);
    this.mode = 'trailhead';
  },

  initializeTrip: function(id){
    this.initialize();
    this.loadTripIntoPlan(id);
  },


  init: function(){
    this.directionsService = new google.maps.DirectionsService();
    this.geocoder = new google.maps.Geocoder();
    var defaultBounds = new google.maps.LatLngBounds(
    new google.maps.LatLng(37.7750, -122.4190),
    new google.maps.LatLng(37.9750, -122.2190));

    var input = document.getElementById('start-from-address');
    var options = {
      bounds: defaultBounds,
      types: ['geocode']
    };

    autocomplete = new google.maps.places.Autocomplete(input, options);

    this.codeAddress();

    google.maps.event.addListener(autocomplete, 'place_changed', function() {
      var place = autocomplete.getPlace();
      if (!place.geometry) {
        // Inform the user that a place was not found and return.
        return;
      }
      TNT.plan.start_latlng = place.geometry.location;
      $('#starting-point-latlng').html(TNT.plan.start_latlng.lat() + ", " + TNT.plan.start_latlng.lng());
      TNT.plan.calcRoute();
    });
  },

  initTripDate: function(date){
    var now = new Date();
    if(typeof date != 'undefined'){
      now = date;
    }
    var month = zeroPad(now.getMonth() + 1, 2);
    var day = zeroPad(now.getDate(), 2);
    var tripDate = month + '/' + day + '/' + now.getFullYear();
    $('#trip_date').val(tripDate);

    var tripHour = now.getHours();
    var tripAMPM = 'AM';
    if (tripHour > 11) {
      tripHour = tripHour - 12;
      tripAMPM = 'PM';
      $("#trip_ampm").val('pm');
    }
    else {
      $("#trip_ampm").val('am');
    }
    if (tripHour == 0) {
      tripHour = 12;
    }
    $('#trip_hour').val(zeroPad(tripHour, 2));
    $('#trip_minutes').val(zeroPad(now.getMinutes(), 2));

    $("#trip_date").datepicker({
      minDate: 0,
      maxDate: 21,
      showButtonPanel: true
    });

    $('.ui-datepicker').hide()
  },



  loadTripIntoPlan: function(id) {
    var url = "/trips/" + id + ".json/";
    $.getJSON(url,function(trip) {
      TNT.plan.trip = trip;
      TNT.plan.end_latlng = new google.maps.LatLng(trip.start_lat,trip.start_lng);
      TNT.plan.loadStartTrailheadRouters(trip.starting_trailhead_id);
      TNT.plan.loadEndTrailheadRouters(trip.ending_trailhead_id);
    });
  },

  loadTrailheadIntoPlan: function(id) {
    var url = "/trailheads/" + id + ".json";
    $.getJSON(url, function(trailhead) {
      TNT.plan.trailhead = trailhead;
      TNT.plan.end_latlng = new google.maps.LatLng(trailhead.latitude,trailhead.longitude);
      TNT.plan.loadStartTrailheadRouters(id);
      TNT.plan.loadEndTrailheadRouters(id);

    });
  },

  loadCampgroundIntoPlan: function(id) {
    var url = "/campgrounds/" + id + ".json";
    $.getJSON(url, function(campground) {
      TNT.plan.campground = campground;
      TNT.plan.end_latlng = new google.maps.LatLng(campground.latitude,campground.longitude);
    });
    TNT.plan.google_router = true;
    TNT.plan.fiveoneone_router = true;
  },

  loadStartTrailheadRouters: function(id) {
    var url = "/trailheads/" + id + "/transit_routers.json";
    $.getJSON(url, function(routers) {
      var google_router = false;
      var fiveoneone_router = false;
      var count = routers.length;
      for(var router_i = 0;router_i<count;router_i++){
        if(routers[router_i].name == 'Google Transit'){
          TNT.plan.google_router = true;
        } else if(routers[router_i].name == '511.org') {
          TNT.plan.fiveoneone_router = true;
        }
      }
    });
  },

  loadEndTrailheadRouters: function(id) {
    var url = "/trailheads/" + id + "/transit_routers.json";
    $.getJSON(url, function(routers) {
      var google_router = false;
      var fiveoneone_router = false;
      var count = routers.length;
      for(var router_i = 0;router_i<count;router_i++){
        if(routers[router_i].name == 'Google Transit'){
          TNT.plan.google_router = true;
        } else if(routers[router_i].name == '511.org') {
          TNT.plan.fiveoneone_router = true;
        }
      }
    });
  },

  // These are all of the trip routing super functions

  showDirections: function(isReturnTrip) {
    var router = $('#transit-router').val();

    if(!isReturnTrip) {
      this.end_lat = this.end_latlng.lat();
      this.end_lng = this.end_latlng.lng();
      this.start_lat = this.start_latlng.lat();
      this.start_lng = this.start_latlng.lng();
    }
    else
    {
      this.start_lat = this.end_latlng.lat();
      this.start_lng = this.end_latlng.lng();
      this.end_lat = this.start_latlng.lat();
      this.end_lng = this.start_latlng.lng();
    }

    if(this.directionMode == 'transit')
    {
      if(router == '511'){
        if(isReturnTrip) {
          this.showEndTransit511NewWindow();
        } else {
          this.showStartTransit511NewWindow();
        }
      } else {
        if(isReturnTrip) {
          this.showEndTransitGoogleNewWindow();
        } else {
          this.showStartTransitGoogleNewWindow();
        }
      }
    }
    else if(this.directionMode == 'biking') {
      if(isReturnTrip) {
        this.showEndBikingNewWindow();
      } else {
        this.showStartBikingNewWindow();
      }
    }
    else if(this.directionMode == 'walking') {
      if(isReturnTrip) {
        this.showEndWalkingNewWindow();
      } else {
        this.showStartWalkingNewWindow();
      }
    }
    else if(this.directionMode == 'driving') {
      if(isReturnTrip) {
        this.showEndDrivingNewWindow();
      } else {
        this.showStartDrivingNewWindow();
      }
    }
    else if(this.directionMode == 'rideshare') {
      if(isReturnTrip) {
        this.showStartRideshareNewWindow();
      } else {
        this.showStartRideshareNewWindow();
      }
    }
  },

  showStartRideshareNewWindow: function() {
    var raw_trip_date = $('#trip_date').val();
    var trip_date_vals = raw_trip_date.split("/");
    var trip_date_input = trip_date_vals[2] + trip_date_vals[0] + trip_date_vals[1]

    var trailhead_id = (this.trailhead && this.trailhead.id) || (this.trip && this.trip.starting_trailhead_id);
    var starting_lat = this.start_lat;
    var starting_lng = this.start_lng;
    var ending_lat = this.end_lat;
    var ending_lng = this.end_lng;

    var zimride_url = $('#zimride_url').val() || '';
    var start_from_address = $("#start-from-address").val();
    var zimride_search_url= "http://www.zimride.com/search";

    var zimride_params =
      "?utm_source=ptnr&utm_medium=tt&utm_campaign=web&utm_content=" + trailhead_id +
      "&date=" + raw_trip_date +
      "&s_lat=" + starting_lat +
      "&s_lng=" + starting_lng +
      "&s_user_lat=" + starting_lat +
      "&s_user_lng=" + starting_lng +
      "&e_lat=" + ending_lat +
      "&e_lng=" + ending_lng +
      "&e_user_lat=" + ending_lat +
      "&e_user_lng=" + ending_lng +
      // "&e=" + ending_lat + "," + ending_lng +
      "&s_full_text=" + start_from_address +
      "&e_full_text=" + ending_lat + "," + ending_lng +
      // "&e=" + start_from_address;
      "&s=" + start_from_address;

      // "&e_full_text=" + this.trailhead.name;

    var url = "";
    if(zimride_url.trim() != "") {
      url = zimride_url.trim() + zimride_params;
    } else {
      url = zimride_search_url.trim() + zimride_params;
    }

    // var url = zimride_url + "&s=" + start_from_address + "&date=" + raw_trip_date;
    url = encodeURI(url);

    window.open(url, "start_rideshare");
  },

  showEndRideshareNewWindow: function() {
    // raw_trip_date = $('#trip_date').val();
    // trip_date_vals = raw_trip_date.split("/");
    // trip_date_input = trip_date_vals[2] + trip_date_vals[0] + trip_date_vals[1]

    // var zimride_url = $('#zimride_url').val();
    // var url = zimride_rul + "?s=" + start_from_address + "&date=" + raw_trip_date;

    // window.open(url, "start_rideshare");
  },

  showStartTransit511NewWindow: function() {
    raw_trip_date = $('#trip_date').val();
    trip_date_vals = raw_trip_date.split("/");
    trip_date_input = trip_date_vals[2] + trip_date_vals[0] + trip_date_vals[1]

    if (this.mode == 'trip') {
      url = this.build511TransitURL(trip_date_input,
        $('#trip_dep_arr').val(),
        $('#trip_hour').val(),
        $('#trip_minutes').val(),
        $('#trip_ampm').val(),
        this.start_lat,
        this.start_lng,
        this.end_lat,
        this.end_lng,
        "Origin",
        "Trip Start");
      window.open(url, "start_511_transit");
    }
    else{
      url = this.build511TransitURL(trip_date_input, $('#trip_dep_arr').val(), $('#trip_hour').val(),
      $('#trip_minutes').val(), $('#trip_ampm').val(), this.start_lat, this.start_lng, this.end_lat, this.end_lng, "Origin", "Trailhead");
      window.open(url, "start_511_transit");
    }
  },

  showStartTransitGoogleNewWindow: function() {
    if (this.mode == 'trip') {
      url = this.buildGoogleTransitURL(
        $('#trip_date').val(),
        $('#trip_dep_arr').val(),
        $('#trip_hour').val(),
        $('#trip_minutes').val(),
        $('#trip_ampm').val(),
        this.start_lat,
        this.start_lng,
        this.end_lat,
        this.end_lng,
        "Origin",
        "Trip Start");
      window.open(url, "start_google_transit");
    }
    else{
      url = this.buildGoogleTransitURL($('#trip_date').val(),$('#trip_dep_arr').val(),$('#trip_hour').val(),
      $('#trip_minutes').val(), $('#trip_ampm').val(), this.start_lat, this.start_lng, this.end_lat, this.end_lng, "Origin", "Trailhead");
      window.open(url, "start_google_transit");
    }
  },

  showStartDrivingNewWindow: function() {
    if (this.mode == 'trip') {
      url = this.buildGoogleDrivingURL($('#trip_date').val(),$('#trip_dep_arr').val(),$('#trip_hour').val(), $('#trip_minutes').val(),
      $('#trip_ampm').val(), this.start_lat, this.start_lng, this.end_lat, this.end_lng, "Origin", "Trip Start");
      window.open(url, "start_google_driving");
    }
    else{
      url = this.buildGoogleDrivingURL(
        $('#trip_date').val(),
        $('#trip_dep_arr').val(),
        $('#trip_hour').val(),
        $('#trip_minutes').val(),
        $('#trip_ampm').val(),
        this.start_lat,
        this.start_lng,
        this.end_lat,
        this.end_lng,
        "Origin",
        "Trailhead");
      window.open(url, "start_google_driving");
    }
  },

  showEndDrivingNewWindow: function() {
    if (this.mode == 'trip') {
      url = this.buildGoogleDrivingURL($('#trip_date').val(),$('#trip_dep_arr').val(),$('#trip_hour').val(), $('#trip_minutes').val(),
      $('#trip_ampm').val(), this.start_lat, this.start_lng, this.end_lat, this.end_lng, "Trip End", "Destination");
      window.open(url, "end_google_driving");
    }
    else{
      start_lat = $('#trailhead_lat').val()
      start_lng = $('#trailhead_lng').val()
      url = this.buildGoogleDrivingURL($('#trip_date').val(),$('#trip_dep_arr').val(),$('#trip_hour').val(),
      $('#trip_minutes').val(), $('#trip_ampm').val(), this.start_lat, this.start_lng, this.end_lat, this.end_lng, "Trailhead", "Destination");
      window.open(url, "end_google_driving");
    }
  },

  showStartBikingNewWindow: function() {
    if (this.mode == 'trip') {
      url = this.buildGoogleTransitURLBase($('#trip_date').val(),$('#trip_dep_arr').val(),$('#trip_hour').val(), $('#trip_minutes').val(),
      $('#trip_ampm').val(), this.start_lat, this.start_lng, this.end_lat, this.end_lng, "Origin", "Trip Start","b");
      window.open(url, "start_google_biking");
    }
    else{
      url = this.buildGoogleTransitURLBase($('#trip_date').val(),$('#trip_dep_arr').val(),$('#trip_hour').val(),
      $('#trip_minutes').val(), $('#trip_ampm').val(), this.start_lat, this.start_lng, this.end_lat, this.end_lng, "Origin", "Trailhead","b");
      window.open(url, "start_google_biking");
    }
  },

  showEndBikingNewWindow: function() {
    if (this.mode == 'trip') {
      url = this.buildGoogleTransitURLBase(
        $('#trip_date').val(),
        $('#trip_dep_arr').val(),
        $('#trip_hour').val(),
        $('#trip_minutes').val(),
        $('#trip_ampm').val(),
        this.start_lat,
        this.start_lng,
        this.end_lat,
        this.end_lng,
        "Trip End",
        "Destination",
        "b");
      window.open(url, "end_google_biking");
    }
    else{
      url = this.buildGoogleTransitURLBase($('#trip_date').val(),$('#trip_dep_arr').val(),$('#trip_hour').val(),
      $('#trip_minutes').val(), $('#trip_ampm').val(), this.start_lat, this.start_lng, this.end_lat, this.end_lng, "Trailhead", "Destination","b");
      window.open(url, "end_google_biking");
    }
  },

  showStartWalkingNewWindow: function() {
    if (this.mode == 'trip') {
      url = this.buildGoogleTransitURLBase(
        $('#trip_date').val(),
        $('#trip_dep_arr').val(),
        $('#trip_hour').val(),
        $('#trip_minutes').val(),
        $('#trip_ampm').val(),
        this.start_lat,
        this.start_lng,
        this.end_lat,
        this.end_lng,
        "Origin",
        "Trip Start",
        "w");
      window.open(url, "start_google_walking");
    }
    else{
      url = this.buildGoogleTransitURLBase(
        $('#trip_date').val(),
        $('#trip_dep_arr').val(),
        $('#trip_hour').val(),
        $('#trip_minutes').val(),
        $('#trip_ampm').val(),
        this.start_lat,
        this.start_lng,
        this.end_lat,
        this.end_lng,
        "Origin",
        "Trailhead",
        "w");
      window.open(url, "start_google_walking");
    }
  },

  showEndWalkingNewWindow: function() {
    if (this.mode == 'trip') {
      url = this.buildGoogleTransitURLBase($('#trip_date').val(),$('#trip_dep_arr').val(),$('#trip_hour').val(), $('#trip_minutes').val(),
      $('#trip_ampm').val(), this.start_lat, this.start_lng, this.end_lat, this.end_lng, "Trip End", "Destination","w");
      window.open(url, "end_google_walking");
    }
    else{
      url = this.buildGoogleTransitURLBase($('#trip_date').val(),$('#trip_dep_arr').val(),$('#trip_hour').val(),
      $('#trip_minutes').val(), $('#trip_ampm').val(), this.start_lat, this.start_lng, this.end_lat, this.end_lng, "Trailhead", "Destination","w");
      window.open(url, "end_google_walking");
    }
  },

  showEndTransit511NewWindow: function() {
    raw_trip_date = $('#trip_date').val();
    trip_date_vals = raw_trip_date.split("/");
    trip_date_input = trip_date_vals[2] + trip_date_vals[0] + trip_date_vals[1]
    if (this.mode == 'trip') {
      url = this.build511TransitURL(
        trip_date_input,
        $('#trip_dep_arr').val(),
        $('#trip_hour').val(),
        $('#trip_minutes').val(),
        $('#trip_ampm').val(),
        this.start_lat,
        this.start_lng,
        this.end_lat,
        this.end_lng,
        "Trip End",
        "Destination");
      window.open(url, "end_511_transit");
    }
    else {
      url = this.build511TransitURL(
        trip_date_input,
        $('#trip_dep_arr').val(),
        $('#trip_hour').val(),
        $('#trip_minutes').val(),
        $('#trip_ampm').val(),
        this.start_lat,
        this.start_lng,
        this.end_lat,
        this.end_lng,
        "Trailhead",
        "Destination");
      window.open(url, "end_511_transit");
    }
  },

  showEndTransitGoogleNewWindow: function() {
    if (this.mode == 'trip') {
      url = this.buildGoogleTransitURL($('#trip_date').val(),$('#trip_dep_arr').val(),
        $('#trip_hour').val(), $('#trip_minutes').val(), $('#trip_ampm').val(),
        this.start_lat, this.start_lng, this.end_lat, this.end_lng, "Trip End", "Destination");
      window.open(url, "end_google_transit");
    }
    else {
      url = this.buildGoogleTransitURL($('#trip_date').val(),$('#trip_dep_arr').val(),
        $('#trip_hour').val(), $('#trip_minutes').val(), $('#trip_ampm').val(),
        this.start_lat, this.start_lng, this.end_lat, this.end_lng, "Trailhead", "Destination");
      window.open(url, "end_google_transit");
    }
  },

  buildGoogleDrivingURL: function(trip_date, trip_arr_dep, trip_hour, trip_minute, trip_ampm, start_lat, start_lng, end_lat, end_lng, originName, destinationName) {
      var url = "http://www.google.com/maps?f=d&source=s_d&saddr=" + start_lat
              + "+,+" + start_lng + "&daddr=" + end_lat + "+,+" + end_lng
              + "&hl=en&mra=ls&ttype=" + trip_arr_dep + "&noexp=0&noal=0&sort="
              + "&time=" + trip_hour + ":" + trip_minute + trip_ampm + "&date=" + escape(trip_date);
      return url;
  },

  buildGoogleTransitURLBase: function(trip_date, trip_arr_dep, trip_hour, trip_minute, trip_ampm, start_lat, start_lng, end_lat, end_lng, originName, destinationName, mode) {
      var url = "http://www.google.com/maps?f=d&source=s_d&saddr=" + start_lat
              + "+,+" + start_lng + "&daddr=" + end_lat + "+,+" + end_lng
              + "&hl=en&mra=ls" + "&dirflg=" + mode + "&ttype=" + trip_arr_dep + "&noexp=0&noal=0&sort="
              + "&time=" + trip_hour + ":" + trip_minute + trip_ampm + "&date=" + escape(trip_date);
      return url;
  },

  buildGoogleTransitURL: function(trip_date, trip_arr_dep, trip_hour, trip_minute, trip_ampm, start_lat, start_lng, end_lat, end_lng, originName, destinationName) {
      var url = this.buildGoogleTransitURLBase(trip_date, trip_arr_dep, trip_hour, trip_minute, trip_ampm, start_lat, start_lng, end_lat, end_lng, originName, destinationName, "r");
      return url;
  },

  /*
   * This is an example google transit url
   *
   * http://www.google.com/maps?f=d&source=s_d&saddr=37.774824+,+-122.418493&
   * daddr=37.1932879733327+,+-121.836673021317&geocode=FehlQAIdwwq0-A%3BFUiGNwIdf-u8-A&hl=en&
   * mra=ls&dirflg=r&date=07%2F04%2F09&time=7:00am&
   * ttype=dep&noexp=0&noal=0&sort=&tline=&output=js&vps=3&
   * jsv=164e&sll=37.784825,-122.121277&sspn=0.309318,2.113495&
   * abauth=f9328d12:Aq0GxXyltpkd_qYVJwXdlQTCtQo&absince=1510
   */

  build511TransitURL: function(trip_date, trip_arr_dep, trip_hour, trip_minute, trip_ampm, start_lat, start_lng, end_lat, end_lng, originName, destinationName) {
      var url = "http://tripplanner.transit.511.org/mtc/XSLT_TRIP_REQUEST2";
      var params = new Array();

      var params = ("language=en&sessionID=0&requestID=0&command=&verifyAnyLocViaLocServer=1&convertStopsPTKernel2LocationServer=1&anyHitListReductionLimit=20" +
      "&itdLPxx_homepage=secondStep&useProxFootSearch=1&coordListOutputFormat=STRING&anySigWhenPerfectNoOtherMatches=1&execInst=normal&nextDepsPerLeg=1&" +
      "itdLPxx_additonalOptions=&railSystems=&imageFormat=PNG&imageWidth=250&imageHeight=200&imageWidthO=500&imageHeightO=400&imageOnly=1&imageNoTiles=1&" +
      "prevCommand=&placeInfo=Enter%2BCity%2BName&businessPlace=Enter%2BCity%2BName&businessName=Enter%2BBusinesses&nameRailStation=Select%2BRail%2BStation&" +
      "nameFerryLanding=Select%2BFerry%2BLanding&type_origin=coord&anyObjFilter_origin=0&type_destination=coord&anyObjFilter_destination=0&ptOptionsActive=1&" +
      "itOptionsActive=1&selOP=1&useOnly=1&preferIncl=1&preferExcl=1&changeSpeed=normal&computationType=SEQUENCE&includedMeans=checkbox&inclMOT_0=on&inclMOT_5=on&" +
      "inclMOT_9=on&hiddenYear=2009&hiddenMonth=March&itdLPxx_srcid=&name_origin="
      + start_lng + ":" + start_lat + ":WGS84[DD.ddddd]:" + originName + "&place_origin=&name_destination=" + end_lng + ":" + end_lat +
      ":WGS84[DD.ddddd]:" + destinationName + "&place_destination=&routeType=LEASTTIME&itdLPxx_riderCategory=Regular&trITMOT=100&x=38&y=13&itOptionsActive=1&trITMOT=100&trITMOTvalue=24");
      if(trip_date != null)
      {
          params += "&itdDate=" + trip_date;
      }
      if(trip_ampm != null)
      {
          params += "&itdTimeAMPM=" + trip_ampm;
      }
      if(trip_arr_dep != null)
      {
          params += "&itdTripDateTimeDepArr=" + trip_arr_dep;
      }
      if(trip_hour != null)
      {
          params += "&itdTimeHour=" + trip_hour;
      }
      if(trip_minute != null)
      {
          params += "&itdTimeMinute=" + trip_minute;
      }

      return url + "?" + params;
  },


  /*
   * Example 511 trip planner URL
   *
   * http://tripplanner.transit.511.org/mtc/XSLT_TRIP_REQUEST2?language=en&se
  ssionID=0&requestID=0&command=&verifyAnyLocViaLocServer=1&convertStopsPT
  Kernel2LocationServer=1&anyHitListReductionLimit=20&itdLPxx_homepage=sec
  ondStep&useProxFootSearch=1&coordListOutputFormat=STRING&anySigWhenPerfe
  ctNoOtherMatches=1&execInst=normal&nextDepsPerLeg=1&itdLPxx_additonalOpt
  ions=&railSystems=&imageFormat=PNG&imageWidth=250&imageHeight=200&imageW
  idthO=500&imageHeightO=400&imageOnly=1&imageNoTiles=1&prevCommand=&palce
  Info=Enter%2BCity%2BName&businessPlace=Enter%2BCity%2BName&businessName=
  Enter%2BBusinesses&nameRailStation=Select%2BRail%2BStation&nameFerryLand
  ing=Select%2BFerry%2BLanding&type_origin=coord&anyObjFilter_origin=0&typ
  e_destination=coord&anyObjFilter_destination=0&ptOptionsActive=1&itOptio
  nsActive=1&selOP=1&useOnly=1&preferIncl=1&preferExcl=1&changeSpeed=norma
  l&computationType=SEQUENCE&includedMeans=checkbox&inclMOT_0=on&inclMOT_5
  =on&inclMOT_9=on&itdTimeAMPM=pm&hiddenYear=2009&hiddenMonth=March&itdLPx
  x_srcid=&name_origin=-122.258893114:37.8077850605:WGS84[DD.ddddd]:Lake+M
  erritt&place_origin=&name_destination=-122.4341433062:37.8682613217:WGS8
  4[DD.ddddd]:Angel Island State
  Park&place_destination=&itdTripDateTimeDepArr=dep&itdTimeHour=5&itdTimeM
  inute=23&itdLPxx_TimeAMPM=pm&itdDate=20090515&routeType=LEASTTIME&itdLPx
  x_riderCategory=Regular&trITMOT=100&trITMOTvalue=12&x=38&y=13
   */


  calcRoute: function() {
    var start = TNT.plan.start_latlng;
    var end = TNT.plan.end_latlng;
    var waypoints = [];
    if(TNT.plan.trip){
      end = TNT.plan.start_latlng;
      waypoints = [{location:new google.maps.LatLng(TNT.plan.trip.end_lat,TNT.plan.trip.end_lng),stopover:true},
        {location:new google.maps.LatLng(TNT.plan.trip.start_lat,TNT.plan.trip.start_lng),stopover:true}];
    }
    var request = {
      origin:start,
      destination:end,
      waypoints: waypoints,
      travelMode: google.maps.TravelMode.DRIVING
    };
    this.directionsService.route(request, function(result, status) {
      if (status == google.maps.DirectionsStatus.OK) {
        var totalDistance = 0;
        var totalDuration = 0;
        var legs = result.routes[0].legs;
        for(var i=0; i<legs.length; ++i) {
          totalDistance += legs[i].distance.value;
          totalDuration += legs[i].duration.value;
        }
        TNT.plan.totalMiles = totalDistance * 0.000621371192 * 2;
        $("#driving-miles").text(TNT.plan.totalMiles.toFixed(1));
        TNT.plan.driving_gallons = (TNT.plan.totalMiles / 21).toFixed(1);
        $("#driving-gas").text(TNT.plan.driving_gallons);
        TNT.plan.driving_cost = (TNT.plan.driving_gallons * 4).toFixed(2);
        $("#driving-money").text(TNT.plan.driving_cost);
        TNT.plan.driving_carbon = (TNT.plan.driving_gallons * 19.4).toFixed(1);
        $("#driving-carbon").text(TNT.plan.driving_carbon);
      }
    });
  },

  codeAddress: function() {
    var address = document.getElementById("start-from-address").value;
    this.geocoder.geocode( { 'address': address}, function(results, status) {
      if (status == google.maps.GeocoderStatus.OK) {
        TNT.plan.start_latlng = results[0].geometry.location;
        $('#starting-point-latlng').html(TNT.plan.start_latlng.lat() + ", " + TNT.plan.start_latlng.lng());
        TNT.plan.calcRoute();
      } else {
        // alert("Geocode not successful : " + status);
      }
    });
  }

};




