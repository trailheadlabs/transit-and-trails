/**
 * @author jmoe
 */
// <![CDATA[
var application = null;

function MyApplication(editing){
    this.editingTrip = editing;
    // Initialize the map
    this.add_to_start_mode = 'add_to_start';
    this.viewing_mode = 'viewing';
    this.add_to_end_mode = 'add_to_end'
    this.editing_mode = 'editing'
    
    this.erase = false;
    this.map = new GMap2($('#drawMap')[0]);
        
    this.lastClicked = null;
    
    this.startmarker = null;
    this.endmarker = null;
    this.wayPoints = new Array();
    this.lineArray = new Array();
        
    // Create our start marker icon
    var startIcon = new GIcon();
    startIcon.image = "/media/images/map/trip_start_small.png";
    startIcon.shadow = "/media/images/map/small_shadow.png";
    startIcon.iconSize = new GSize(35, 39);
    startIcon.shadowSize = new GSize(38, 36);
    startIcon.iconAnchor = new GPoint(17, 33);
    
    // Set up our GMarkerOptions object
    var markerOptions = {
        icon: startIcon,
        draggable: editing
    };
    
    var startLatLng = new GLatLng(37.7750, -122.4190);
    this.startmarker = new GMarker(startLatLng, markerOptions);
    
    // Create our start marker icon
    var endIcon = new GIcon();
    endIcon.image = "/media/images/map/trip_stop_small.png";
    endIcon.shadow = "/media/images/map/small_shadow.png";
    endIcon.iconSize = new GSize(35, 39);
    endIcon.shadowSize = new GSize(38, 36);
    endIcon.iconAnchor = new GPoint(17, 33);
    
    // Set up our GMarkerOptions object
    
    var endMarkerOptions = {
        icon: endIcon,
        draggable: editing
    };
    
    
    this.endmarker = new GMarker(new GLatLng(0, 0), endMarkerOptions);
    this.map.setCenter(this.startmarker.getLatLng(), 15);
    this.map.addOverlay(this.startmarker);
    this.map.addOverlay(this.endmarker);
    
    this.trailheadMarkerManager = new MarkerManager(this.map);
    
    GEvent.addListener(this.map, "click", function(overlay, latlng){
        if (latlng) {
            application.addWayPoint(latlng);
        }
    });
    
    this.tripLine = new GPolyline();
    this.map.addOverlay(this.tripLine);
    
    GEvent.bind(this.map, "moveend", this, this.onMoveEnd)
}

function saveMap(){
    saveKeyValueToSession('map.center', application.map.getCenter().toUrlValue());
    saveKeyValueToSession('map.zoom', application.map.getZoom());
}

MyApplication.prototype.setEditingTrip = function(editing){
    this.editingTrip = editing;
}

MyApplication.prototype.loadTripRoute = function(route){
    var points = new Array();
    points.push(new GLatLng(route[0][0], route[0][1]));
    this.tripLine = new GPolyline(points);
    this.map.addOverlay(application.tripLine);
    for (i = 1; i < route.length; i++) {
        this.tripLine.insertVertex(i, new GLatLng(route[i][0], route[i][1]));
    }
    
    if ($('id_starting_point').value != '') {
        loadStartingTrailhead($('#id_starting_point').val());
    }
    
    if ($('id_ending_point').value != '') {
        loadEndingTrailhead($('#id_ending_point').val());
    }
    
//    updateDistanceDiv();
    centerOnTrip();
}

MyApplication.prototype.loadTripStartData = function(data){
    var object = data.evalJSON();
    var latlng = new GLatLng(parseFloat(object.latitude), parseFloat(object.longitude));
    var title = object.name;
    this.startmarker.setLatLng(latlng);
    if (this.tripLine == null) {
        var points = new Array();
        points.push(latlng);
        this.tripLine = new GPolyline(points);
        this.map.addOverlay(this.tripLine);
        this.startmarker.hide();
    }
    else {
        this.tripLine.insertVertex(0, this.startmarker.getLatLng());
    }
    //updateDistanceDiv();
}

MyApplication.prototype.loadTripStart = function(id){
    var url = "/json/Trailhead/" + id;
	app = this;
    GDownloadUrl(url, function(data){app.loadTripStartData(data)});
}

MyApplication.prototype.loadTripEnd = function(id){
    url = "/json/Trailhead/" + id;
    GDownloadUrl(url, function(data){
        var object = data.evalJSON();
        var latlng = new GLatLng(parseFloat(object.latitude), parseFloat(object.longitude));
        var title = object.name;
        if (this.endmarker != null) {
            this.endmarker.setLatLng(latlng);
        }
//        updateDistanceDiv();
    });
    
}

