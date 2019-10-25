// This script is similar to the google_sheets_google_api_geocoding_script, but
// it only allows for maybe a 100 requests or so a day. Might be handy
// sometimes. I just want to keep this here for posterity.

// Thank this kind soul for the script: https://www.youtube.com/watch?v=zu9qroZkcsk

function GeocodeZipFromAddress(a) {
  var response=Maps.newGeocoder()
    .reverseGeocode(lat(a),long(a));
  return response.results[0].formatted_address.split(',')[2].trim().split(' ')[1];
}

function lat(pointa) {
 var response = Maps.newGeocoder()
     .geocode(pointa);
  return response.results[0].geometry.location.lat
}

function long(pointa) {
  var response = Maps.newGeocoder()
     .geocode(pointa);
  return response.results[0].geometry.location.lng
}
