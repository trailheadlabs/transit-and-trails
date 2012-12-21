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

Find.toggleMapSize = function(){
  $("#find_map").toggleClass('bigger',1000);
  $(".map").toggleClass('bigger',1000);
  $("#findlist").toggleClass('bigger',1000);
  $("#map_size_toggle").text().trim() == 'Bigger' ? $("#map_size_toggle").text("Smaller") : $("#map_size_toggle").text('Bigger')
  google.maps.event.trigger(Find.map, "resize");
};

Find.codeAddress = function(address) {
  Find.geocoder.geocode( { 'address': address}, function(results, status) {
    if (status == google.maps.GeocoderStatus.OK) {
      Find.currentNear = results[0].formatted_address;
      $("#find-location").val(Find.currentNear);
      Find.map.setCenter(results[0].geometry.location);
      Find.map.fitBounds(results[0].geometry.viewport);
    } else {
      $("#find-location").val(Find.currentNear);
      alert("Could not find location.");
    }
  });
}

 Find.codeLatLng = function(latlng) {
    geocoder.geocode({'latLng': latlng}, function(results, status) {
      if (status == google.maps.GeocoderStatus.OK) {
        if (results[1]) {
          map.setZoom(11);
          marker = new google.maps.Marker({
              position: latlng,
              map: map
          });
          infowindow.setContent($('<div class="infowindow">').append(results[1].formatted_address));
          infowindow.open(map, marker);
        }
      } else {
        alert("Geocoder failed due to: " + status);
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
      origin: new google.maps.Point(250,80),
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

  google.maps.event.addListener(newMarker, 'click', function() {
      $("body").animate({scrollTop: $("#trip_list_item_" + trip.id).offset().top-300}, 600);
  });

  $("#trip_list_item_" + trip.id + " .zoom-button").click( function() {
    Find.map.panTo(newMarker.position);
    Find.map.setZoom(18);
    return false;
  });

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

  google.maps.event.addListener(newMarker, 'click', function() {
      $("body").animate({scrollTop: $("#trailhead_list_item_" + trailhead.id).offset().top-300}, 600);
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

  $("#trailhead_list_item_" + trailhead.id + " .zoom-button").click(function() {
    Find.map.panTo(newMarker.position);
    Find.map.setZoom(18);
    return false;
  });
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
      origin: new google.maps.Point(250,160),
      url: "/assets/find_sprite.png",
      size: new google.maps.Size(30, 45)
    }
  });

  google.maps.event.addListener(newMarker, 'click', function() {
      $("body").animate({scrollTop: $("#campground_list_item_" + campground.id).offset().top-300}, 600);
  });

  Find.mapMarkers.push(newMarker);

  $("#campground_list_item_" + campground.id + " .zoom-button").click(function() {
    Find.map.panTo(newMarker.position);
    Find.map.setZoom(18);
    return false;
  });

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

Find.mapIdle = function(){
  if(Find.forceShowItems || $('#redo_search_in_map').is(':checked')){
    Find.showItems();
    Find.forceShowItems = false;
  }
  if(!Find.firstLoadDone){
    Find.showItems();
    Find.firstLoadDone = true;
  }
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

Find.submitFilters = function(){
  var newNear = $("#find-location").val();
  if( newNear != "" && newNear != Find.currentNear){
    Find.codeAddress($("#find-location").val());
    Find.forceShowItems = true;
  } else {
    Find.showItems();
  }
  return false;
}

Find.loadItems = function(find_path){
  $("#findlist").fadeOut();
  $('#progress').slideDown();
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
  $('button').attr('disabled','disabled');
  $('input').attr('disabled','disabled');
  $("#find-map-disable").fadeIn();
  $("#findlist").load(find_path,params, function(){
    $('.filter-checkbox').removeAttr('disabled');
    $('button').removeAttr('disabled');
    $('input').removeAttr('disabled');
    $("#find-map-disable").fadeOut();
    $('#progress').slideUp();
    $("#findlist").fadeIn();
    $("#active-filters").html($(".list-filters").html());
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
  $("#filters-form").submit(function(event){
    event.preventDefault();
    Find.submitFilters();
    return false;
  });
  $('#scrolltop').click(function(){
    $("html, body").animate({ scrollTop: 0 },300);
    return false;
  });

  $('#map_size_toggle').click(function(){
    Find.toggleMapSize();
  });

  // $('.nav-what').button();
  // $('#trip-filter-button').button('toggle');
  // $('.nav-mode').button();
  // $('#map-mode-button').button('toggle');

  var mapOptions = {
    center: new google.maps.LatLng(37.78, -122.42),
    zoom: 11,
    mapTypeId: google.maps.MapTypeId.TERRAIN,
    mapTypeControl: true,
    mapTypeControlOptions: {
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
  Find.map = new google.maps.Map(document.getElementById("find_map"),
            mapOptions);

  Find.overlay = new google.maps.OverlayView();
  Find.overlay.draw = function() {};
  Find.overlay.setMap(Find.map);

  Find.geocoder = new google.maps.Geocoder();

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
      Find.map.setZoom(20);
    }
  });

  google.maps.event.addListener(Find.map, 'idle', Find.mapIdle);
  $(".filter-checkbox").change(Find.showItems);
  $('.map, .mapfilters').fadeIn(600)
});