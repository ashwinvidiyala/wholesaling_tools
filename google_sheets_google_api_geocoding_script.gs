// There is also a google_sheets_limited_geocoding script that does pretty much
// what this script does but with only a limit of 100 requests per day.

// I hired someone on Fiverr to write this script for me to geocode addresses in
// Google Sheets. This script takes an input of an address (House Number, Street
// name, City and State) with no zip code, and then spits out three columns: zip
// code, latitude and longitude. So make sure that you have two empty columns to
// the right of the column in which this function is being used.

// This script would first have to be added in the Script Editor by going to
// Tools -> Script Editor and then adding this and save it.

// Before using this, replace "GOOGLE_CLOUD_API_TOKEN" with your Google Cloud API Token

// Usage: GeocodeWithKey(A1) where A1 is a cell reference.

// After this thing spits out a zip code, latitude and longitude, I create three
// addditional columns, copy the values and then do cmd + shift + v to paste
// only the values into these additional columns and then I delete the function calls
// from the old columns. I do this so that the function is not making
// unnecessary calls every time the Google Sheet is refreshed (which it will).

//Author
//Muhammad Saleem
//https://www.fiverr.com/saleem_works

function onOpen() {
  var ui = SpreadsheetApp.getUi()
  ui.createMenu('Geocode')
  .addItem('Geocode', 'GeocodeWithKey')
  .addToUi();
}

function GeocodeWithKey(address) {
  var row = [];

    var apiKey = "GOOGLE_CLOUD_API_TOKEN";
    try
    {
      var url = "https://maps.googleapis.com/maps/api/geocode/json?address=" +address+"&key="+ apiKey;
      var response = UrlFetchApp.fetch(url);
      var data = JSON.parse(response);
      var zip = data.results[0].formatted_address.split(',')[2].trim().split(' ')[1];
      var lat = data.results[0].geometry.location.lat
      var long = data.results[0].geometry.location.lng
      var newRow = [];
      newRow.push([zip,lat,long]);
    }
    catch(e){
      Logger.log(e);
    }
    return newRow;
}
