var TNT = {};

TNT.EditMode = {
    UPDATE: 'update',
    NEW: 'new',
    READONLY: 'readonly'
};

TNT.EntityType = {
    TRAILHEAD: 'trailhead',
    CAMPGROUND: 'campground'
};

TNT.pointmap = {

	currentTrailheads: null,
	trailheadMarkerManager: null,


    init: function(entityType, editMode, start) {
      if (!editMode)
        editMode = TNT.EditMode.READONLY;
      if (!start)
        start = new google.maps.LatLng(37.887771, -122.256452);

      var mapOptions = {
        center: new google.maps.LatLng(start.lat(),start.lng()),
        zoom: 17,
        mapTypeId: google.maps.MapTypeId.ROADMAP,
        mapTypeControl: true,
        zoomControl: true,
        panControl: false
      };

      this.map = new google.maps.Map(document.getElementById("plan-map"),
                mapOptions);

      this.geocoder = new google.maps.Geocoder();

      this.trailheadMarkerManager = new MarkerManager(this.map);


      var icon = null;
      var trailheadIcon = {}

      trailheadIcon.url = "/assets/legacy/map/pin_s_trailhead.png";
      trailheadIcon.anchor = new google.maps.Point(14, 30);

      var campgroundIcon = {};
      campgroundIcon.url = "/assets/legacy/map/pin_s_campground.png";
      campgroundIcon.anchor = new google.maps.Point(14, 30);

      if (entityType == TNT.EntityType.TRAILHEAD) {
          icon = trailheadIcon;
      } else {
          icon = campgroundIcon;
      }

      var trailheadMarkerOptions = {
          position: start,
          icon: icon,
          anchorPoint: google.maps.Point(14, 10),
          draggable: true,
          clickable: false,
          map: this.map
      };

      if (editMode == TNT.EditMode.UPDATE) {
        trailheadMarkerOptions.draggable = true;
      }

      this.markerOptions = trailheadMarkerOptions;

      this.startmarker = new google.maps.Marker(this.markerOptions);

      google.maps.event.addListener(this.startmarker, "dragend", this.moveStart);

      google.maps.event.addListener(this.map, "dblclick", this.saveMap);
      google.maps.event.addListener.bind(this.map, "zoomend", this.saveMap);

      loadKeyFromSession('map.zoom',function(data){
        if( data.value){
          var newZoom = Number(data.value);
          TNT.pointmap.map.setZoom(newZoom);
        }
      });

      if (editMode !== TNT.EditMode.READONLY) {
          google.maps.event.addListener(this.map, 'click', this.moveStart);
          google.maps.event.addListener(this.map, "dragend", this.moveMap);
      }


    },

    saveMap: function() {
        saveKeyValueToSession('map.center', TNT.pointmap.map.getCenter().toUrlValue());
        saveKeyValueToSession('map.zoom', TNT.pointmap.map.getZoom());
    },

    moveStart: function(event) {
      var latlng = event.latLng
      TNT.pointmap.startmarker.setPosition(latlng);
      TNT.pointmap.updateLatLngInputs(latlng);
    },

    moveMap: function(event) {
      var downloadurl = "/trailheads/near_coordinates.json?latitude=" +
        TNT.pointmap.startmarker.getPosition().lat() +
        "&longitude=" +
        TNT.pointmap.startmarker.getPosition().lng() +
        "&distance=100";
        $.getJSON(downloadurl,
        function(data) {
            TNT.pointmap.loadTrailheads(data);
        });
    },

    updateLatLngInputs: function(latlng) {
        $('#trailhead_latitude').val(latlng.lat());
        $('#trailhead_longitude').val(latlng.lng());
    },

    getStartingAddress: function() {
        return $('#id_start_address').val();
    },

    loadTrailhead: function(id, editMode) {
        url = "/trailheads/" + id + ".json";
        var self = this;
        $.getJSON(url,
          function(data) {
            var object = data;
            var startLatLng = new google.maps.LatLng(object.latitude,object.longitude);
            self.map.setCenter(startLatLng, 13);
            self.startmarker.setPosition(startLatLng);
            self.map.panTo(self.startmarker.getPosition());
            self.updateLatLngInputs(startLatLng);
         });
    },

	createTrailheadMarker: function(pointId, pointTitle, latlng) {
        var that = this;
        var tinyIcon = {};
        tinyIcon.url = "/assets/legacy/map/Map-Pins-Small.png";
        tinyIcon.size = new google.maps.Size(27, 28);
        //tinyIcon.shadowSize = new google.maps.Size(38, 36);
        tinyIcon.anchor = new google.maps.Point(14, 30);

        var pointMarkerOptions = {
            position: latlng,
            anchor: new google.maps.Point(14, 10),
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

    loadTrailheads: function(data) {
        var markers = data;
        TNT.pointmap.currentTrailheads = []
        TNT.pointmap.trailheadMarkerManager.clearMarkers();
        $(markers).each(function(index,item) {
            var latlng = new google.maps.LatLng(item.latitude, item.longitude);
            var distance = parseFloat(item.distance);
            var pointTitle = item.name;
            var pointId = item.id;
            var pointIndex = index;
            var newMarker = TNT.pointmap.createTrailheadMarker(pointId, pointTitle, latlng);
            TNT.pointmap.currentTrailheads[pointId] = newMarker;
            //if (this.showTrailheads) {
                TNT.pointmap.trailheadMarkerManager.addMarker(newMarker, 0);
            //}
        });

        TNT.pointmap.trailheadMarkerManager.refresh();
    },

    loadCampground: function(id) {
      var self = this;
      url = "/campgrounds/" + id + ".json";
      $.getJSON(url,
        function(object) {
          var startLatLng = new google.maps.LatLng(object.latitude, object.longitude);
          self.map.setCenter(startLatLng, 13);
          self.startmarker.setPosition(startLatLng);
          self.map.panTo(self.startmarker.getPosition());
          self.updateLatLngInputs(startLatLng);
        });
    },


    decodeAddress: function(address) {
      TNT.pointmap.geocoder.geocode( { 'address': address}, function(results, status) {
        if (status == google.maps.GeocoderStatus.OK) {
          var point = results[0].geometry.location;
          if (point) {
            TNT.pointmap.startmarker.setPosition(point);
            TNT.pointmap.updateLatLngInputs(point);
          }
        }
      });
    },

    chooseStart: function() {
      var endLatLng = null;
      // If there is a start location saved in the session then use it
      loadLocationFromSession(
        function(data) {
          if (data.value) {
              TNT.pointmap.decodeAddress(data.value);
          } else {
            var start = new google.maps.LatLng(37.887771, -122.256452);
            TNT.pointmap.startmarker.setPosition(start);
            TNT.pointmap.updateLatLngInputs(start);
          }
      });

      var start = new google.maps.LatLng(37.887771, -122.256452);
      TNT.pointmap.startmarker.setPosition(start);
      TNT.pointmap.map.panTo(start);
      TNT.pointmap.updateLatLngInputs(start);
    }

};

function initTrailheadDetails(id, editMode) {
  TNT.pointmap.init(TNT.EntityType.TRAILHEAD, editMode);
  TNT.pointmap.loadTrailhead(id, editMode);
  if (editMode != TNT.EditMode.UPDATE)
  {
      TNT.pointmap.startmarker.setDraggable(false);
  }
}

function initCampgroundDetails(id, editMode) {
  TNT.pointmap.init(TNT.EntityType.CAMPGROUND, editMode);
  TNT.pointmap.loadCampground(id);
  if (editMode != TNT.EditMode.UPDATE)
  {
      TNT.pointmap.startmarker.setDraggable(false);
  }
}

// Initialize google maps and the rounded corners
function initEditing(entityType, editMode) {
  TNT.pointmap.init(entityType, editMode);
  TNT.pointmap.startmarker.setDraggable(true);

  if (editMode == TNT.EditMode.UPDATE) {
      TNT.pointmap.startmarker.setPosition(new google.maps.LatLng(
        parseFloat($('#trailhead_latitude').val()),
        parseFloat($('#trailhead_longitude').val())));
      TNT.pointmap.map.panTo(TNT.pointmap.startmarker.getPosition());
  } else {
      centerUrl = '/session/loadkv?key=map.center';

      $.getJSON(centerUrl,
      function(data) {
          if (data.value) {
              latlngarray = data.value.split(",");
              lat = parseFloat(latlngarray[0]);
              lng = parseFloat(latlngarray[1]);
              var newCenter = new google.maps.LatLng(lat, lng);
              TNT.pointmap.startmarker.setPosition(newCenter);
              TNT.pointmap.map.setCenter(TNT.pointmap.startmarker.getPosition());
              TNT.pointmap.updateLatLngInputs(newCenter);
          }
          else {
              TNT.pointmap.chooseStart();
          }
      });

      zoomUrl = '/session/loadkv?key=map.zoom';
      $.getJSON(zoomUrl,
      function(data) {
          if (data.value) {
              newZoom = parseInt(data.value);
              //alert(newZoom);
              TNT.pointmap.map.setZoom(newZoom);
          }
      });

  // begin adding peripheral trailheads for user knowledge
  downloadurl = "/trailheads/near_coordinates.json?latitude=" +
    "37.887771" +
    "&longitude=" +
    "-122.256452" +
    "&distance=100";
  $.getJSON(downloadurl,
    function(data) {
        TNT.pointmap.loadTrailheads(data);
    });
// // end adding peripheral trailheads for user knowledge
  }

}

function findAddress(editMode) {
  var address = TNT.pointmap.getStartingAddress();
  if (!address) return null;
  TNT.pointmap.geocoder.geocode( { 'address': address}, function(results, status) {
    if (status == google.maps.GeocoderStatus.OK) {
      var point = results[0].geometry.location;
      if (point) {
        TNT.pointmap.init(TNT.EntityType.TRAILHEAD, editMode, point);
        var downloadurl = "/trailheads/near_coordinates.json?latitude=" +
          point.lat() +
          "&longitude=" +
          point.lng() +
          "&distance=100";
        $.getJSON(downloadurl,
          function(data) {
            TNT.pointmap.loadTrailheads(data);
          });
      }
    }
  });
}
