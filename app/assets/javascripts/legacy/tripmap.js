/**
 * @author jmoe
 */
// <![CDATA[

TNT = {};

TNT.EditMode = {
    UPDATE: 'update',
    NEW: 'new',
    READONLY: 'readonly'
};

TNT.tripmap = {

    init: function(editMode, searchPosition) {
        if (!editMode)
            editMode = TNT.EditMode.READONLY;
        if (!searchPosition)
            this.startPosition = new google.maps.LatLng(37.7750, -122.4190);
        else
            this.startPosition = searchPosition;

        if(TNT.tripmap.centerOn)
            this.startPosition = TNT.tripmap.centerOn;

        this.trailheadIcon = new google.maps.MarkerImage();
        this.trailheadIcon.url = "/assets/legacy/map/trailhead.png";
        this.trailheadIcon.size = new google.maps.Size(38, 38);
        this.trailheadIcon.anchor = new google.maps.Point(11, 37);

        this.tripStartIcon = new google.maps.MarkerImage();
        this.tripStartIcon.url = "/assets/legacy/map/trip-start.png";
        this.tripStartIcon.size = new google.maps.Size(38, 38);
        this.tripStartIcon.anchor = new google.maps.Point(11, 37);

        this.tripEndIcon = new google.maps.MarkerImage();
        this.tripEndIcon.url = "/assets/legacy/map/trip-end.png";
        this.tripEndIcon.size = new google.maps.Size(38, 38);
        this.tripEndIcon.anchor = new google.maps.Point(11, 37);

        this.lastAddedIndices = [];
        this.editing = editMode !== TNT.EditMode.READONLY;
        this.editMode = editMode;
        this.follow_paths = true;
        // Initialize the map
        this.trailheadMarkers = [];

        this.currentTrailheadsById = {};

        var mapTypeIds = ["terrain", "OSM"]
        for(var type in google.maps.MapTypeId) {
            mapTypeIds.push(google.maps.MapTypeId[type]);
        }

        var mapOptions = {
            zoom: 11,
            center: this.startPosition,
            mapTypeId: google.maps.MapTypeId.ROADMAP,
            mapTypeControlOptions: {
                mapTypeIds: mapTypeIds,
                style: google.maps.MapTypeControlStyle.HORIZONTAL_BAR,
                position: google.maps.ControlPosition.TOP_RIGHT
            },
            scaleControl: true,
            streetViewControl: true,
            overviewMapControl: true
        }
        if(this.editMode != TNT.EditMode.READONLY){
            mapOptions.draggableCursor = 'crosshair';
        }
        // setup the map
        this.map = new google.maps.Map(document.getElementById('plan-map'), mapOptions);

        this.map.mapTypes.set("OSM", new google.maps.ImageMapType({
            getTileUrl: function(coord, zoom) {
                return "http://tile.openstreetmap.org/" + zoom + "/" + coord.x + "/" + coord.y + ".png";
            },
            tileSize: new google.maps.Size(256, 256),
            name: "OpenStreetMap",
            maxZoom: 18
        }));

        this.starting_trailhead_id = null;
        this.ending_trailhead_id = null;

        TNT.tripmap.tripLine = new google.maps.Polyline();
        TNT.tripmap.tripLine.setMap(this.map);

        TNT.tripmap.map.setCenter(this.startPosition);
        TNT.tripmap.map.setZoom(11);

        // center the map based on the previous map view position on 'create' action
        if (editMode === TNT.EditMode.NEW  && !searchPosition && !TNT.tripmap.centerOn) {
            var centerUrl = '/session/loadkv?key=map.location';
            $.get(centerUrl, function (data) {
                if (data.value) {
                    latlngarray = data.value.split(",");
                    lat = parseFloat(latlngarray[0]);
                    lng = parseFloat(latlngarray[1]);
                    zoom = parseInt(latlngarray[2]);
                    var newCenter = new google.maps.LatLng(lat, lng);
                    TNT.tripmap.map.setCenter(newCenter);
                    TNT.tripmap.map.setZoom(zoom);
                }
            });
        }

        if (!searchPosition) {
            TNT.tripmap.loadJSONRoute();
        }

        google.maps.event.addListener(this.map, "dragend", this.onMoveEnd);
        google.maps.event.addListener(this.map, "zoom_changed", this.onMoveEnd);
        google.maps.event.addListener(this.map, "tilesloaded", this.onMoveEnd);
        google.maps.event.addListener(this.map, "click", this.onMapClick)
        google.maps.event.addListener(this.tripLine, "mouseup", this.updateDistanceDiv);

        directionsService = new google.maps.DirectionsService();
    },

    setCenterOn: function(latitude,longitude){
        TNT.tripmap.centerOn = new google.maps.LatLng(Number(latitude),Number(longitude));
    },

    onMapClick: function(event){
        pos = event.latLng;
        if(TNT.tripmap.editMode !== TNT.EditMode.READONLY){
            TNT.tripmap.addPointToTrip(pos);
        }
    },

    toggleFollowPaths: function(){
        TNT.tripmap.follow_paths = !TNT.tripmap.follow_paths;
        if(TNT.tripmap.follow_paths){
            $('#follow-paths-button').text('Unfollow Paths');
        } else {
            $('#follow-paths-button').text('Follow Paths');
        }
    },

    toggleEdit: function(){
        TNT.tripmap.tripLine.setEditable(!TNT.tripmap.tripLine.editable);
    },

    toggleSnap: function(){
        TNT.tripmap.follow_paths = !TNT.tripmap.follow_paths;
        if(TNT.tripmap.follow_paths){
            $('#follow-paths-button').text('Unsnap');
        } else {
            $('#follow-paths-button').text('Snap');
        }
    },

    outAndBack: function(){
        for(var j=TNT.tripmap.tripLine.getPath().getLength() - 1; j >= 0;j--){
            var value = TNT.tripmap.tripLine.getPath().getAt(j);
            if (value)
                TNT.tripmap.tripLine.getPath().push(value);
        };
        TNT.tripmap.ending_trailhead_id = TNT.tripmap.starting_trailhead_id;
        this.makeTripEnd(TNT.tripmap.ending_trailhead_id);
        this.updateDistanceDiv();
    },

    addPointToTrip: function(point){
        if(TNT.tripmap.lastAddedIndices.length < 1){
            TNT.tripmap.lastAddedIndices.push(1);
        }
        if(!this.follow_paths) {
            this.tripLine.getPath().push(point);
            TNT.tripmap.updateDistanceDiv();
            TNT.tripmap.lastAddedIndices.push(TNT.tripmap.tripLine.getPath().getLength()-1);
        } else {
            directionsRequest = {
                origin: this.tripLine.getPath().getAt(this.tripLine.getPath().getLength()-1),
                destination: point,
                travelMode: google.maps.TravelMode.WALKING
            }
            directionsService.route(directionsRequest, function(result, status) {
                if (status == google.maps.DirectionsStatus.OK) {
                    var myRoute = result.routes[0].legs[0];

                    for (var i = 0; i < myRoute.steps.length; i++) {
                        for(j in myRoute.steps[i].path) {
                            TNT.tripmap.tripLine.getPath().push(myRoute.steps[i].path[j]);
                        }
                      }
                    TNT.tripmap.lastAddedIndices.push(TNT.tripmap.tripLine.getPath().getLength());
                    TNT.tripmap.updateDistanceDiv();
                }

            });

        }
    },


    prependPointToTrip: function(point){
        TNT.tripmap.lastAddedIndices.push(TNT.tripmap.tripLine.getPath().getLength());
        if(!this.follow_paths) {
            this.tripLine.getPath().push(point);
        } else {
            directionsRequest = {
                origin: this.tripLine.getPath().getAt(this.tripLine.getPath().getLength()-1),
                destination: point,
                travelMode: google.maps.TravelMode.WALKING
            }
            directionsService.route(directionsRequest, function(result, status) {
                if (status == google.maps.DirectionsStatus.OK) {
                    var myRoute = result.routes[0].legs[0];

                    for (var i = 0; i < myRoute.steps.length; i++) {
                        for(j in myRoute.steps[i].path) {
                            TNT.tripmap.tripLine.getPath().push(myRoute.steps[i].path[j]);
                        }
                      }
                    TNT.tripmap.updateDistanceDiv();
                }
            });

        }
    },

    onMoveEnd : function(){
        if (TNT.tripmap.editMode !== TNT.EditMode.READONLY) {
            if(TNT.tripmap.map.getBounds()){
                TNT.tripmap.showTrailheads();
            }
        }
    },

    showTrailheads : function(){
        var sw = TNT.tripmap.map.getBounds().getSouthWest();
        var ne = TNT.tripmap.map.getBounds().getNorthEast();

        var sw_lat = sw.lat();
        var sw_long = sw.lng();
        var ne_lat = ne.lat();
        var ne_long = ne.lng();

        var url = "/trailheads/within_bounds.json?sw_latitude=" + sw_lat + "&sw_longitude=" + sw_long +
        "&ne_latitude=" +
        ne_lat +
        "&ne_longitude=" +
        ne_long;

        $.get(url, function(data){
            var trailheads = data;
            var currentTrailheads = [];
            for (i in trailheads) {
                var pointId = trailheads[i].id;
                  var pointTitle = trailheads[i].name;
                  var latlng = new google.maps.LatLng(parseFloat(trailheads[i].latitude), parseFloat(trailheads[i].longitude));
                  if(typeof(TNT.tripmap.currentTrailheadsById[pointId]) == 'undefined'){
                    var newMarker = TNT.tripmap.createMarker(pointId, latlng, pointTitle);
                    TNT.tripmap.currentTrailheadsById[pointId] = newMarker;
                    currentTrailheads[pointId] = newMarker;
                    newMarker.setMap(TNT.tripmap.map);
                  }
            }

        },'json').error(function(data){
            alert(data)});
    },

    createMarker : function(id, latlng, pointTitle){
        var trailheadIcon = TNT.tripmap.trailheadIcon;
        if(id == TNT.tripmap.starting_trailhead_id){
            trailheadIcon = TNT.tripmap.tripStartIcon;
        } else if(id == TNT.tripmap.ending_trailhead_id) {
            trailheadIcon = TNT.tripmap.tripEndIcon;
        }
        var pointMarkerOptions = {
            icon: trailheadIcon,
            position:latlng,
            title: pointTitle,
            draggable: false
        };

        var newMarker = new google.maps.Marker(pointMarkerOptions);
        newMarker.value = "" + id;
        google.maps.event.addListener(newMarker, "click", function(){
            var url = "/trailheads/" + id + "/trip_editor_info_window";
            $.get(url, function(data){
                if(TNT.tripmap.currentInfoWindow){
                    TNT.tripmap.currentInfoWindow.close();
                }
                var myHtml = data;
                var infowindow = new google.maps.InfoWindow({content:myHtml});
                infowindow.open(TNT.tripmap.map,newMarker);
                TNT.tripmap.currentInfoWindow = infowindow;
            });
            return false;
        });
        return newMarker;
    },

    makeTripStart : function(id){
        if(TNT.tripmap.starting_trailhead_id && TNT.tripmap.currentTrailheadsById[TNT.tripmap.starting_trailhead_id]){
            TNT.tripmap.currentTrailheadsById[TNT.tripmap.starting_trailhead_id].setIcon(TNT.tripmap.trailheadIcon);
        }
        TNT.tripmap.starting_trailhead_id = id;
        var startLatLng = TNT.tripmap.currentTrailheadsById[id].getPosition();
        $("#starting-trailhead-name").text(TNT.tripmap.currentTrailheadsById[id].title);
        $('#trip_starting_trailhead_id').val(id);
        $('#trip-editor-step-instruction').text("Now draw your trip. Click the ending trailhead when you are done.");
        TNT.tripmap.currentInfoWindow.close();
        TNT.tripmap.currentTrailheadsById[id].setIcon(TNT.tripmap.tripStartIcon);
        if (TNT.tripmap.tripLine == null) {
            points = new Array();
            points.push(startLatLng);
            this.tripLine.setMap(null);
            TNT.tripmap.tripLine = new google.maps.Polyline(points);
            TNT.tripmap.tripLine.setMap(this.map);
        }
        else {
            TNT.tripmap.tripLine.getPath().insertAt(0, startLatLng);
            if(TNT.tripmap.tripLine.getPath().getLength() > 1) {
              TNT.tripmap.tripLine.getPath().removeAt(1);
            }
        }

    },

    makeTripEnd : function(id){
        if(TNT.tripmap.ending_trailhead_id && TNT.tripmap.currentTrailheadsById[TNT.tripmap.ending_trailhead_id]){
            TNT.tripmap.currentTrailheadsById[TNT.tripmap.ending_trailhead_id].setIcon(TNT.tripmap.trailheadIcon);
        }
        if(!TNT.tripmap.starting_trailhead_id) {
          alert("Please choose a starting point first.");
          return false;
        }
        TNT.tripmap.ending_trailhead_id = id;
        $('#trip_ending_trailhead_id').val(id);
        $("#ending-trailhead-name").text(TNT.tripmap.currentTrailheadsById[id].title);
        TNT.tripmap.currentInfoWindow.close();
        var markerLatLng = TNT.tripmap.currentTrailheadsById[id].getPosition();
        TNT.tripmap.currentTrailheadsById[id].setIcon(TNT.tripmap.tripEndIcon);
        this.addPointToTrip(markerLatLng);
    },

    clearWayPoints : function(){
        var clearConfirm = confirm("Are you sure you want to clear this trip route?");
        if (clearConfirm == true) {
            this.tripLine.setMap(null);
            points = new Array();
            this.tripLine = new google.maps.Polyline(points)
            this.tripLine.setMap(this.map);
            if(TNT.tripmap.starting_trailhead_id){
                TNT.tripmap.currentTrailheadsById[TNT.tripmap.starting_trailhead_id].setIcon(TNT.tripmap.trailheadIcon);
                TNT.tripmap.starting_trailhead_id = null;
                $('#starting-trailhead-name').text('Click a trailhead to set as start.');
            }
            if(TNT.tripmap.ending_trailhead_id){
                TNT.tripmap.currentTrailheadsById[TNT.tripmap.ending_trailhead_id].setIcon(TNT.tripmap.trailheadIcon);
                TNT.tripmap.ending_trailhead_id = null;
                $('#ending-trailhead-name').text('Click a trailhead to set as end.');
            }

            TNT.tripmap.updateDistanceDiv();
            // this.tripLine.setEditable(true);
        }

    },

    eraseFromEnd : function(){
        if(TNT.tripmap.lastAddedIndices.length > 1){
            var popCount = TNT.tripmap.lastAddedIndices.pop() - TNT.tripmap.lastAddedIndices[TNT.tripmap.lastAddedIndices.length-1];
            for(var i = 0; i < popCount; i++){
                TNT.tripmap.tripLine.getPath().pop();
            }
        } else {
            //TNT.tripmap.tripLine.getPath().pop();
        }
        if(TNT.tripmap.ending_trailhead_id){
            TNT.tripmap.currentTrailheadsById[TNT.tripmap.ending_trailhead_id].setIcon(TNT.tripmap.trailheadIcon);
            TNT.tripmap.currentTrailheadsById[TNT.tripmap.starting_trailhead_id].setIcon(TNT.tripmap.tripStartIcon);
            TNT.tripmap.ending_trailhead_id = null;
            $('#ending-trailhead-name').text('Click a trailhead to set as end.');
        }
        this.updateDistanceDiv();

    },

    getWayPointHtml : function(){
        var pointArray = new Array();
        for (i in this.tripLine.getPath().getArray()) {
            var subArray = new Array();
            subArray.push(parseFloat(this.tripLine.getPath().getAt(i).lat()));
            subArray.push(parseFloat(this.tripLine.getPath().getAt(i).lng()));
            pointArray.push(subArray);
        }
        var json = JSON.stringify(pointArray)
        $('#id_route').val(json);
        $('#id_description').text($("#id_description").val());
    },

    loadJSONRoute : function(){
        var bounds = new google.maps.LatLngBounds();
        // var route = $.parseJSON($('#id_route').val())['coordinates'];
        var route = trip_route;
        if(route) {
            TNT.tripmap.tripLine.setMap(null);
            for (i in route) {
                var newVertex = new google.maps.LatLng(route[i][0], route[i][1]);
                TNT.tripmap.tripLine.getPath().push(newVertex);
                bounds.extend(newVertex);
            }
            TNT.tripmap.tripLine.setMap(TNT.tripmap.map);
            if ($('#trip_starting_trailhead_id').val() != '') {
                TNT.tripmap.starting_trailhead_id = $('#trip_starting_trailhead_id').val();
                var latlng = new google.maps.LatLng(parseFloat($('#starting_point_latitude').val()),
                    parseFloat($('#starting_point_longitude').val()));
                var pointMarkerOptions = {
                    icon: TNT.tripmap.tripStartIcon,
                    position:latlng,
                    draggable: false
                };

                var newMarker = new google.maps.Marker(pointMarkerOptions);
                newMarker.setMap(TNT.tripmap.map);
            }

            if ($('#trip_ending_trailhead_id').val() != '') {
                TNT.tripmap.ending_trailhead_id = $('#trip_ending_trailhead_id').val();
                var latlng = new google.maps.LatLng(parseFloat($('#ending_point_latitude').val()),
                    parseFloat($('#ending_point_longitude').val()));
                var pointMarkerOptions = {
                    icon: TNT.tripmap.tripEndIcon,
                    position:latlng,
                    draggable: false
                };

                var newMarker = new google.maps.Marker(pointMarkerOptions);
                newMarker.setMap(TNT.tripmap.map);

            }

            if(route.length > 0) {
                TNT.tripmap.map.fitBounds(bounds);
                TNT.tripmap.updateDistanceDiv();
            }

            //TNT.tripmap.showTrailheads();
        }
    },

    updateDistanceDiv : function(){
        var text = "-";
        if(TNT.tripmap.tripLine.getPath().getLength() > 0){
            var distance = google.maps.geometry.spherical.computeLength(TNT.tripmap.tripLine.getPath()) * 0.000621371192;
            text = distance.toFixed(1) + " Miles";
        }
        $('#distance').html(text);
    },

    findAddress: function(editMode) {
        var address = $('#id_start_address').val();
        if (!address) return null;

        var geocoder = new google.maps.Geocoder();
        var request = { address: address };

        geocoder.geocode(request,
                function(results, status) {
                    if (status == google.maps.GeocoderStatus.OK)
                    {
                        if (results) {
                            var result = results[0];
                            TNT.tripmap.map.setCenter(result.geometry.location);
                            TNT.tripmap.showTrailheads();
                        }
                    }
                });
    }

}



// ]]>
