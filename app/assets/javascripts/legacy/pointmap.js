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
            start = new GLatLng(37.887771, -122.256452);
        var icon = null;
        var trailheadIcon = new GIcon();

		if (editMode != TNT.EditMode.UPDATE ) {
			trailheadIcon.image = "/assets/legacy/map/pin_s_trailhead_active.png";
		} else {
			trailheadIcon.image = "/assets/legacy/map/pin_s_trailhead.png";
		}

        trailheadIcon.iconSize = new GSize(34, 36);
        //trailheadIcon.shadowSize = new GSize(38, 36);
        trailheadIcon.iconAnchor = new GPoint(14, 30);
        trailheadIcon.infoWindowAnchor = new GPoint(14, 10);

        var campgroundIcon = new GIcon();
        campgroundIcon.image = "/assets/legacy/map/pin_s_campground.png";
        campgroundIcon.iconSize = new GSize(34, 36);
        campgroundIcon.shadowSize = new GSize(38, 36);
        campgroundIcon.iconAnchor = new GPoint(14, 30);
        campgroundIcon.infoWindowAnchor = new GPoint(14, 10);

        if (entityType == TNT.EntityType.TRAILHEAD) {
            icon = trailheadIcon;
        } else {
            icon = campgroundIcon;
        }

        if (editMode == TNT.EditMode.UPDATE) {
            trailheadMarkerOptions = {
                icon: icon,
                draggable: true,
                clickable: true
            };
        } else {
            trailheadMarkerOptions = {
                icon: icon,
                draggable: true,
                clickable: false
            }
        };

        this.markerOptions = trailheadMarkerOptions;

        this.startmarker = new GMarker(start, trailheadMarkerOptions);

        this.map = new GMap2($('#plan-map')[0]);
        this.map.setCenter(start, 17);
        //this.map.setCenter(startLatLng, 16);
        this.map.addControl(new GLargeMapControl3D());
        this.map.addControl(new GMapTypeControl());
        var scaleControlPosition = new GControlPosition(G_ANCHOR_BOTTOM_LEFT, new GSize(10, 40));
        this.map.addControl(new GScaleControl(), scaleControlPosition);
        //this.map.enableScrollWheelZoom();
        this.map.enableContinuousZoom();
        //this.map.enableGoogleBar();
        var copyOSM = new GCopyrightCollection("<a href=\"http://www.openstreetmap.org/\">OpenStreetMap</a>");
        copyOSM.addCopyright(new GCopyright(1, new GLatLngBounds(new GLatLng( - 90, -180), new GLatLng(90, 180)), 0, " "));
        var tilesMapnik = new GTileLayer(copyOSM, 1, 17, {
            tileUrlTemplate: 'http://tile.openstreetmap.org/{Z}/{X}/{Y}.png'
        });
        var mapMapnik = new GMapType([tilesMapnik], G_NORMAL_MAP.getProjection(), "OSM");
        this.map.addMapType(mapMapnik);

        this.map.addMapType(G_PHYSICAL_MAP);
        this.map.addMapType(G_SATELLITE_3D_MAP);
        this.map.setMapType(G_NORMAL_MAP);

        GEvent.bind(this.startmarker, "dragend", this, this.moveStart);

        //GEvent.bind(this.map, "dragend", this, this.map.addOverlay(this.startmarker));

        GEvent.bind(this.map, "dblclick", this, this.saveMap);
        GEvent.bind(this.map, "zoomend", this, this.saveMap);
		this.trailheadMarkerManager = new MarkerManager(this.map);
		loadKeyFromSession('map.zoom',function(data){
          if( data.value){
            var newZoom = Number(data.value);
            TNT.pointmap.map.setZoom(newZoom);
          }
        });

        this.activeMarker = this.startmarker;

        if (editMode !== TNT.EditMode.READONLY) {
            GEvent.bind(this.map, 'click', this, this.showMarker);
        }
        if (editMode !== TNT.EditMode.NEW){
            this.map.addOverlay(this.activeMarker);
        }
    },

    saveMap: function() {
        saveKeyValueToSession('map.center', this.map.getCenter().toUrlValue());
        saveKeyValueToSession('map.zoom', this.map.getZoom());
    },

    showMarker: function(overlay, latLng) {
        if (this.activeMarker)
            this.map.removeOverlay(this.activeMarker);
        var loc = new GLatLng(latLng.lat(), latLng.lng());
        var clickmarker = new GMarker(loc, this.markerOptions);
        this.map.addOverlay(clickmarker);
        this.updateLatLngInputs(latLng);
        this.activeMarker = clickmarker;
    },

    moveStart: function(overlay, latlng) {
        if (overlay) {
            this.updateLatLngInputs(this.startmarker.getLatLng());
        }
        if (latlng) {
            this.startmarker.setLatLng(latlng);
            this.updateLatLngInputs(latlng);
        }
		downloadurl = "/trailheads/near_coordinates.json?latitude=" +
        this.startmarker.getLatLng().lat() +
        "&longitude=" +
        this.startmarker.getLatLng().lng() +
        "&distance=100";
        GDownloadUrl(downloadurl,
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
        GDownloadUrl(url,
        function(data) {
            var object = $.parseJSON(data);
            var startLatLng = new GLatLng(parseFloat(object.latitude), parseFloat(object.longitude));
            self.map.setCenter(startLatLng, 13);
            self.startmarker.setLatLng(startLatLng);
            self.map.panTo(self.startmarker.getLatLng());
            self.updateLatLngInputs(startLatLng);
        });
    },

	createTrailheadMarker: function(pointId, pointTitle, latlng) {
        var that = this;
        var tinyIcon = new GIcon();
        tinyIcon.image = "/assets/legacy/map/Map-Pins-Small.png";
        tinyIcon.iconSize = new GSize(27, 28);
        //tinyIcon.shadowSize = new GSize(38, 36);
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

    loadTrailheads: function(data) {
        var markers = $.parseJSON(data);
        this.currentTrailheads = []
        this.trailheadMarkerManager.clearMarkers();
        $(markers).each(function(index,item) {
            var latlng = new GLatLng(parseFloat(item["latitude"]), parseFloat(item['longitude']));
            var distance = parseFloat(item["distance"]);
            var pointTitle = item["name"];
            var pointId = item["id"];
            var pointIndex = index;
            var newMarker = TNT.pointmap.createTrailheadMarker(pointId, pointTitle, latlng);
            TNT.pointmap.currentTrailheads[pointId] = newMarker;
            //if (this.showTrailheads) {
                TNT.pointmap.trailheadMarkerManager.addMarker(newMarker, 0);
            //}
        });

        this.trailheadMarkerManager.refresh();
    },

    loadCampground: function(id) {
        var self = this;
        url = "/campgrounds/" + id + ".json";
        GDownloadUrl(url,
        function(data) {
            var object = $.parseJSON(data);
            var startLatLng = new GLatLng(parseFloat(object.latitude), parseFloat(object.longitude));
            self.map.setCenter(startLatLng, 13);
            self.startmarker.setLatLng(startLatLng);
            self.map.panTo(self.startmarker.getLatLng());
            self.updateLatLngInputs(startLatLng);
        });
    },


    decodeAddress: function(address) {
        var geocoder = new GClientGeocoder();
        if (geocoder) {
            geocoder.getLatLng(address,
            function(point) {
                if (point) {
                    TNT.pointmap.startmarker.setLatLng(point);
                    TNT.pointmap.updateLatLngInputs(point);
                }
            })
        }
    },

    chooseStart: function() {
      var endLatLng = null;
      // If there is a start location saved in the session then use it
      loadLocationFromSession(
        function(data) {
            if (data.value) {
                TNT.pointmap.decodeAddress(data.value);
            }
            else {
                var start = new GLatLng(37.887771, -122.256452);
                if (google.loader.ClientLocation != null) {
                    start = new GLatLng(google.loader.ClientLocation.latitude, google.loader.ClientLocation.longitude);
                }

                TNT.pointmap.startmarker.setLatLng(start);
                TNT.pointmap.updateLatLngInputs(start);
            }
      });

        var start = new GLatLng(37.887771, -122.256452);
        if (google.loader.ClientLocation != null) {
            start = new GLatLng(google.loader.ClientLocation.latitude, google.loader.ClientLocation.longitude);
        }
        this.startmarker.setLatLng(start);
        this.map.panTo(start);
        this.updateLatLngInputs(start);
    }

};

function initTrailheadDetails(id, editMode) {
    if (GBrowserIsCompatible()) {
        TNT.pointmap.init(TNT.EntityType.TRAILHEAD, editMode);
        TNT.pointmap.loadTrailhead(id, editMode);
        if (editMode != TNT.EditMode.UPDATE)
        {
            TNT.pointmap.startmarker.disableDragging();
        }
    }
}

function initCampgroundDetails(id, editMode) {
    if (GBrowserIsCompatible()) {
        TNT.pointmap.init(TNT.EntityType.CAMPGROUND, editMode);
        TNT.pointmap.loadCampground(id);
        if (editMode != TNT.EditMode.UPDATE)
        {
            TNT.pointmap.startmarker.disableDragging();
        }

    }
}

// Initialize google maps and the rounded corners
function initEditing(entityType, editMode) {
    if (GBrowserIsCompatible()) {
        TNT.pointmap.init(entityType, editMode);
        TNT.pointmap.startmarker.enableDragging();

        if (editMode == TNT.EditMode.UPDATE) {
            TNT.pointmap.startmarker.setLatLng(new GLatLng(parseFloat($('#trailhead_latitude').val()), parseFloat($('#trailhead_longitude').val())));
            TNT.pointmap.map.panTo(TNT.pointmap.startmarker.getLatLng());
        }
        else {
            centerUrl = '/session/loadkv?key=map.center';

            GDownloadUrl(centerUrl,
            function(data) {
                if (data.value) {
                    latlngarray = data.value.split(",");
                    lat = parseFloat(latlngarray[0]);
                    lng = parseFloat(latlngarray[1]);
                    var newCenter = new GLatLng(lat, lng);
                    TNT.pointmap.startmarker.setLatLng(newCenter);
                    TNT.pointmap.map.setCenter(TNT.pointmap.startmarker.getLatLng());
                    TNT.pointmap.updateLatLngInputs(newCenter);
                }
                else {
                    TNT.pointmap.chooseStart();
                }
            });

            zoomUrl = '/session/loadkv?key=map.zoom';
            GDownloadUrl(zoomUrl,
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
	        GDownloadUrl(downloadurl,
	        function(data) {
	            TNT.pointmap.loadTrailheads(data);
	        });
			// // end adding peripheral trailheads for user knowledge
        }

    }
}

function findAddress(editMode) {
    var address = TNT.pointmap.getStartingAddress();
    if (!address) return null;
    var geocoder = new GClientGeocoder();
    if (geocoder) {
        geocoder.getLatLng(address,
            function(point) {
                if (point) {
                    TNT.pointmap.init(TNT.EntityType.TRAILHEAD, editMode, point);
                    var downloadurl = "/trailheads/near_coordinates.json?latitude=" +
                        point.lat() +
                        "&longitude=" +
                        point.lng() +
                        "&distance=100";
                    GDownloadUrl(downloadurl,
                        function(data) {
                            TNT.pointmap.loadTrailheads(data);
                        });
                }
            })
    }
}
