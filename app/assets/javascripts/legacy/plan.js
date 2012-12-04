$(function(){
	$(window).unload(function(){
		GUnload();
	});

  $('#trailhead-select').change(function(){
    setEndLatLng($(this).val());
  });

  $('#start-from-address').keypress(function(){
    $('#starting-point-latlng').html("Click SET to locate.")
  })

	// setup event handlers
	$('#the-plan').submit(function(event) {
	    try {
	      TNT.plan.setStartFrom($('#start-from-address').val());
	    } catch(e) {
	      //alert(e.message);
	    }

      return false;
	  });

	$('#start-from-address').bind('focus click', function(event){
	  $(event.target).select();
	  $(event.target).css('color','black');
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

// Initialize google maps and the rounded corners
function initialize() {
  if (GBrowserIsCompatible()) {
    TNT.plan.init();
  	TNT.plan.initTripDate();
  	TNT.plan.chooseStart();
  }
}

function initializeTrailheadList() {
  initialize();
  TNT.plan.mode = 'trailhead';
  setEndLatLng($('#trailhead-select').val());
}

function setEndLatLng(latlng){
  var lat = parseFloat(latlng.split(",")[0]);
  var lng = parseFloat(latlng.split(",")[1]);
  TNT.plan.trailhead_latlng = new GLatLng(lat,lng);
  TNT.plan.end_lat = lat;
  TNT.plan.end_lng = lng;
  showTripDrivingRoutes();
}

function initializeDefault(){
  initialize();
}

function initializePoint(latitude,longitude){
  initialize();
  TNT.plan.trailheadMarker.setLatLng(new GLatLng(
    latitude, longitude));
  TNT.plan.centerOnTrailhead();
  TNT.plan.google_router = true;
  TNT.plan.fiveoneone_router = true;
  TNT.plan.trailheadMarker.show();
  TNT.plan.mode = 'point'
  TNT.plan.point_latlng = new GLatLng(latitude,longitude);
  TNT.plan.end_lat = latitude;
  TNT.plan.end_lng = longitude;

  $('#name-title').text(latitude + ',' + longitude);
}

function initializeTrailhead(id){
  initialize();
  TNT.plan.loadTrailheadIntoPlan(id);
  TNT.plan.mode = 'trailhead';
}

function initializeCampground(id){
  initialize();
  TNT.plan.loadCampgroundIntoPlan(id);
  TNT.plan.mode = 'trailhead';
}

function initializeTrip(id){
  initialize();
  TNT.plan.loadTripIntoPlan(id);
}

var TNT = {};

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

	init: function(){
		// Setup all the basic map stuff
		this.map = new GMap2(document.getElementById("plan-map"));
		this.startLatLng = new GLatLng(37.7750, -122.4190);
		this.map.setCenter(this.startLatLng, 10);
		this.map.addControl(new GLargeMapControl3D());

		var scaleControlPosition = new GControlPosition(G_ANCHOR_BOTTOM_LEFT, new GSize(10, 40));
		this.map.addControl(new GScaleControl(),
		  scaleControlPosition);
		this.map.enableContinuousZoom();

		var copyOSM = new GCopyrightCollection("<a href=\"http://www.openstreetmap.org/\">OpenStreetMap</a>");
		copyOSM.addCopyright(new GCopyright(1, new GLatLngBounds(new GLatLng(-90,-180), new GLatLng(90,180)), 0, " "));
		var tilesMapnik = new GTileLayer(copyOSM, 1, 17, {tileUrlTemplate: 'http://tile.openstreetmap.org/{Z}/{X}/{Y}.png'});
		var mapMapnik = new GMapType([tilesMapnik], G_NORMAL_MAP.getProjection(), "OSM");
		this.map.addMapType(mapMapnik);

		this.map.addMapType(G_PHYSICAL_MAP);
		this.map.addMapType(G_SATELLITE_3D_MAP);
		this.map.setMapType(G_NORMAL_MAP);
		this.map.addControl(new GHierarchicalMapTypeControl());

		this.geocoder = new GClientGeocoder();

		// Setup the plan points
		this.tripStartLatLng = new GLatLng(37.7750, -122.4190);
		this.tripEndLatLng = new GLatLng(37.7750, -122.4190);
		this.startFromLatLng = new GLatLng(37.7750, -122.4190);
		this.returnToLatLng = new GLatLng(37.7750, -122.4190);
		this.map.setCenter(this.tripStartLatLng, 10);

		/**
		 *	Markers
		 **/
		 // Create our start marker icon

		var iconSize = new GSize(34, 36);
		var iconAnchor = new GPoint(11, 36);

		var mapIcon = new GIcon();
		mapIcon.iconSize = iconSize;
		mapIcon.iconAnchor = iconAnchor;
		mapIcon.image = "/assets/legacy/map/pin_s_tripstart.png";

		// Set up our GMarkerOptions object
		var markerOptions = {
			icon: mapIcon,
			draggable: false
		};

		this.tripStartMarker = new GMarker(this.tripStartLatLng,
		  markerOptions);

		// Create our end marker icon
		var mapIcon = new GIcon();
		mapIcon.iconSize = iconSize;
		mapIcon.iconAnchor = iconAnchor;
		mapIcon.image = "/assets/legacy/map/pin_s_tripend.png";

		// Set up our GMarkerOptions object
		var endMarkerOptions = {
			icon: mapIcon,
			draggable: false
		};
		this.tripEndMarker = new GMarker(this.tripEndLatLng, endMarkerOptions);

		var mapIcon = new GIcon();
		mapIcon.iconSize = iconSize;
		mapIcon.iconAnchor = iconAnchor;
		mapIcon.image = "/assets/legacy/map/pin_s_home.png";

		markerOptions = {
			icon :mapIcon,
			draggable :true
		};
		this.startFromMarker = new GMarker(this.startFromLatLng, markerOptions);

		 // Create our "tiny" marker icon
 		var mapIcon = new GIcon();
 		mapIcon.iconSize = iconSize;
 		mapIcon.iconAnchor = iconAnchor;
		mapIcon.image = "/assets/legacy/map/pin_s_tripend.png";

		var endMarkerOptions = {
			icon :mapIcon,
			draggable : true
		};

		var mapIcon = new GIcon();
		mapIcon.iconSize = iconSize;
		mapIcon.iconAnchor = iconAnchor;
		mapIcon.image = "/assets/legacy/map/pin_s_trailhead.png";
		mapIcon.infoWindowAnchor = new GPoint(14, 10);

		var trailheadMarkerOptions = {
			icon: mapIcon,
			draggable: false,
			clickable: false
		};
		this.trailheadMarker = new GMarker(new GLatLng(37.7750, -122.4190), trailheadMarkerOptions);
		this.trailheadMarker.hide();

    var mapIcon = new GIcon();
		mapIcon.iconSize = iconSize;
		mapIcon.iconAnchor = iconAnchor;
		mapIcon.image = "/assets/legacy/map/pin_s_campground.png";
		mapIcon.infoWindowAnchor = new GPoint(14, 10);

		var campgroundMarkerOptions = {
			icon: mapIcon,
			draggable: false,
			clickable: false
		};
		this.campgroundMarker = new GMarker(new GLatLng(37.7750, -122.4190), campgroundMarkerOptions);

		this.returnToMarker = new GMarker(this.returnToLatLng, endMarkerOptions);

		this.map.addOverlay(this.tripEndMarker);
		this.map.addOverlay(this.tripStartMarker);
		this.map.addOverlay(this.trailheadMarker);
		this.map.addOverlay(this.campgroundMarker);
		this.map.addOverlay(this.returnToMarker);
		this.map.addOverlay(this.startFromMarker);

		this.returnToMarker.hide();
		this.trailheadMarker.hide();
		this.tripStartMarker.hide();
		this.tripEndMarker.hide();
		this.campgroundMarker.hide();

		GEvent.bind(this.startFromMarker, "dragend", this, this.dragMoveStartFrom);
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

	dragMoveStartFrom: function(overlay, latlng) {
		if (overlay) {
			latlng = overlay;
			this.showLatLng(latlng);
		}
	},


	// Updates the start from display elements
	updateStartFromLatLngDisplay: function(latlng) {
    this.start_latlng = latlng;
		this.start_lat = latlng.lat();
		this.start_lng = latlng.lng();
    $('#starting-point-latlng').html(latlng.lat() + ", " + latlng.lng());
    showTripDrivingRoutes();
	},

	// Updates the fields in the UI based on reverse geocode of the latlng
	getStartFromReverseGeocode: function(latlng) {
		if (latlng != null) {
			this.geocoder.getLocations(latlng, this.populateStartFromAddress);
		}
	},

	// Handles start reverse geocode requests (LatLng -> Address)
	populateStartFromAddress: function(response) {
	  var self = this;
		if (response && response.Status.code == 200) {
			var place = response.Placemark[0];
			var point = new GLatLng(place.Point.coordinates[1],
					place.Point.coordinates[0]);
			$('#start-from-address').val(place.address);
			TNT.plan.start_from_address = place.address;
      saveLocationToSession(place.address);
		} else {
      $('#start-from-address').val("San Francisco, CA");
      TNT.plan.start_from_address = "San Francisco, CA";
      saveLocationToSession("San Francisco, CA");
    }

	},

	getEndReverseGeocode: function(latlng) {
		if (latlng != null) {
			var address = latlng;
			this.geocoder.getLocations(latlng, this.populateEndAddress);
		}
	},

	populateEndAddress: function(response) {
		if (response && response.Status.code == 200) {
			var place = response.Placemark[0];
			var point = new GLatLng(place.Point.coordinates[1],
					place.Point.coordinates[0]);
			TNT.plan.end_address = place.address;
		}
	},

	setStartFrom: function(address) {
	  var self = this;
		if (this.geocoder) {
			this.geocoder.getLatLng(address, function(point) {
				if (point) {
					self.showAddress(address);
					saveKeyValueToSession("plan.startfrom",point.toUrlValue());
				}
			})
		}
	},

	setReturnTo: function(address) {
	  var self = this;
		if (this.geocoder) {
			this.geocoder.getLatLng(address, function(point) {
				if (point) {
					self.returnToMarker.setLatLng(point);
					self.updateEndLatLngDisplay(point);
					saveKeyValueToSession("plan.returnto",point.toUrlValue());

					if (self.mode == self.TRIP) {
						this.centerOnTrip();
					}
					else if(self.campground){
					  self.centerOnCampground();
					} else {
						self.centerOnTrailhead();
					}
				}
			})
		}
	},

	chooseStart: function(){
		// Figure out where to start
		var self = this;
		var endLatLng = null;
    loadLocationFromSession(function(data){
			if (data && data.value != "null") {
				self.showAddress(data.value);
			}
			else {
        self.showAddress("San Francisco, CA");
			}
		});
	},

	showAddress: function(address){
		 var self = this;
		 if (this.geocoder) {
			 this.geocoder.getLatLng(address, function(point){
				 if (point) {
          saveLocationToSession(address);
					self.showLatLng(point);
				 }
			 })
		 }
	},

	showLatLng: function(point){
		this.startFromMarker.setLatLng(point);
		this.getStartFromReverseGeocode(point);
		this.updateStartFromLatLngDisplay(point);
		if(this.trip){
		  this.centerOnTrip();
		} else if(this.campground) {
		  this.centerOnCampground();
	  } else {
		  this.centerOnTrailhead();
		}
	},

		loadTripIntoPlan: function(id) {
		  var self = this;
  		url = "/trips/" + id + ".json/";
  		GDownloadUrl(url, function(data) {
  			self.trip = $.parseJSON(data);
  			$('#name-title').text(self.trip.name);
  			self.end_lat = self.trip.start_lat;
  			self.end_lng = self.trip.start_lng;
  			self.tripStartMarker.setLatLng(new GLatLng(
  					parseFloat(self.trip.start_lat), parseFloat(self.trip.start_lng)));
  			self.tripEndMarker.setLatLng(new GLatLng(
  					parseFloat(self.trip.end_lat), parseFloat(self.trip.end_lng)));
  			self.loadJSONRoute(self.trip.route);
  			self.centerOnTrip();
  			self.loadStartTrailheadRouters(self.trip.starting_trailhead_id);
  			self.loadEndTrailheadRouters(self.trip.ending_trailhead_id);
  			self.tripStartMarker.show();
  			self.tripEndMarker.show();
  		});
  	},

  	loadTrailheadIntoPlan: function(id) {
  	  var self = this;
  		var url = "/trailheads/" + id + ".json";
  		GDownloadUrl(url, function(data) {
  			self.trailhead = $.parseJSON(data)
  			self.end_lat = self.trailhead.latitude;
  			self.end_lng = self.trailhead.longitude;
  			$('#name-title').text(self.trailhead.name);
  			self.trailheadMarker.setLatLng(new GLatLng(
  					parseFloat(self.trailhead.latitude), parseFloat(self.trailhead.longitude)));
  			self.centerOnTrailhead();
  		});
  		this.loadStartTrailheadRouters(id);
  		this.loadEndTrailheadRouters(id);
  		this.trailheadMarker.show();
  	},

  	loadCampgroundIntoPlan: function(id) {
  	  var self = this;
  		var url = "/campgrounds/" + id + ".json";
  		GDownloadUrl(url, function(data) {
  			self.campground = $.parseJSON(data)
  			self.end_lat = self.campground.latitude;
  			self.end_lng = self.campground.longitude;
  			$('#name-title').text(self.campground.name);
  			self.campgroundMarker.setLatLng(new GLatLng(
  					parseFloat(self.campground.latitude), parseFloat(self.campground.longitude)));
  			self.centerOnCampground();
  		});
  		//this.loadStartTrailheadRouters(id);
  		//this.loadEndTrailheadRouters(id);
  		this.campgroundMarker.show();
  		this.google_router = true;
  		this.fiveoneone_router = true;
  	},

  	loadStartTrailheadRouters: function(id) {
  		var url = "/trailheads/" + id + "/transit_routers.json";
  		GDownloadUrl(url, function(data) {
  			var routers = $.parseJSON(data);
  			var google_router = false;
  			var fiveoneone_router = false;
  			var count = routers.length;
  			for(var router_i = 0;router_i<count;router_i++){
  				if(routers[router_i].name == 'Google Transit'){
  					this.google_router = true;
  				} else if(routers[router_i].name == '511.org') {
  					this.fiveoneone_router = true;
  				}
  			}
  		});
  	},

  	loadEndTrailheadRouters: function(id) {
  		var url = "/trailheads/" + id + "/transit_routers.json";
  		GDownloadUrl(url, function(data) {
  			var routers = $.parseJSON(data);
  			var google_router = false;
  			var fiveoneone_router = false;
  			var count = routers.length;
  			for(var router_i = 0;router_i<count;router_i++){
  				if(routers[router_i].name == 'Google Transit'){
  					this.google_router = true;
  				} else if(routers[router_i].name == '511.org') {
  					this.fiveoneone_router = true;
  				}
  			}
  		});
  	},

  	loadJSONRoute: function(json) {
  		if (this.tripLine != null) {
  			this.map.removeOverlay(this.tripLine);
  		}

  		var route = $.parseJSON(json);

  		points = new Array();
  		points.push(new GLatLng(route[0][0], route[0][1]));
  		for (i = 1; i < route.length; i+=1) {
  			points.push(new GLatLng(route[i][0],
  					route[i][1]));
  		}
  		this.tripLine = new GPolyline(points);
  		this.map.addOverlay(this.tripLine);
  	},

  	centerOnTrip: function() {
  		var points = new Array();
  		points.push(this.tripStartMarker.getLatLng());
  		points.push(this.tripEndMarker.getLatLng());
  		points.push(this.startFromMarker.getLatLng());
  		//points.push(this.returnToMarker.getLatLng());
  		var newLine = new GPolyline(points);
  		var centerpoint = newLine.getBounds().getCenter();
  		var zoom = this.map.getBoundsZoomLevel(newLine.getBounds());
  		this.map.setCenter(centerpoint, zoom-1);
  	},

  	centerOnTrailhead: function() {
  		var points = new Array();
  		points.push(this.trailheadMarker.getLatLng());
  		points.push(this.startFromMarker.getLatLng());
  		//points.push(this.returnToMarker.getLatLng());
  		var newLine = new GPolyline(points);
  		var centerpoint = newLine.getBounds().getCenter();
  		var zoom = this.map.getBoundsZoomLevel(newLine.getBounds());
  		this.map.setCenter(centerpoint, zoom-1);
  	},

  	centerOnCampground: function() {
  		var points = new Array();
  		points.push(this.campgroundMarker.getLatLng());
  		points.push(this.startFromMarker.getLatLng());
  		//points.push(this.returnToMarker.getLatLng());
  		var newLine = new GPolyline(points);
  		var centerpoint = newLine.getBounds().getCenter();
  		var zoom = this.map.getBoundsZoomLevel(newLine.getBounds());
  		this.map.setCenter(centerpoint, zoom-1);
  	},

	// These are all of the trip routing supper functions

  showDirections: function(isReturnTrip) {
    var router = $('#transit-router').val();

    if(!isReturnTrip) {
      // Need to update the display
      if(this.mode == 'trip') {
        this.end_lat = this.trip.start_lat;
        this.end_lng = this.trip.start_lng;
      } else if(this.trailhead) {
        this.end_lat = this.trailhead.latitude;
        this.end_lng = this.trailhead.longitude;
      }
      else if(this.campground){
        this.end_lat = this.campground.latitude;
        this.end_lng = this.campground.longitude;
      }
      else if(this.mode == 'trailhead'){
        this.end_lat = this.trailhead_latlng.lat();
        this.end_lng = this.trailhead_latlng.lng();
      }
      else{
        this.end_lat = this.point_latlng.lat();
        this.end_lng = this.point_latlng.lng();
      }

      this.start_lat = this.start_latlng.lat();
      this.start_lng = this.start_latlng.lng();
    }
    else
    {

      if(this.mode == 'trip') {
        this.start_lat = this.trip.end_lat;
        this.start_lng = this.trip.end_lng;
      }
      else if(this.trailhead){
        this.start_lat = this.trailhead.latitude;
        this.start_lng = this.trailhead.longitude;
      }  else if(this.campground){
        this.start_lat = this.campground.latitude;
        this.start_lng = this.campground.longitude;
      }
      else if(this.mode == 'trailhead'){
        this.start_lat = this.trailhead_latlng.lat();
        this.start_lng = this.trailhead_latlng.lng();
      }
      else{
        this.start_lat = this.point_latlng.lat();
        this.start_lng = this.point_latlng.lng();
      }

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
    raw_trip_date = $('#trip_date').val();
    trip_date_vals = raw_trip_date.split("/");
    trip_date_input = trip_date_vals[2] + trip_date_vals[0] + trip_date_vals[1]

    var zimride_url = $('#zimride_url').val();
    var start_from_address = $("#start-from-address").val();
    var url = zimride_url + "&s=" + start_from_address + "&date=" + raw_trip_date;
    var url = encodeURI(url);

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
      var url = "http://www.google.com/maps?f=d&source=s_d&saddr=" + escape(originName) + "%20@" + start_lat
              + "+,+" + start_lng + "&daddr=" + escape(destinationName) + "%20@" + end_lat + "+,+" + end_lng
              + "&hl=en&mra=ls&ttype=" + trip_arr_dep + "&noexp=0&noal=0&sort="
              + "&time=" + trip_hour + ":" + trip_minute + trip_ampm + "&date=" + escape(trip_date);
      return url;
  },

  buildGoogleTransitURLBase: function(trip_date, trip_arr_dep, trip_hour, trip_minute, trip_ampm, start_lat, start_lng, end_lat, end_lng, originName, destinationName, mode) {
      var url = "http://www.google.com/maps?f=d&source=s_d&saddr=" + escape(originName) + "%20@" + start_lat
              + "+,+" + start_lng + "&daddr=" + escape(destinationName) + "%20@" + end_lat + "+,+" + end_lng
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
  }


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


};



// Plan Driving Route Stuff

startDirections = new GDirections();
GEvent.addListener(startDirections, "load", onStartDirectionsLoad);
GEvent.addListener(startDirections, "error", handleStartDirectionsErrors);

tripDirections = new GDirections();
GEvent.addListener(tripDirections, "load", onTripDirectionsLoad);
GEvent.addListener(tripDirections, "error", handleTripDirectionsErrors);

endDirections = new GDirections();
GEvent.addListener(endDirections, "load", onEndDirectionsLoad);
GEvent.addListener(endDirections, "error", handleEndDirectionsErrors);

function onStartDirectionsLoad() {
    TNT.plan.startMiles = startDirections.getDistance().meters * 0.000621371192;
    if(TNT.plan.mode == 'trailhead')
    {
        TNT.plan.totalMiles = TNT.plan.startMiles * 2;
        $("#driving-miles").text(TNT.plan.totalMiles.toFixed(1));
        TNT.plan.driving_gallons = (TNT.plan.totalMiles / 21).toFixed(1);
        $("#driving-gas").text(TNT.plan.driving_gallons);
        TNT.plan.driving_cost = (TNT.plan.driving_gallons * 4).toFixed(2);
        $("#driving-money").text(TNT.plan.driving_cost);
        TNT.plan.driving_carbon = (TNT.plan.driving_gallons * 19.4).toFixed(1);
        $("#driving-carbon").text(TNT.plan.driving_carbon);
    } else {
      showEndDrivingRoutes();
    }
}

function handleStartDirectionsErrors()
{
    TNT.plan.startMiles = 0;
    showEndDrivingRoutes();
}

function showTripDrivingRoutes() {
    if(TNT.plan.mode == 'trip' && TNT.plan.start_lat != TNT.plan.end_lat && TNT.plan.start_lng != TNT.plan.end_lng) {
        start = TNT.plan.start_lat + "," + TNT.plan.start_lng;
        end = TNT.plan.end_lat + "," + TNT.plan.end_lng;
        directionOptions = {
            travelMode : G_TRAVEL_MODE_DRIVING,
            getPolyline : false
        }
        tripDirections.clear();
        tripDirections.load("from: " + start + " to: " + end,directionOptions)
    }
    else {
        TNT.plan.tripMiles = 0;
        showStartDrivingRoutes();
    }
}

function onTripDirectionsLoad()
{
    TNT.plan.tripMiles = tripDirections.getDistance().meters * 0.000621371192;
    if (TNT.plan.mode == 'trip' && TNT.plan.start_lat != TNT.plan.end_lat && TNT.plan.start_lng != TNT.plan.end_lng) {
        TNT.plan.tripMiles = TNT.plan.tripMiles * 2;
    }
    showStartDrivingRoutes();
}

function handleTripDirectionsErrors()
{
    showStartDrivingRoutes();
    TNT.plan.tripMiles = 0;
}

function showStartDrivingRoutes(){
    var start = TNT.plan.start_lat + "," + TNT.plan.start_lng;
    var end = TNT.plan.end_lat + "," + TNT.plan.end_lng;
    directionOptions = {
        travelMode : G_TRAVEL_MODE_DRIVING,
        getPolyline : true
    }
    startDirections.clear();
    startDirections.load("from: " + start + " to: " + end,directionOptions)
}

function showEndDrivingRoutes(){
    start = TNT.plan.start_lat + "," + TNT.plan.start_lng;
    end = TNT.plan.end_lat + "," + TNT.plan.end_lng;
    directionOptions = {
        travelMode : G_TRAVEL_MODE_DRIVING,
        getPolyline : true
    }
    endDirections.clear();
    endDirections.load("from: " + start + " to: " + end,directionOptions)
}

function onEndDirectionsLoad()
{
    TNT.plan.endMiles = endDirections.getDistance().meters * 0.000621371192;
    if(TNT.plan.mode == 'trip' && TNT.plan.tripMiles > 0)
    {
        TNT.plan.totalMiles = TNT.plan.tripMiles + (TNT.plan.startMiles*2) + (TNT.plan.endMiles*2);
    }
    else{
        TNT.plan.totalMiles = TNT.plan.startMiles +TNT.plan.endMiles;
    }
    $("#driving-miles").text(TNT.plan.totalMiles.toFixed(1));
    TNT.plan.driving_gallons = (TNT.plan.totalMiles / 21).toFixed(1);
    $("#driving-gas").text(TNT.plan.driving_gallons);
    TNT.plan.driving_cost = (TNT.plan.driving_gallons * 4).toFixed(2);
    $("#driving-money").text(TNT.plan.driving_cost);
    TNT.plan.driving_carbon = (TNT.plan.driving_gallons * 19.4).toFixed(1);
    $("#driving-carbon").text(TNT.plan.driving_carbon);
}

function handleEndDirectionsErrors(){
//  alert('end directions errors : ' + endDirections.getStatus().request + " : " + endDirections.getStatus().code);
    TNT.plan.endMiles = 0;
    if(TNT.plan.mode == 'trip' && TNT.plan.tripMiles > 0)
    {
        TNT.plan.totalMiles = TNT.plan.tripMiles + (TNT.plan.startMiles*2) + (TNT.plan.endMiles*2);
    }
    else{
        TNT.plan.totalMiles = TNT.plan.startMiles + TNT.plan.endMiles;
    }
    TNT.plan.driving_gallons = (TNT.plan.totalMiles / 21).toFixed(1);
    TNT.plan.driving_cost = (TNT.plan.gallons * 4).toFixed(2);
    TNT.plan.driving_carbon = (TNT.plan.gallons * 19.4).toFixed(2);
}
