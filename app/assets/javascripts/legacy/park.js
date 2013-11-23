
window.TNT = {};

window.TNT.find = {
    currentTrailheads: null,
    currentCampgrounds: null,
    currentTrips: null,

    map: null,

    trailheadMarkerManager: null,
    tripMarkerManager: null,
    campgroundMarkerManager: null,


    init: function() {
      var start = new google.maps.LatLng(37.887771, -122.256452);
      var mapOptions = {
        center: new google.maps.LatLng(start.lat(),start.lng()),
        zoom: 17,
        mapTypeId: google.maps.MapTypeId.ROADMAP,
        mapTypeControl: true,
        mapTypeControlOptions: {
          mapTypeIds: [google.maps.MapTypeId.TERRAIN,google.maps.MapTypeId.SATELLITE,google.maps.MapTypeId.ROADMAP,'OSM'],
          position: google.maps.ControlPosition.TOP_RIGHT,
          style: google.maps.MapTypeControlStyle.DROPDOWN_MENU
        },
        zoomControl: true,
        zoomControlOptions: {
          position: google.maps.ControlPosition.TOP_RIGHT,
          style: google.maps.ZoomControlStyle.SMALL
        },
        panControl: false
      };

      this.map = new google.maps.Map(document.getElementById("find-map"),
                mapOptions);

      this.overlay = new google.maps.OverlayView();
      this.overlay.draw = function() {};
      this.overlay.setMap(this.map);      

      //Define OSM map type pointing at the OpenStreetMap tile server
      this.map.mapTypes.set("OSM", new google.maps.ImageMapType({
          getTileUrl: function(coord, zoom) {
              return "http://tile.openstreetmap.org/" + zoom + "/" + coord.x + "/" + coord.y + ".png";
          },
          tileSize: new google.maps.Size(256, 256),
          name: "OSM",
          maxZoom: 18
      }));

      this.trailheadMarkerManager = new MarkerManager(this.map);
      this.tripMarkerManager = new MarkerManager(this.map);
      this.campgroundMarkerManager = new MarkerManager(this.map);      
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
    					'<a href="/trips/' + tripId + '"><h2 id="h2_'+ tripId + '" class="details-link" rel="'+ tripId +'">'+ tripTitle + '</h2></a>' +
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

    createTrailheadMarker: function(pointId, pointTitle, latlng) {
        var that = this;
        var tinyIcon = {}
        tinyIcon.url = "/assets/legacy/map/pin_s_trailhead.png";
        tinyIcon.scaledSize = new google.maps.Size(34, 36);
        tinyIcon.shadowSize = new google.maps.Size(38, 36);
        tinyIcon.anchor = new google.maps.Point(14, 30);

        var pointMarkerOptions = {
            map: TNT.find.map,
            position: latlng,
            anchor: google.maps.Point(14, 10),
            icon: tinyIcon,
            title: pointTitle,
            draggable: false,
            clickable: true
        };
        var newMarker = new google.maps.Marker(pointMarkerOptions);

        google.maps.event.addListener(newMarker, "click",
        function() {
            that.showTrailhead(pointId);
        });
        return newMarker;
    },

    loadTrailheadsInline: function(inlineData) {
        this.currentTrailheads = [];
        var newHtml = "";
        for (var i = 0; i < inlineData.length; i++) {
            var trailhead = inlineData[i];
            var pointId = trailhead.pointId;
            var newMarker = this.createTrailheadMarker(pointId, trailhead.pointTitle, trailhead.latlng);
            newHtml = newHtml + '<li class="trail-type-trailhead">' +
    					'<a href="/trailheads/' + pointId + '"><h2 id="h2_'+ pointId + '" class="details-link" rel="'+ pointId +'">'+ trailhead.pointTitle + '</h2></a>' +
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

    loadCampgroundsInline: function(inlineData) {
        this.currentCampgrounds = [];
        var newHtml = "";
        for (var i = 0; i < inlineData.length; i++) {
            var campground = inlineData[i];
            var pointId = campground.pointId;
            var newMarker = this.createCampgroundMarker(pointId, campground.pointTitle, campground.latlng);
            newHtml = newHtml + '<li class="trail-type-campground">' +
                        '<a href="/campgrounds/' + pointId + '"><h2 id="h2_'+ pointId + '" class="details-link" rel="'+ pointId +'">'+ campground.pointTitle + '</h2></a>' +
                        '<p><a href="/campgrounds/' + pointId + '" >Details</a> | <a href="/plan/campground/' + pointId +
                        '">Plan</a></p></li>';
            this.currentCampgrounds[pointId] = newMarker;
        }
        $("#trail-list > ul").append(newHtml);

        this.campgroundMarkerManager.clearMarkers();
        if (this.showTrailheads) {
            var campgroundsArray = [];
            $(this.currentCampgrounds).each(function(index, value) {
                if (value != undefined) {
                    campgroundsArray.push(value);
                }
            });

            this.campgroundMarkerManager.addMarkers(campgroundsArray, 0);
        }
        this.campgroundMarkerManager.refresh();
    },

    createCampgroundMarker: function(pointId, pointTitle, latlng) {
        var that = this;
        var tinyIcon = {};
        tinyIcon.url = "/assets/legacy/map/pin_s_campground.png";
        tinyIcon.scaledSize = new google.maps.Size(34, 36);
        tinyIcon.shadowSize = new google.maps.Size(38, 36);
        tinyIcon.anchor = new google.maps.Point(14, 30);        

        var pointMarkerOptions = {
            map: TNT.find.map,
            position: latlng,
            anchor: google.maps.Point(14, 10),
            icon: tinyIcon,
            title: pointTitle,
            draggable: false,
            clickable: true
        };
        // TNT.find.trailheadMgr.addMarker(new
        // GMarker(latlng,pointMarkerOptions));
        var newMarker = new google.maps.Marker(pointMarkerOptions);
        google.maps.event.addListener(newMarker, "click",
        function() {
            that.showCampground(pointId);
        });
        return newMarker;
    },

    createTripMarker: function(tripId, tripTitle, latlng) {
        var that = this;
        var tinyIcon = {};
        tinyIcon.url = "/assets/legacy/map/pin_s_tripstart.png";
        tinyIcon.scaledSize = new google.maps.Size(34, 36);
        tinyIcon.shadowSize = new google.maps.Size(38, 36);
        tinyIcon.anchor = new google.maps.Point(14, 30);

        var pointMarkerOptions = {
            position: latlng,
            anchor: google.maps.Point(14, 10),
            icon: tinyIcon,
            title: tripTitle,
            draggable: false,
            clickable: true
        };
        var newMarker = new google.maps.Marker(pointMarkerOptions);
        google.maps.event.addListener(newMarker, "click",
        function() {
            that.showTrip(tripId);
        });
        return newMarker;
    },

    highlightTripMarker: function(index) {
        var tinyIcon = {};

        tinyIcon.url = "/assets/legacy/map/pin_s_tripstart_active.png";
        tinyIcon.scaledSize = new google.maps.Size(34, 36);
        tinyIcon.shadowSize = new google.maps.Size(38, 36);
        tinyIcon.anchor = new google.maps.Point(14, 30);        

        this.currentTrips[index].setIcon(tinyIcon);

    },

    unhighlightTripMarker: function(index) {
        var tinyIcon = {};
        
        tinyIcon.url = "/assets/legacy/map/pin_s_tripstart.png";
        tinyIcon.scaledSize = new google.maps.Size(34, 36);
        tinyIcon.shadowSize = new google.maps.Size(38, 36);
        tinyIcon.anchor = new google.maps.Point(14, 30);        

        this.currentTrips[index].setIcon(tinyIcon);
    },

    highlightTrailheadMarker: function(id) {
        var tinyIcon = {};

        tinyIcon.url = "/assets/legacy/map/pin_s_trailhead_active.png";
        tinyIcon.scaledSize = new google.maps.Size(34, 36);
        tinyIcon.shadowSize = new google.maps.Size(38, 36);
        tinyIcon.anchor = new google.maps.Point(14, 30);        

        var marker = this.currentTrailheads[id];
        marker.setIcon(tinyIcon);
    },

    unhighlightTrailheadMarker: function(id) {
        var tinyIcon = {};

        tinyIcon.url = "/assets/legacy/map/pin_s_trailhead.png";
        tinyIcon.scaledSize = new google.maps.Size(34, 36);
        tinyIcon.shadowSize = new google.maps.Size(38, 36);
        tinyIcon.anchor = new google.maps.Point(14, 30);        


        this.currentTrailheads[id].setIcon(tinyIcon);
    },

    highlightCampgroundMarker: function(index) {
        var tinyIcon = {};

        tinyIcon.url = "/assets/legacy/map/pin_s_campground_active.png";
        tinyIcon.scaledSize = new google.maps.Size(34, 36);
        tinyIcon.shadowSize = new google.maps.Size(38, 36);
        tinyIcon.anchor = new google.maps.Point(14, 30);        

        var marker = this.currentCampgrounds[index];
        marker.setIcon(tinyIcon);
    },

    unhighlightCampgroundMarker: function(index) {
        var tinyIcon = {};

        tinyIcon.url = "/assets/legacy/map/pin_s_campground.png";
        tinyIcon.scaledSize = new google.maps.Size(34, 36);
        tinyIcon.shadowSize = new google.maps.Size(38, 36);
        tinyIcon.anchor = new google.maps.Point(14, 30);        

        this.currentCampgrounds[index].setIcon(tinyIcon);
    },

    showTrailheadInfoWindow: function(id) {
        var that = this;
        var url = '/trailheads/' + id + '/info_window';

        $.get(url,
        function(data) {
            if(TNT.currentInfowindow){
                TNT.currentInfowindow.close();
            }
            var infowindow = new google.maps.InfoWindow({
                content: data
            });
            TNT.currentInfowindow = infowindow;            
            infowindow.open(TNT.find.map,that.currentTrailheads[id]);            
        });
    },

    showCampgroundInfoWindow: function(id) {
        var that = this;
        var url = '/campgrounds/' + id + '/info_window';
        $.get(url,
        function(data) {
            if(TNT.currentInfowindow){
                TNT.currentInfowindow.close();
            }
            var infowindow = new google.maps.InfoWindow({
                content: data
            });
            TNT.currentInfowindow = infowindow;   
            infowindow.open(TNT.find.map,that.currentCampgrounds[id]);                     
        });
    },

    showTripInfoWindow: function(id) {
        var that = this;
        var url = '/trips/' + id + '/info_window';
        $.get(url,
        function(data) {
            if(TNT.currentInfowindow){
                TNT.currentInfowindow.close();
            }
            var infowindow = new google.maps.InfoWindow({
                content: data
            });
            TNT.currentInfowindow = infowindow;   
            infowindow.open(TNT.find.map,that.currentTrips[id])            
        });
    },

    showTrailhead: function(id) {
        this.showTrailheadInfoWindow(id);
    },

    showCampground: function(id) {
        this.showCampgroundInfoWindow(id);
    },

    showTrip: function(id) {
        this.showTripInfoWindow(id);
    }

};

function initialize_park(id) {
    window.TNT.find.init();    
    
    window.TNT.parklatlngbounds = new google.maps.LatLngBounds();
    
    var count = gpolys.length;
    var parkoverlay = new google.maps.Polygon(
      {
        paths: gpolys, 
        map: TNT.find.map,
        fillColor: "#222", 
        fillOpacity: 0.2,
        strokeWeight: 2,
        strokeColor: "#666"

      }
    );

    $(window.gpolys).each(function(index, item) {    
        for(var point in item){
          TNT.parklatlngbounds.extend(item[point]);
        }
    });
    
    TNT.find.map.fitBounds(TNT.parklatlngbounds);

    google.maps.event.addListenerOnce(TNT.find.map,'idle',function(){
        if (typeof trips !== 'undefined' ) {
            TNT.find.loadTripsInline(trips);
        }
        if (typeof trailheads !== 'undefined') {
            TNT.find.loadTrailheadsInline(trailheads);
        }
        if (typeof campgrounds !== 'undefined') {
            TNT.find.loadCampgroundsInline(campgrounds);
        }
        $('.trail-list-progress').hide();
    });
    // autoFit();

}

$(function() {
    $('.trail-type-trailhead .details-link').live('click',
    function(event) {
        if(!$('.embed').hasClass('phone') && !$('.embed').hasClass('tablet')){
            id = parseInt($(event.target).attr('rel'));
            TNT.find.showTrailhead(id);
            event.preventDefault();
        }
    });

    $('.trail-type-trailhead .details-link').live('mouseenter',
    function(event) {
        id = parseInt($(event.target).attr('rel'));
        TNT.find.highlightTrailheadMarker(id);
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
        TNT.find.highlightTripMarker(id);
        event.preventDefault();
    });

    $('.trail-type-trip .details-link').live('mouseleave',
    function(event) {
        id = parseInt($(event.target).attr('rel'));
        TNT.find.unhighlightTripMarker(id);
        event.preventDefault();
    });

    $('.trail-type-campground .details-link').live('mouseenter',
    function(event) {
        id = parseInt($(event.target).attr('rel'));
        TNT.find.highlightCampgroundMarker(id);
        event.preventDefault();
    });

    $('.trail-type-campground .details-link').live('mouseleave',
    function(event) {
        id = parseInt($(event.target).attr('rel'));
        TNT.find.unhighlightCampgroundMarker(id);
        event.preventDefault();
    });

    $('.trail-type-trip .details-link').live('click',
    function(event) {
        if(!$('.embed').hasClass('phone') && !$('.embed').hasClass('tablet')){
            id = parseInt($(event.target).attr('rel'));
            TNT.find.showTrip(id)
            event.preventDefault();
        }
    });

    $('.trail-type-campground .details-link').live('click',
    function(event) {
        if(!$('.embed').hasClass('phone') && !$('.embed').hasClass('tablet')){
            id = parseInt($(event.target).attr('rel'));
            TNT.find.showCampground(id);
            event.preventDefault();
        }
    });
});

// ]]>
