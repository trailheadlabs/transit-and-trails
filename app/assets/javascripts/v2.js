// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require bootstrap

var Find = {};
Find.mapMarkers = [];

$.fn.serializeObject = function()
{
    var o = {};
    var a = this.serializeArray();
    $.each(a, function() {
        if (o[this.name] !== undefined) {
            if (!o[this.name].push) {
                o[this.name] = [o[this.name]];
            }
            o[this.name].push(this.value || '');
        } else {
            o[this.name] = this.value || '';
        }
    });
    return o;
};

Find.clearFindMapMarkers = function(){
  for(i in Find.mapMarkers){
    Find.mapMarkers[i].setMap(null);
  }
}
Find.codeAddress = function() {
  var address = document.getElementById("address").value;
  geocoder.geocode( { 'address': address}, function(results, status) {
    if (status == google.maps.GeocoderStatus.OK) {
      map.setCenter(results[0].geometry.location);
      var marker = new google.maps.Marker({
          map: map,
          position: results[0].geometry.location
      });
    } else {
      alert("Geocode was not successful for the following reason: " + status);
    }
  });
}

Find.addTripMarker = function(trip){
  var myLatlng = new google.maps.LatLng(trip.latitude,trip.longitude);

  var newMarker = new google.maps.Marker({
    position: myLatlng,
    map: Find.map,
    animation: google.maps.Animation.DROP,
    title:trip.name,
    icon: {
      anchor: new google.maps.Point(15, 45),
      origin: new google.maps.Point(250,0),
      url: "/assets/find_sprite.png",
      size: new google.maps.Size(30, 45)
    }

  });
  Find.mapMarkers.push(newMarker);
  $("#trip_list_item_" + trip.id).hover(
    function(newMarker){
      return function(){
        newMarker.setAnimation(google.maps.Animation.BOUNCE);
      }
    }(newMarker),
    function(newMarker){
      return function(){
        newMarker.setAnimation(null);
      }
    }(newMarker));
}

Find.addTrailheadMarker = function(trailhead){
  var myLatlng = new google.maps.LatLng(trailhead.latitude,trailhead.longitude);

  var newMarker = new google.maps.Marker({
    position: myLatlng,
    map: Find.map,
    animation: google.maps.Animation.DROP,
    title:trailhead.name,
    icon: {
      anchor: new google.maps.Point(15, 45),
      origin: new google.maps.Point(250,0),
      url: "/assets/find_sprite.png",
      size: new google.maps.Size(30, 45)
    }
  });
  Find.mapMarkers.push(newMarker);
  $("#trailhead_list_item_" + trailhead.id).hover(
    function(newMarker){
      return function(){
        newMarker.setAnimation(google.maps.Animation.BOUNCE);
      }
    }(newMarker),
    function(newMarker){
      return function(){
        newMarker.setAnimation(null);
      }
    }(newMarker));
}

Find.addCampgroundMarker = function(campground){
  var myLatlng = new google.maps.LatLng(campground.latitude,campground.longitude);

  var newMarker = new google.maps.Marker({
    position: myLatlng,
    map: Find.map,
    animation: google.maps.Animation.DROP,
    title:campground.name,
    icon: {
      anchor: new google.maps.Point(15, 45),
      origin: new google.maps.Point(250,0),
      url: "/assets/find_sprite.png",
      size: new google.maps.Size(30, 45)
    }
  });
  Find.mapMarkers.push(newMarker);
  $("#campground_list_item_" + campground.id).hover(
    function(newMarker){
      return function(){
        newMarker.setAnimation(google.maps.Animation.BOUNCE);
      }
    }(newMarker),
    function(newMarker){
      return function(){
        newMarker.setAnimation(null);
      }
    }(newMarker));
}

Find.showItems = function(){
  if(find_mode == "TRAILHEADS"){
    Find.showTrailheads();
  } else if(find_mode == "TRIPS") {
    Find.showTrips();
  } else if(find_mode == "CAMPGROUNDS") {
    Find.showCampgrounds();
  }
}

Find.loadItems = function(find_path){
  $("#findlist").fadeOut();
  Find.clearFindMapMarkers();
  var bounds = Find.map.getBounds();
  var center = Find.map.getCenter();
  var params = $('#filters-form').serializeObject();
  params['sw_latitude'] = bounds.getSouthWest().lat();
  params['sw_longitude'] = bounds.getSouthWest().lng();
  params['ne_latitude'] = bounds.getNorthEast().lat();
  params['ne_longitude'] = bounds.getNorthEast().lng();
  params['center_latitude'] = center.lat();
  params['center_longitude'] = center.lng();
  $('.filter-checkbox').attr('disabled','disabled');
  $("#findlist").load(find_path,params, function(){
    $('.filter-checkbox').removeAttr('disabled');
    $("#findlist").fadeIn();
  });
}

Find.showTrips = function(){
  Find.loadItems('/find/trips_within_bounds');
}

Find.showTrailheads = function(){
  Find.loadItems('/find/trailheads_within_bounds');
}

Find.showCampgrounds = function(){
  Find.loadItems('/find/campgrounds_within_bounds');
}

$(function(){
  $("#filters-form").submit(function(){
    Find.showItems();
    return false;
  });
  $('#scrolltop').click(function(){
    $("html, body").animate({ scrollTop: 0 },300);
    return false;
  });
  $('.filters').slideDown(1000)
  $('.nav-what').button();
  $('#trip-filter-button').button('toggle');
  $('.nav-mode').button();
  $('#map-mode-button').button('toggle');
  var mapOptions = {
    center: new google.maps.LatLng(37.78, -122.42),
    zoom: 11,
    mapTypeId: google.maps.MapTypeId.TERRAIN,
    zoomControl: true
  };
  Find.map = new google.maps.Map(document.getElementById("find_map"),
            mapOptions);
  var autocomplete = new google.maps.places.Autocomplete($('#find-location')[0]);
  autocomplete.bindTo('bounds', Find.map);

  google.maps.event.addListener(autocomplete, 'place_changed', function() {
    var place = autocomplete.getPlace();
    if (!place.geometry) {
      // Inform the user that a place was not found and return.
      return;
    }

    // If the place has a geometry, then present it on a map.
    if (place.geometry.viewport) {
      // Use the viewport if it is provided.
      Find.map.fitBounds(place.geometry.viewport);
    } else {
      // Otherwise use the location and set a chosen zoom level.
      Find.map.setCenter(place.geometry.location);
      Find.map.setZoom(17);
    }
    var image = new google.maps.MarkerImage(
        place.icon, new google.maps.Size(71, 71),
        new google.maps.Point(0, 0), new google.maps.Point(17, 34),
        new google.maps.Size(35, 35));
    marker.setIcon(image);
    marker.setPosition(place.geometry.location);

    infowindow.setContent(place.name);
    infowindow.open(Find.map, marker);
  });

  google.maps.event.addListener(Find.map, 'idle', Find.showItems)
  $(".filter-checkbox").change(Find.showItems)
});