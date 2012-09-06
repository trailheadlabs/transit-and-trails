/**
 * @author jmoe
 */

var TNT = {};

TNT.parkmap = {
    map : null,
	 
	init : function() {
		var scaleControlPosition = new GControlPosition(G_ANCHOR_BOTTOM_LEFT, new GSize(10, 40));
		var copyOSM = new GCopyrightCollection("<a href=\"http://www.openstreetmap.org/\">OpenStreetMap</a>");
		var tilesMapnik = new GTileLayer(copyOSM, 1, 17, {
			tileUrlTemplate: 'http://tile.openstreetmap.org/{Z}/{X}/{Y}.png'
		});
		var mapMapnik = new GMapType([tilesMapnik], G_NORMAL_MAP.getProjection(), "OSM");
		
		this.map = new GMap2($('drawMap'))
		//    this.map.addControl(new GLargeMapControl());
		this.map.addControl(new GLargeMapControl3D());
		this.map.addControl(new GMapTypeControl());
		
	
		this.map.addControl(new GScaleControl(), scaleControlPosition);
		
		this.map.enableContinuousZoom();
		this.map.enableGoogleBar();
		copyOSM.addCopyright(new GCopyright(1, new GLatLngBounds(new GLatLng(-90, -180), new GLatLng(90, 180)), 0, " "));
		var tilesMapnik = new GTileLayer(copyOSM, 1, 17, {
			tileUrlTemplate: 'http://tile.openstreetmap.org/{Z}/{X}/{Y}.png'
		});
		var mapMapnik = new GMapType([tilesMapnik], G_NORMAL_MAP.getProjection(), "OSM");
		map.addMapType(mapMapnik);
		
		map.addMapType(G_PHYSICAL_MAP);
		map.addMapType(G_SATELLITE_3D_MAP);
		map.setMapType(G_NORMAL_MAP);
		//map.disableDoubleClickZoom();
		
		var latlngbounds = new GLatLngBounds();
		var count = gpolys.length;
		if (Prototype.Browser.IE) {
			count = count - 1;
		}
		
		for (i = 0; i < count; i++) {
			var parkoverlay = new GPolygon(gpolys[i], "#ff0000", 1, 0, "#red", 0.3);
			var bounds = parkoverlay.getBounds();
			map.addOverlay(parkoverlay);
			latlngbounds.extend(bounds.getCenter());
			latlngbounds.extend(bounds.getSouthWest());
			latlngbounds.extend(bounds.getNorthEast());
		}
		map.setCenter(latlngbounds.getCenter(), map.getBoundsZoomLevel(latlngbounds));
	}
};

// Initialize google maps and the rounded corners
function initialize(){
    if (GBrowserIsCompatible()) {
        TNT.parkmap.init();
    }
};
