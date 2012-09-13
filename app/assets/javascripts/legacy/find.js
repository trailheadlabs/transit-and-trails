$(function() {
    $(window).unload(function() {
        GUnload();
    });
    $('input[type=text]').focus(function() {
        this.select();
    });
    $('form#show').submit(function(event) {
        notEmpty($('#radius'));
        TNT.find.showAddress($('#address').val());
        event.preventDefault();
    });

    $('.trail-type-trailhead .details-link').live('click',
    function(event) {
        id = parseInt($(event.target).attr('rel'));
        TNT.find.showTrailhead(id)
        event.preventDefault();
    });

    $('.trail-type-trailhead .details-link').live('mouseenter',
    function(event) {
        id = parseInt($(event.target).attr('rel'));
        TNT.find.highlightTrailheadMarker(id)
        event.preventDefault();
    });

    $('.trail-type-trailhead .details-link').live('mouseleave',
    function(event) {
        id = parseInt($(event.target).attr('rel'));
        TNT.find.unhighlightTrailheadMarker(id)
        event.preventDefault();
    });

    $('.trail-type-trip .details-link').live('mouseenter',
    function(event) {
        id = parseInt($(event.target).attr('rel'));
        TNT.find.highlightTripMarker(id)
        event.preventDefault();
    });

    $('.trail-type-trip .details-link').live('mouseleave',
    function(event) {
        id = parseInt($(event.target).attr('rel'));
        TNT.find.unhighlightTripMarker(id)
        event.preventDefault();
    });

    $('.trail-type-campground .details-link').live('mouseenter',
    function(event) {
        id = parseInt($(event.target).attr('rel'));
        TNT.find.highlightCampgroundMarker(id)
        event.preventDefault();
    });

    $('.trail-type-campground .details-link').live('mouseleave',
    function(event) {
        id = parseInt($(event.target).attr('rel'));
        TNT.find.unhighlightCampgroundMarker(id)
        event.preventDefault();
    });

    $('.trail-type-trip .details-link').live('click',
    function(event) {
        id = parseInt($(event.target).attr('rel'));
        TNT.find.showTrip(id)
        event.preventDefault();
    });

    $('.trail-type-campground .details-link').live('click',
    function(event) {
        id = parseInt($(event.target).attr('rel'));
        TNT.find.showCampground(id)
        event.preventDefault();
    });

    $('#object-select').mouseenter(function() {
            expandObjectSelect();
    });

    $('#object-select, #object-select-box').mouseleave(function() {
            collapseObjectSelect();
    });

    $("#show-trips-checkbox, #show-trailheads-checkbox, #show-campgrounds-checkbox").click(function(){
      var newLabel = '';
      if ($('#show-trips-checkbox').is(':checked')) {
          newLabel += "trips";
          saveKeyValueToSession('showTrips',true);
      } else {
        saveKeyValueToSession('showTrips',false);
      }
      if ($('#show-trailheads-checkbox').is(':checked')) {
          if (newLabel != '') {
              newLabel += ', ';
          }
          newLabel += 'trailheads';
          saveKeyValueToSession('showTrailheads',true);
      } else {
        saveKeyValueToSession('showTrailheads',false);
      }
      if ($('#show-campgrounds-checkbox').is(':checked')) {
          if (newLabel != '') {
              newLabel += ', ';
          }
          newLabel += 'campgrounds';
          saveKeyValueToSession('showCampgrounds',true);
      } else {
        saveKeyValueToSession('showCampgrounds',false);
      }
      if(newLabel == '')
      {
        newLabel = "please select"
      }
      $('#object-select-label').text(newLabel);
      updateObjectDisplay();
    });
});

function expandObjectSelect() {
    $('#object-select-box').slideDown(200);
    $('#object-select').addClass("expanded");
}

