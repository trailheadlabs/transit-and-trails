$(function(){
  $('#more-desc-link').click(function(){
    $('.short-description').hide();
    $('.full-description').show();
  });
  $('#less-desc-link').click(function(){
    $('.full-description').hide();
    $('.short-description').show();
  });

});
function saveLocationToSession(address){
    saveKeyValueToSession('last_location',address);
}

function loadLocationFromSession(callback) {
    loadKeyFromSession('last_location',callback);
}


function saveKeyValueToSession(key, value){
    var url = '/session/savekv?key=' + encodeURIComponent(key) + '&value=' + encodeURIComponent(value);
    $.get(url);
}

function loadKeyFromSession(key,callback)
{
  var url = '/session/loadkv?key=' + encodeURIComponent(key);
  $.get(url,callback);
}

function numbersOnly(el){
    el.value = el.value.replace(/[^0-9]/g, "");
}

function notEmpty(el){
    if (el.value == '') {
        el.value = 20;
    }
}

function numbersOnly(el, maxlength){
    el.value = el.value.replace(/[^0-9]/g, "");
    if (el.value.length > maxlength) {
        el.value = el.value.substring(0, maxlength);
    }
}

function lessThan(el, num){
    if (parseInt(el.value) > num) {
        el.value = num;
    }
}

function zeroPad(num, count){
    var numZeropad = num + '';
    while (numZeropad.length < count) {
        numZeropad = "0" + numZeropad;
    }
    return numZeropad;
}

/**
 * Utility function to calculate the appropriate zoom level for a given bounding
 * box and map image size. Uses the formula described in the Google Mapki
 * (http://mapki.com/).
 *
 * @param bounds
 *            bounding box (GBounds instance)
 * @param mnode
 *            DOM element containing the map.
 * @return zoom level.
 */
function best_zoom(bounds, mnode) {
	var width = mnode.offsetWidth;
	var height = mnode.offsetHeight;

	var dlat = Math.abs(bounds.maxY - bounds.minY);
	var dlon = Math.abs(bounds.maxX - bounds.minX);
	if (dlat == 0 && dlon == 0)
		return 4;

	// Center latitude in radians
	var clat = Math.PI * (bounds.minY + bounds.maxY) / 360.;

	var C = 0.0000107288;
	var z0 = Math.ceil(Math.log(dlat / (C * height)) / Math.LN2);
	var z1 = Math
			.ceil(Math.log(dlon / (C * width * Math.cos(clat))) / Math.LN2);
	alert(z0);
	return (z1 > z0) ? z1 : z0;
}