MyApplication.prototype.onMoveEnd = function(){
    saveKeyValueToSession("map.center", this.map.getCenter().toUrlValue());
    saveKeyValueToSession("map.zoom", this.map.getZoom());
}


function createMarker(id, latlng, pointTitle){
    var tinyIcon = new GIcon();
    tinyIcon.image = "/media/images/trailhead_map_icon.png";
    tinyIcon.iconSize = new GSize(27, 28);
    tinyIcon.shadowSize = new GSize(0, 0);
    tinyIcon.iconAnchor = new GPoint(10, 27);
    tinyIcon.infoWindowAnchor = new GPoint(10, 5);
    var pointMarkerOptions = {
        icon: tinyIcon,
        title: pointTitle,
        draggable: false,
        clickable: true
    };
    
    var newMarker = new GMarker(latlng, pointMarkerOptions);
    newMarker.value = "" + id;
    GEvent.addListener(newMarker, "click", function(){
        var url = "/trips/editor/getinfowindow/?id=" + id;
        GDownloadUrl(url, function(data){
            var myHtml = data;
            application.lastClicked = newMarker;
            application.map.openInfoWindowHtml(newMarker.getLatLng(), myHtml);
        });
    });
    return newMarker;
}

function createWayPointMarker(latlng){
    var tinyIcon = new GIcon();
    tinyIcon.image = "http://labs.google.com/ridefinder/images/mm_20_yellow.png";
    tinyIcon.shadow = "http://labs.google.com/ridefinder/images/mm_20_shadow.png";
    tinyIcon.iconSize = new GSize(12, 20);
    tinyIcon.shadowSize = new GSize(22, 20);
    tinyIcon.iconAnchor = new GPoint(6, 20);
    tinyIcon.infoWindowAnchor = new GPoint(5, 1);
    pointMarkerOptions = {
        icon: tinyIcon,
        draggable: false,
        clickable: true
    };
    application.wayPoints.push(latlng);
    var newMarker = new GMarker(latlng, pointMarkerOptions);
    GEvent.addListener(newMarker, "click", function(){
    });
    return newMarker;
}

// Initialize google maps and the rounded corners
function initialize(editing){
    if (GBrowserIsCompatible()) {
        application = new MyApplication(editing);
        
    }
}

function makeTripStart(id){
    application.startmarker.setLatLng(application.lastClicked.getLatLng());
    application.startmarker.hide();
    if (application.tripLine == null) {
        points = new Array();
        points.push(application.lastClicked.getLatLng());
        application.tripLine = new GPolyline(points);
        application.map.addOverlay(application.tripLine);
        //application.tripLine.enableDrawing();
        application.tripLine.enableEditing();
    }
    else {
        application.tripLine.insertVertex(0, application.lastClicked.getLatLng());
        application.tripLine.deleteVertex(1);
        application.tripLine.redraw();
    }
    application.map.closeInfoWindow();
    // application.showTripLine();
    selectStartOption(id);
}

function makeTripEnd(id){
    if (application.endmarker != null) {
        if (application.tripLine != null) {
            count = application.tripLine.getVertexCount();
            application.tripLine.deleteVertex(count - 1);
            application.tripLine.insertVertex(count - 1, application.lastClicked.getLatLng());
        }
    }
    else {
        if (application.tripLine != null) {
            count = application.tripLine.getVertexCount();
            application.tripLine.insertVertex(count, application.lastClicked.getLatLng());
        }
    }
    application.endmarker.setLatLng(application.lastClicked.getLatLng());
    application.endmarker.hide();
    application.map.closeInfoWindow();
    // application.showTripLine();
    selectEndOption(id);
}

MyApplication.prototype.addWayPoint = function(latlng){
    // createWayPointMarker(latlng);
    if (this.tripLine == null) {
        this.tripLine = new GPolyline();
        this.map.addOverlay(this.tripLine);
    }
    if (this.mode == this.editingTrip) {
        if (this.tripLine != null) {
            count = this.tripLine.getVertexCount();
            this.tripLine.insertVertex(count, latlng);
            updateDistanceDiv();
        }
    }
    else 
        if (this.mode == this.add_to_start_mode) {
            if (this.tripLine != null) {
            
                this.tripLine.insertVertex(0, latlng);
                this.map.removeOverlay(this.startmarker);
                this.startmarker.setLatLng(latlng);
                this.map.addOverlay(this.startmarker);
                
                updateDistanceDiv();
            }
            else {
                alert('tripLine is null');
            }
        }
        else 
            if (this.mode == this.add_to_end_mode) {
                if (this.tripLine != null) {
                    count = this.tripLine.getVertexCount();
                    this.tripLine.insertVertex(count, latlng);
                    this.endmarker.setLatLng(latlng);
                    updateDistanceDiv();
                }
                else {
                    alert('tripLine is null');
                }
            }
}