function collapseObjectSelect() {
    $('#object-select-box').slideUp(400,
    function() {
        $('#object-select').removeClass("expanded");
        var newLabel = '';
        if ($('#show-trips-checkbox').is(':checked')) {
            newLabel += "trips";
            saveKeyValueToSession('showTrips','true');
        } else {
          saveKeyValueToSession('showTrips','false');
        }
        if ($('#show-trailheads-checkbox').is(':checked')) {
            if (newLabel != '') {
                newLabel += ', ';
            }
            newLabel += 'trailheads';
            saveKeyValueToSession('showTrailheads','true');
        } else {
          saveKeyValueToSession('showTrailheads','false');
        }
        if ($('#show-campgrounds-checkbox').is(':checked')) {
            if (newLabel != '') {
                newLabel += ', ';
            }
            newLabel += 'campgrounds';
            saveKeyValueToSession('showCampgrounds','true');
        } else {
          saveKeyValueToSession('showCampgrounds','false');
        }
        if(newLabel == '')
        {
          newLabel = "please select"
        }

        $('#object-select-label').text(newLabel);
    });
    updateObjectDisplay();

}

function updateObjectDisplay() {
    TNT.find.toggleTrailheads($('#show-trailheads-checkbox').is(':checked'));
    TNT.find.toggleTrips($('#show-trips-checkbox').is(':checked'));
    TNT.find.toggleCampgrounds($('#show-campgrounds-checkbox').is(':checked'))
}

function initialize(starting_lat,starting_lng) {
    if (GBrowserIsCompatible()) {
        TNT.find.init();
        TNT.find.chooseStart(starting_lat,starting_lng);
        loadKeyFromSession('showTrips', function(data){

          if(data.value == false){
            $('#show-trips-checkbox').removeAttr('checked');
          }
          loadKeyFromSession('showTrailheads', function(data){
            if(data.value == false){
              $('#show-trailheads-checkbox').removeAttr('checked');
            }
            loadKeyFromSession('showCampgrounds', function(data){
              if(data.value == false){
                $('#show-campgrounds-checkbox').removeAttr('checked');
              }
              collapseObjectSelect();
            })
          })
        });
    }
}

function initialize_park(id) {
    if (GBrowserIsCompatible()) {
        TNT.find.init();
        TNT.find.park_page = true;
        var latlngbounds = new GLatLngBounds();
        var count = gpolys.length;
        $(gpolys).each(function(index, item) {
            var parkoverlay = new GPolygon(item, "#ff0000", 1, 0, "#red", 0.3);
            var bounds = parkoverlay.getBounds();
            TNT.find.map.addOverlay(parkoverlay);
            latlngbounds.extend(bounds.getCenter());
            latlngbounds.extend(bounds.getSouthWest());
            latlngbounds.extend(bounds.getNorthEast());
        });
        TNT.find.map.setCenter(latlngbounds.getCenter(), TNT.find.map.getBoundsZoomLevel(latlngbounds));
        if (typeof trips !== 'undefined' ) {
            TNT.find.loadTripsInline(trips);
        }
        if (typeof trailheads !== 'undefined') {
            TNT.find.loadTrailheadsInline(trailheads);
        }
        $('.trail-list-progress').hide();
        $("#trail-list").jScrollPane();
    }
}

var TNT = {}

TNT.find = {

    showTrips: true,
    showTrailheads: true,
    showCampgrounds: true,

    radius: 15,

    walkOverlay: null,

    currentTrailheads: null,
    currentCampgrounds: null,
    currentTrips: null,

    rangeOverlay: null,
    map: null,
    geocoder: null,
    startLatLng: null,

    trailheadMarkerManager: null,
    tripMarkerManager: null,
    campgroundMarkerManager: null,

    startmarker: null,
    startFromMarker: null,
    endLatLng: null,

    init: function() {
        this.map = new GMap2($("#find-map")[0]);
        this.startLatLng = new GLatLng(37.7750, -122.4190);
        this.endLatLng = new GLatLng(37.7750, -122.4190);

        this.map.setCenter(this.startLatLng, 11);

        this.trailheadMarkerManager = new MarkerManager(this.map);
        this.tripMarkerManager = new MarkerManager(this.map);
        this.campgroundMarkerManager = new MarkerManager(this.map);

        // Create our start marker icon
        var startIcon = new GIcon(G_DEFAULT_ICON);
        startIcon.image = "/assets/legacy/map/pin_s_home.png";
        startIcon.iconSize = new GSize(34, 36);
        startIcon.shadowSize = new GSize(38, 36);
        startIcon.iconAnchor = new GPoint(14, 30);
        startIcon.infoWindowAnchor = new GPoint(14, 10);

        // Set up our GMarkerOptions object
        var markerOptions = {
            icon: startIcon,
            draggable: true
        };
        this.startmarker = new GMarker(this.startLatLng, markerOptions);

        // Create our "tiny" marker icon
        var startFromIcon = new GIcon(G_DEFAULT_ICON);
        startFromIcon.image = "/assets/legacy/map/trip-start.png";
        startFromIcon.iconSize = new GSize(26, 26);
        startFromIcon.shadowSize = new GSize(0, 0);
        startFromIcon.iconAnchor = new GPoint(10, 26);
        startFromIcon.infoWindowAnchor = new GPoint(10, 5);
        // Set up our GMarkerOptions object
        markerOptions = {
            icon: startFromIcon,
            draggable: true
        };
        this.startFromMarker = new GMarker(this.startLatLng, markerOptions);

        // Create our "tiny" marker icon
        var returnToIcon = new GIcon(G_DEFAULT_ICON);
        returnToIcon.image = "http://www.google.com/mapfiles/dd-end.png";

        var endMarkerOptions = {
            icon: returnToIcon,
            draggable: true
        };

        this.endmarker = new GMarker(this.endLatLng, endMarkerOptions);

        this.map.addControl(new GLargeMapControl3D());

        var scaleControlPosition = new GControlPosition(G_ANCHOR_BOTTOM_LEFT, new GSize(10, 40));
        this.map.addControl(new GScaleControl(), scaleControlPosition);
        this.map.enableContinuousZoom();

        var copyOSM = new GCopyrightCollection("<a href=\"http://www.openstreetmap.org/\">OpenStreetMap</a>");
        copyOSM.addCopyright(new GCopyright(1, new GLatLngBounds(new GLatLng( - 90, -180), new GLatLng(90, 180)), 0, " "));
        var tilesMapnik = new GTileLayer(copyOSM, 1, 17, {
            tileUrlTemplate: 'http://tile.openstreetmap.org/{Z}/{X}/{Y}.png'
        });
        var mapMapnik = new GMapType([tilesMapnik], G_NORMAL_MAP.getProjection(), "OSM");
        this.map.addMapType(mapMapnik);

        // Add and set map type
        this.map.addMapType(G_PHYSICAL_MAP);
        this.map.addMapType(G_SATELLITE_3D_MAP);
        this.map.setMapType(G_NORMAL_MAP);
        this.map.addControl(new GHierarchicalMapTypeControl());
        this.map.addControl(new GZoomControl(
        /* first set of options is for the visual overlay.*/
        {
            nOpacity: .2,
            sBorder: "2px solid red"
        },
        /* second set of options is for everything else */
        {
            sButtonHTML: "<img src='/assets/legacy/zoom-button.gif' />",
            sButtonZoomingHTML: "<img src='/assets/legacy/zoom-button-activated.gif' />",
            oButtonStartingStyle: {
                width: '24px',
                height: '24px'
            }
        },
        /* third set of options specifies callbacks */
        {
            //	buttonClick:function(){display("Looks like you activated GZoom!")},
            //			dragStart:function(){display("Started to Drag . . .")},
            //		dragging:function(x1,y1,x2,y2){display("Dragging, currently x="+x2+",y="+y2)},
            //	dragEnd:function(nw,ne,se,sw,nwpx,nepx,sepx,swpx){display("Zoom! NE="+ne+";SW="+sw)},
            }), new GControlPosition(G_ANCHOR_TOP_RIGHT, new GSize(24, 48)));

        this.map.addOverlay(this.startmarker);

        GEvent.bind(this.startmarker, "dragend", this, this.dragMoveStart);
        GEvent.bind(this.map, "dblclick", this, this.saveMap);
        GEvent.bind(this.map, "zoomend", this, this.saveMap);
        this.geocoder = new GClientGeocoder();

        loadKeyFromSession('map.zoom',function(data){
          if( data.value && !TNT.find.park_page ){
            TNT.find.map.setZoom(Number(data.value));
          }
        })
    },

    chooseStart: function(starting_lat,starting_lng) {
        // If there is a start location saved in the session then use it
        if(typeof(starting_lat) != 'undefined' && typeof(starting_lng) != 'undefined'){
          TNT.find.startLatLng = new GLatLng(starting_lat, starting_lng);
          TNT.find.getStartReverseGeocode(TNT.find.startLatLng);
          TNT.find.showLatLng(TNT.find.startLatLng);
        } else {
            loadLocationFromSession(
              function(data) {
                    data = data.value
                  if (data) {
                      $('#address').val(data);
                      TNT.find.showAddress(data);
                  }
                  else {
                      $('#address').val('San Francisco, CA');
                      TNT.find.showAddress('San Francisco, CA');
                  }
            });
        }
    },

    showWalking: function() {
        var dirString = "from: " + this.startmarker.getLatLng().toUrlValue() +
        " to: " +
        this.endmarker.getLatLng().toUrlValue();
        var directions = new GDirections(this.map, null);
        directions.load(dirString, {
            travelMode: G_TRAVEL_MODE_WALKING
        });
    },

    removeCurrentTrailheads: function() {
        if (this.currentTrailheads != null) {
            for (var i = 0; i < this.currentTrailheads.length; i++) {
                this.map.removeOverlay(this.currentTrailheads[i]);
            }
        }
    },

    removeCurrentCampgrounds: function() {
        if (this.currentCampgrounds != null) {
            for (var i = 0; i < this.currentCampgrounds.length; i++) {
                this.map.removeOverlay(this.currentCampgrounds[i]);
            }
        }
    },

    findTrips: function() {
        var that = this;
        downloadurl = "/trips/near_coordinates.json?latitude=" + this.startmarker.getLatLng().lat() +
        "&longitude=" +
        +this.startmarker.getLatLng().lng() +
        "&distance=" +
        $('#radius').val();
        GDownloadUrl(downloadurl,
        function(data) {
            var xml = $.parseJSON(data);
            var markers = xml;
            that.currentTrips = []
            that.tripMarkerManager.clearMarkers();
            for (var i = 0; i < markers.length; i++) {
                var latlng = new GLatLng(parseFloat(markers[i]["latitude"]), parseFloat(markers[i]["longitude"]));
                var tripTitle = markers[i]["name"];
                var tripId = new Number(markers[i]["id"]);
                var newMarker = that.createTripMarker(tripId, tripTitle, latlng);
                that.currentTrips[tripId] = newMarker;
                if (that.showTrips) {
                    that.tripMarkerManager.addMarker(newMarker, 0);
                }
            }
            that.tripMarkerManager.refresh();
        });
    },

    loadTripsInline: function(data) {
        this.currentTrips = [];
        var newHtml="";
        for (var i = 0; i < data.length; i++) {
            trip = data[i]
            var latlng = trip.latlng;
            var tripTitle = trip.tripTitle;
            var tripId = trip.tripId;
            var newMarker = this.createTripMarker(tripId, tripTitle, latlng);
            newHtml = newHtml + '<li class="trail-type-trip">' +
    					'<h2 id="h2_'+ tripId + '" class="details-link" rel="'+ tripId +'">'+ tripTitle + '</h2>' +
    					'<p><a href="/trips/' + tripId + '" >Details</a> | <a href="/plan/trip/' + tripId +
    					'">Plan</a></p></li>';
            this.currentTrips[tripId] = newMarker;
        }
        $("#trail-list > ul").append(newHtml);
        this.tripMarkerManager.clearMarkers();
        var tripsArray = [];
        $(this.currentTrips).each(function(index, value) {
            if (value != undefined) {
                tripsArray.push(value);
            }
        });

        this.tripMarkerManager.addMarkers(tripsArray, 0);
        this.tripMarkerManager.refresh();

    },

    findCampgrounds: function() {
        var that = this;
        //this.removeCurrentCampgrounds();
        downloadurl = "/campgrounds/near_coordinates.json?latitude=" +
        this.startmarker.getLatLng().lat() +
        "&longitude=" +
        +this.startmarker.getLatLng().lng() +
        "&distance=" +
        $('#radius').val();
        GDownloadUrl(downloadurl,
        function(data) {
            var xml = $.parseJSON(data);
            var markers = xml;
            that.currentCampgrounds = []
            that.campgroundMarkerManager.clearMarkers();
            for (var i = 0; i < markers.length; i++) {
                var latlng = new GLatLng(parseFloat(markers[i]["latitude"]), parseFloat(markers[i]["longitude"]));
                var distance = new Number(markers[i]["distance"]).toPrecision(2);
                var pointTitle = markers[i]["name"];
                var pointId = parseInt(markers[i]["id"]);
                var newMarker = that.createCampgroundMarker(pointId, pointTitle, latlng);
                that.currentCampgrounds[pointId] = newMarker;
                if (that.showCampgrounds) {
                    that.campgroundMarkerManager.addMarker(newMarker, 0);
                }
            }
            that.campgroundMarkerManager.refresh();
        });
    },

    createTrailheadMarker: function(pointId, pointTitle, latlng) {
        var that = this;
        var tinyIcon = new GIcon();
        tinyIcon.image = "/assets/legacy/map/pin_s_trailhead.png";
        tinyIcon.iconSize = new GSize(34, 36);
        tinyIcon.shadowSize = new GSize(38, 36);
        tinyIcon.iconAnchor = new GPoint(14, 30);
        tinyIcon.infoWindowAnchor = new GPoint(14, 10);

        var pointMarkerOptions = {
            icon: tinyIcon,
            title: pointTitle,
            draggable: false,
            clickable: true
        };
        var newMarker = new GMarker(latlng, pointMarkerOptions);

        GEvent.addListener(newMarker, "click",
        function() {
            that.showTrailhead(pointId);
        });
        return newMarker;
    },

    findTrailheads: function() {
        var that = this;
        //that.removeCurrentTrailheads();
        downloadurl = "/trailheads/near_coordinates.json?latitude=" +
        that.startmarker.getLatLng().lat() +
        "&longitude=" +
        that.startmarker.getLatLng().lng() +
        "&distance=" +
        $('#radius').val();
        GDownloadUrl(downloadurl,
        function(data) {
            that.loadTrailheads(data);
        });
    },

    loadTrailheads: function(data) {
        var that = this;
        var xml = $.parseJSON(data);
        var markers = xml;
        that.currentTrailheads = []
        that.trailheadMarkerManager.clearMarkers();
        $(markers).each(function(index,item) {
            var latlng = new GLatLng(parseFloat(item["latitude"]), parseFloat(item["longitude"]));
            var distance = new Number(item["distance"]).toPrecision(2);
            var pointTitle = item["name"];
            var pointId = new Number(item["id"]);
            var newMarker = that.createTrailheadMarker(pointId, pointTitle, latlng);
            that.currentTrailheads[pointId] = newMarker;
            if (that.showTrailheads) {
                that.trailheadMarkerManager.addMarker(newMarker, 0);
            }
        });

        that.trailheadMarkerManager.refresh();
    },

    loadTrailheadsInline: function(inlineData) {
        this.currentTrailheads = [];
        var newHtml = "";
        for (var i = 0; i < inlineData.length; i++) {
            var trailhead = inlineData[i];
            var pointId = trailhead.pointId;
            var newMarker = this.createTrailheadMarker(pointId, trailhead.pointTitle, trailhead.latlng);
            newHtml = newHtml + '<li class="trail-type-trailhead">' +
    					'<h2 id="h2_'+ pointId + '" class="details-link" rel="'+ pointId +'">'+ trailhead.pointTitle + '</h2>' +
    					'<p><a href="/trailheads/' + pointId + '" >Details</a> | <a href="/plan/trailhead/' + pointId +
    					'">Plan</a></p></li>';
            this.currentTrailheads[pointId] = newMarker;
        }
        $("#trail-list > ul").append(newHtml);

        this.trailheadMarkerManager.clearMarkers();
        if (this.showTrailheads) {
            var trailheadsArray = [];
            $(this.currentTrailheads).each(function(index, value) {
                if (value != undefined) {
                    trailheadsArray.push(value);
                }
            });

            this.trailheadMarkerManager.addMarkers(trailheadsArray, 0);
        }
        this.trailheadMarkerManager.refresh();
    },
    createCampgroundMarker: function(pointId, pointTitle, latlng) {
        var that = this;
        var tinyIcon = new GIcon();
        tinyIcon.image = "/assets/legacy/map/pin_s_campground.png";
        tinyIcon.iconSize = new GSize(34, 36);
        tinyIcon.shadowSize = new GSize(38, 36);
        tinyIcon.iconAnchor = new GPoint(14, 30);
        tinyIcon.infoWindowAnchor = new GPoint(14, 10);

        var pointMarkerOptions = {
            icon: tinyIcon,
            title: pointTitle,
            draggable: false,
            clickable: true
        };
        // TNT.find.trailheadMgr.addMarker(new
        // GMarker(latlng,pointMarkerOptions));
        var newMarker = new GMarker(latlng, pointMarkerOptions);
        GEvent.addListener(newMarker, "click",
        function() {
            that.showCampground(pointId);
        });
        return newMarker;
    },

    createTripMarker: function(tripId, tripTitle, latlng) {
        var that = this;
        var tinyIcon = new GIcon();
        tinyIcon.image = "/assets/legacy/map/pin_s_tripstart.png";
        tinyIcon.iconSize = new GSize(34, 36);
        tinyIcon.shadowSize = new GSize(38, 36);
        tinyIcon.iconAnchor = new GPoint(14, 30);
        tinyIcon.infoWindowAnchor = new GPoint(14, 10);

        var pointMarkerOptions = {
            icon: tinyIcon,
            title: tripTitle,
            draggable: false,
            clickable: true
        };
        var newMarker = new GMarker(latlng, pointMarkerOptions);
        GEvent.addListener(newMarker, "click",
        function() {
            that.showTrip(tripId);
        });
        return newMarker;
    },

    moveStart: function(overlay, latlng) {
        var that = this;
        if (latlng) {
            //TNT.find.showLatLng(latlng);
            TNT.find.getStartReverseGeocode(latlng);
        }
    },

    dragMoveStart: function(overlay, latlng) {
        if (overlay) {
            var latlng = overlay;
            TNT.find.getStartReverseGeocode(latlng);
        }
    },

    moveEnd: function(overlay, latlng) {
        if (overlay) {
            this.getEndReverseGeocode(this.endmarker.getLatLng());
        }
        if (latlng) {
            this.endmarker.setLatLng(latlng);
            this.getEndReverseGeocode(latlng);
        }

    },

    getStartReverseGeocode: function(latlng) {
        if (latlng != null) {
            this.geocoder.getLocations(latlng, this.populateStartAddress);
        }
    },

    populateStartAddress: function(response) {
        var that = this;
        if (!response || response.Status.code != 200) {
            //alert("Could not populate start address.\nStatus Code:" + response.Status.code);
            $('#address').val($('#lat').val() + ", " + $('#lng').val());
            saveLocationToSession($("#address").val());
            TNT.find.saveMap();
        }
        else {
            var place = response.Placemark[0];
            var point = new GLatLng(place.Point.coordinates[1], place.Point.coordinates[0]);
            $('#address').val(place.address);
            TNT.find.showAddress(place.address);
            saveLocationToSession($("#address").val());
            TNT.find.saveMap();
        }

    },

    saveMap: function() {
        saveKeyValueToSession('map.center', this.map.getCenter().toUrlValue());
        saveKeyValueToSession('map.zoom', this.map.getZoom());
    },

    showAddress: function(address) {
        if (TNT.find.geocoder) {
            TNT.find.geocoder.getLatLng(address,
            function(point) {
                if (point) {
                  TNT.find.showLatLng(point);
                }
            })
        }
    },

    showLatLng: function(point) {
        this.startmarker.setLatLng(point);
        this.map.setCenter(point);
        this.findCampgrounds();
        this.findTrailheads();
        this.findTrips();
        downloadurl = "/objects/near/html?lat=" +
        this.startmarker.getLatLng().lat() +
        "&long=" +
        this.startmarker.getLatLng().lng() +
        "&distance=" +
        $('#radius').val();
        $('#trail-list').load(downloadurl,
        function() {
            $('#trail-list ul').jScrollPane();
            updateObjectDisplay();

        });
        saveLocationToSession($("#address").val());
        TNT.find.saveMap();
    },

    toggleTrailheads: function(checked) {
        var self = this;
        self.showTrailheads = checked;
        if (self.showTrailheads) {
            var trailheadsArray = [];
            $(this.currentTrailheads).each(function(index, value) {
                if (value != undefined) {
                    trailheadsArray.push(value);
                }
            });

            self.trailheadMarkerManager.clearMarkers();
            self.trailheadMarkerManager.addMarkers(trailheadsArray, 0);
            self.trailheadMarkerManager.refresh();
            $(".trail-type-trailhead").slideDown(200);
        }
        else {
            self.trailheadMarkerManager.clearMarkers();
            self.trailheadMarkerManager.refresh();
            $(".trail-type-trailhead").slideUp(200);
        }
    },

    toggleCampgrounds: function(checked) {
        this.showCampgrounds = checked;
        if (this.showCampgrounds) {
            var campgroundsArray = [];
            $(this.currentCampgrounds).each(function(index, value) {
                if (value != undefined) {
                    campgroundsArray.push(value);
                }
            });
            this.campgroundMarkerManager.clearMarkers();
            this.campgroundMarkerManager.addMarkers(campgroundsArray, 0);
            this.campgroundMarkerManager.refresh();
            $(".trail-type-campground").slideDown(200);
        }
        else {
            this.campgroundMarkerManager.clearMarkers();
            this.campgroundMarkerManager.refresh();
            $(".trail-type-campground").slideUp(200);        }
    },

    toggleTrips: function(checked) {
        this.showTrips = checked;
        if (this.showTrips) {
            var tripsArray = [];
            $(this.currentTrips).each(function(index, value) {
                if (value != undefined) {
                    tripsArray.push(value);
                }
            });

            this.tripMarkerManager.clearMarkers();
            this.tripMarkerManager.addMarkers(tripsArray, 0);
            this.tripMarkerManager.refresh();
            $(".trail-type-trip").slideDown(200);
        }
        else {
            this.tripMarkerManager.clearMarkers();
            this.tripMarkerManager.refresh();
            $(".trail-type-trip").slideUp(200);
        }
    },

    highlightTripMarker: function(index) {
        this.currentTrips[index].setImage('/assets/legacy/map/pin_s_tripstart_active.png');

    },

    unhighlightTripMarker: function(index) {
        this.currentTrips[index].setImage('/assets/legacy/map/pin_s_tripstart.png');
    },

    highlightTrailheadMarker: function(id) {
        var marker = this.currentTrailheads[id];
        marker.setImage('/assets/legacy/map/pin_s_trailhead_active.png');
    },

    unhighlightTrailheadMarker: function(id) {
        this.currentTrailheads[id].setImage('/assets/legacy/map/pin_s_trailhead.png');
    },

    highlightCampgroundMarker: function(index) {
        var marker = this.currentCampgrounds[index];
        marker.setImage('/assets/legacy/map/pin_s_campground_active.png');
    },

    unhighlightCampgroundMarker: function(index) {
        this.currentCampgrounds[index].setImage('/assets/legacy/map/pin_s_campground.png');
    },

    showTrailheadInfoWindow: function(id) {
        var that = this;
        var url = '/trailheads/' + id + '/info_window';

        GDownloadUrl(url,
        function(data) {
            that.currentTrailheads[id].openInfoWindowHtml(data);
        });
    },

    showCampgroundInfoWindow: function(id) {
        var that = this;
        var url = '/campgrounds/' + id + '/info_window';
        GDownloadUrl(url,
        function(data) {
            that.currentCampgrounds[id].openInfoWindowHtml(data);
        });
    },

    showTripNameWindow: function(id, index) {
        this.currentTrips[index].openInfoWindowHtml('<b>Long Name Here<b>');
    },

    showTripInfoWindow: function(id) {
        var that = this;
        var url = '/trips/' + id + '/info_window';
        GDownloadUrl(url,
        function(data) {
            that.currentTrips[id].openInfoWindowHtml(data);
        });
    },

    showTrailhead: function(id) {
        if (this.showTrailheads != true) {
            $('#toggle_trailheads').checked = true
            this.toggleTrailheads();
        }

        this.showTrailheadInfoWindow(id);
    },

    showCampground: function(id) {
        var latlng = this.currentCampgrounds[id].getLatLng();
        if (this.showCampgrounds != true) {
            $('#toggle_campgrounds').checked = true
            toggleCampgrounds();
        }
        this.showCampgroundInfoWindow(id);
    },

    showTrip: function(id) {
        this.showTripInfoWindow(id);
    },

    showClosest: function(id, index) {
        this.showTripInfoWindow(id, index);
    },

    loadLastLocation: function() {
        loadLocationFromSession(
        function(data) {
            $('#address').val(data.value);
            that.showAddress(data.value);
        });
    }
};
// ]]>