MyApplication.prototype.clearWayPoints = function(){
    var clearConfirm = confirm("Are you sure you want to clear this trip route?");
    if (clearConfirm == true) {
        this.map.removeOverlay(this.tripLine);
        points = new Array();
        points.push(this.startmarker.getLatLng());
        points.push(this.endmarker.getLatLng());
        this.tripLine = new GPolyline(points)
    }
    
}

MyApplication.prototype.eraseFromEnd = function(){
    this.tripLine.deleteVertex(this.tripLine.getVertexCount() - 1);
    this.endmarker.setLatLng(this.tripLine.getVertex(this.tripLine.getVertexCount() -
    1));
}

MyApplication.prototype.eraseFromStart = function(){
    this.tripLine.deleteVertex(0);
    this.startmarker.setLatLng(this.tripLine.getVertex(0));
}

MyApplication.prototype.getWayPointHtml = function(){
    pointArray = new Array();
    for (i = 0; i < this.tripLine.getVertexCount(); i++) {
        subArray = new Array();
        subArray.push(parseFloat(this.tripLine.getVertex(i).lat()));
        subArray.push(parseFloat(this.tripLine.getVertex(i).lng()));
        pointArray.push(subArray);
    }
    xml = pointArray.toJSON();
    $('#id_route').val(xml);
}

function centerOnTrip(){
    var bounds = application.tripLine.getBounds();
    var centerpoint = bounds.getCenter();
    var zoom = application.map.getBoundsZoomLevel(bounds)-1;
    application.map.setCenter(centerpoint, zoom);
}

MyApplication.prototype.loadJSONRoute = function(){
    var route = $.parseJSON($('#id_route').val());
    var points = new Array();
    points.push(new GLatLng(route[0][0], route[0][1]));
    for (i = 1; i < route.length; i++) {
        points.push(new GLatLng(route[i][0], route[i][1]));
    }
    this.tripLine = new GPolyline(points);
    this.map.addOverlay(this.tripLine);
    
    this.startmarker.setLatLng(this.tripLine.getVertex(0));
    this.endmarker.setLatLng(this.tripLine.getVertex(this.tripLine.getVertexCount() - 1));
    
    if ($('#id_starting_point').val() != '') {
        this.loadStartingTrailhead($('#id_starting_point').val());
    }
    
    if ($('#id_ending_point').val() != '') {
        loadEndingTrailhead($('id_ending_point').val());
    }
    centerOnTrip();
    updateDistanceDiv();
    
}

function updateDistanceDiv(){
    distance = application.tripLine.getLength() * 0.000621371192;
    text = distance.toFixed(1) + " Miles";
    $('#distance').html(text);
}

MyApplication.prototype.loadStartingTrailhead = function(id){
    this.loadTripStart(id);
}

MyApplication.prototype.setAddToStartMode = function(){
    this.mode = this.add_to_start_mode;
}

MyApplication.prototype.setAddToEndMode = function(){
    this.mode = this.add_to_end_mode;
}

function editRoute(){
    application.editing = true;
    document.body.style.cursor = "wait";
    application.tripLine.enableEditing();
    //	application.tripLine.enableDrawing();
    document.body.style.cursor = "default";
}

function eraseMode(){
    application.editing = true;
    application.erase = true;
}

function loadEndingTrailhead(id){
    application.loadTripEnd(id);
}

function selectStartOption(id){
    for (i = 0; i < $('#id_starting_point').options.length; i++) {
        if ($('#id_starting_point').options[i].val() == id) {
            $('#id_starting_point').options[i].selected = true;
        }
    }
    application.loadStartingTrailhead(id);
}

function selectEndOption(id){
    for (i = 0; i < $('#id_ending_point').options.length; i++) {
        if ($('#id_ending_point').options[i].value == id) {
            $('#id_ending_point').options[i].selected = true;
        }
    }
    
}

// ]]>
