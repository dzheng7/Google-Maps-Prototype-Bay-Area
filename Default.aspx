<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Default.aspx.cs" Inherits="Default" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<!DOCTYPE html>
<html>
  <head>
    <title>Simple Map</title>
    <meta name="viewport" content="initial-scale=1.0">
    <meta charset="utf-8">
    <link rel="shortcut icon" href="#" />
    <style>
      /* Always set the map height explicitly to define the size of the div
       * element that contains the map. */
      #map {
        height: 100%;
      } 
      #clear 
      {
            cursor:pointer;
            background-image: "./images/clear.png";
            height:25px;
            width:50px;
            top:11px;
            left:120px;
      }
      /* Optional: Makes the sample page fill the window. */
      html, body {
        height: 100%;
        margin: 0;
        padding: 0;
      }
      .labels {
        color: black;
        background-color: none;
        font-family: "Lucida Grande", "Arial", sans-serif;
        font-size: 10px;
        text-align: center;
        width: 30px;
        white-space: nowrap;
      }
      /*#wrapper 
      {
        position:relative;
      }
      #txt 
      {
        position:absolute;
        top:10px;
        
      }*/
    </style>
  </head>
  <body>
    <input id="txt" class="controls" type="text"/>
    <!--<button id="submit" class="w3-button w3-round">Clear</button>-->
    
    <!--<input type="text" name="search">
    <input type="submit">-->
    
    <div id="map" style="position:relative;z-index:0;"> 
        <!--<div id="clear" title='Click to clear search markers'></div>-->
    </div>
    <script src="dbf.js"></script>
    <script src="shp.js"></script>
    <!--make labels/markers appear at zoom in to certain area-->
    <script src="https://maps.googleapis.com/maps/api/js?key=AIzaSyBSiI4RQkEiP2iDvTpFpCVdnFcHGa8Usbc&callback=initMap&libraries=places,geometry" async defer>
    </script>
    <!--<script src="https://raw.githubusercontent.com/googlemaps/v3-utility-library/master/markerwithlabel/src/markerwithlabel.js">
    </script>-->
    <script type="text/javascript" src="MarkerWithLabel.js"></script>
    <script type="text/javascript">
        var map;
        var shp;
        var dbf;
        var list = [];
        var ne// = new google.maps.LatLng(90, 180);
        var sw// = new google.maps.LatLng(-90, -180);
        //var markers = [];
        var markerList = [];
        var master = [];
        var sh;
        var db;
        //var infoWindow;

        //createmarker
        function createMarker(point, info, type, name) {
                //var iconURL = '../cone.png'; var iconSize = new google.maps.Size(20, 34);
                var iconURL = './images/'; var iconSize = new google.maps.Size(15, 15);
                //var iconOrigin = new google.maps.Point(0, 0); var iconAnchor = new google.maps.Point(10, 34);
                var iconOrigin = new google.maps.Point(0, 0); var iconAnchor = new google.maps.Point(0, 32);

                //others: cape,
                //alert(type);
                if (type == 'School') iconURL += 'school.png';
                else if (type == 'Island') iconURL += 'island.png';
                else if (type == 'Park') iconURL += 'park.png';
                else if (type == 'Hospital') iconURL += 'hospital.png';
                else if (type == 'Lake' || type == 'Reservoir'
                    || type == 'Dam' || type == 'Basin') iconURL += 'lake.png';
                else if (type == 'Forest' || type == 'Woods') iconURL += 'forest.png';
                else if (type == 'Church') iconURL += 'cross.png';
                else if (type == 'Populated Place') iconURL += 'people.png';
                else if (type == 'Channel' || type == 'Stream' || type == 'Bay' || type == 'Canal') iconURL += 'river.png';
                else if (type == 'Building') iconURL += 'building3.png';
                else if (type == 'Post Office') iconURL += 'post-office.png';
                else if (type == 'Tower') iconURL += 'radio-tower.png';
                else if (type == 'Valley' || type == 'Ridge' || type == 'Cape') iconURL += 'rock.png';
                else if (type == 'Crossing' || type == 'Trail') iconURL += 'crossroad.png';
                else if (type == 'Airport') iconURL += 'plane.png';
                else if (type == 'Well') iconURL += 'well.png';
                else if (type == 'Bridge') iconURL += 'bridge.png';
                else if (type == 'Tunnel') iconURL += 'tunnel.png';
                else if (type == 'Harbor' || type == 'Beach' || type == 'Oilfield'
                    || type == 'Spring' || type == 'Falls') iconURL += 'water.png';
                else if (type == 'Cemetery') iconURL += 'tomb.png';
                else if (type == 'Pillar') iconURL += 'pillar.png';
                else if (type == 'Military') iconURL += 'subgun.png';
                else if (type == 'Locale' || type == 'Bar' || type == 'Civil'
                    || type == 'Area') iconURL += 'point.png';
                else if (type == 'Mine') iconURL += 'mine.png';
                else if (type == 'Arch' || type == 'Gap') iconURL += 'arch.png';
                else if (type == 'Summit') iconURL += 'hill.png';
                else {
                    //Gut, Bend, Range, Census, Swamp, Flat, Bench
                    iconURL += 'marker.png';
                    /*var found = false;
                    for (var i = 0; i < list.length; i++) {
                        if (type == list[i]) found = true;
                    }
                    if (!found) list.push(type);*/
                }
                //iconURL = 'http://www.mapsmarker.com/wp-content/uploads/leaflet-maps-marker-icons/bar_coktail.png';

                var myIcon = new google.maps.MarkerImage(iconURL, iconSize, iconOrigin, iconAnchor);

                //also figure out how to only load ones within the current bounaries.

                var markerImage = {
                    url: iconURL,
                    scaledSize: new google.maps.Size(15, 15),
                    labelOrigin: new google.maps.Point(0,0),
                    //origin: new google.maps.Point(0, 0),
                    //anchor: new google.maps.Point(0, 32)
                };
                var marker = new google.maps.Marker({
                    map: map,
                    position: point, 
                    icon: markerImage,
                    name: name
                });
                if(zoom >= 16) {
                    //marker = new MarkerWithLabel({

                    marker = new google.maps.Marker({
                        position: point,
                        map: map,
                        icon: markerImage,
                        name: name,
                        label: {
                            text: name,
                            color: 'red',
                            origin: new google.maps.Point(0, 20),
                            fontSize: '12px',
                            fontWeight: 'bold'
                        }
                        /*draggable: false,
                        labelContent: name,
                        labelClass: "labels",
                        labelInBackground: false */
                    });
                }/* else if(zoom >= 16) {
                    marker = new google.maps.Marker({
                        position: point,
                        map: map,
                        icon: markerImage,
                        name: name
                    });
                }*/
                //alert(markers.length);
                markerList.push(marker);
                master.push(marker.position);

                var infoWindowOpts = { content: info };
                var infoWindow = new google.maps.InfoWindow(infoWindowOpts);

                google.maps.event.addListener(marker, 'click', function () {
                    //var html = "<b>" + name + "</b> <br/>" + address;
                    //infoWindow.setContent(html)
                    infoWindow.open(map, marker);
                });
        }
        var zoom = 10;

        function updateContent() {
            infoWindow.setContent
        }

        function CenterControl(controlDiv, map) {

            // Set CSS for the control border.
            var controlUI = document.createElement('div');
            controlUI.style.backgroundColor = '#fff';
            controlUI.style.border = '2px solid #000';
            controlUI.style.borderRadius = '3px';
            controlUI.style.boxShadow = '0 2px 6px rgba(0,0,0,.3)';
            //controlUI.style.left = '300px';
            controlUI.marginLeft = '300px';
            controlUI.style.cursor = 'pointer';
            controlUI.style.marginBottom = '5px';
            controlUI.style.textAlign = 'clear';
            controlUI.title = 'Click to clear the map';
            controlDiv.appendChild(controlUI);

            // Set CSS for the control interior.
            var controlText = document.createElement('div');
            controlText.style.color = 'rgb(25,25,25)';
            controlText.style.fontFamily = 'Roboto,Arial,sans-serif';
            controlText.style.fontSize = '16px';
            controlText.style.lineHeight = '20px';
            controlText.style.paddingLeft = '5px';
            controlText.style.paddingRight = '5px';
            controlText.innerHTML = 'Clear';
            controlUI.appendChild(controlText);

            // Setup the click event listeners: simply set the map to Chicago.
            //controlUI.addEventListener('click', function() {
            //map.setCenter(chicago);
            //});

}


        function initMap() {
        
            map = new google.maps.Map(document.getElementById('map'), {
                center: { lat: 37, lng: -122 },
                zoom: 8
            });
            var c;
            google.maps.event.addListenerOnce(map, "center_changed", function() {c = map.getCenter(); });
            
            ne = new google.maps.LatLng(90, 180);
            sw = new google.maps.LatLng(-90, -180);

            var NE = new google.maps.LatLng(38.1, -121.5);
            var SW = new google.maps.LatLng(37.5, -122.5);
            var bounds = new google.maps.LatLngBounds(SW, NE);
            map.fitBounds(bounds);
            
            shpfile = 'PointData/CulturalFeatures';
            
            //SHPParser.load(shpfile + '.shp', shpLoad, shpLoadError);
            //DBFParser.load(shpfile + '.dbf', dbfLoad, dbfLoadError);

            var input =(
                document.getElementById('txt'));
            map.controls[google.maps.ControlPosition.TOP_LEFT].push(input);

            var searchBox = new google.maps.places.SearchBox((input));
            //searchBox.index = 1;

            document.getElementById('txt').style.left = 100;
            document.getElementById('txt').style.top = 200;
            //document.getElementById('txt').style.
            var used = false;
            var markerNum = 0;
            /*google.maps.event.addListener(map, 'click', function (event) {
                for(var y = 0; y < searchMarkers.length; y++) {
                    searchMarkers[y].setMap(null);
                }
                searchMarkers = [];
            });*/

            //var controlMarkerUI = document.createElement('div');
            //controlMarkerUI.id = 'clear';
            /*var clear = document.getElementById('clear');
            clear.style.cursor = 'pointer';
            clear.style.backgroundImage = "./images/clear.png";
            clear.style.height = '25px';
            clear.style.width = '50px';
            clear.style.top = '11px';
            clear.style.left = '120px';
            clear.title = 'Click to clear search markers';*/
            //myLocationControlDiv.appendChild(controlUI);

            

            var clearDiv = document.createElement('div');
            var clear = new CenterControl(clearDiv, map);
            clearDiv.index = 1;
            map.controls[google.maps.ControlPosition.TOP_CENTER].push(clearDiv);
            //var yui = document.getElementById('clear');
            //if(clear) {
            clearDiv.addEventListener('click', function() {
                var c = map.getCenter();
                var b = map.getBounds();
                //alert("hi");
                if(map.getZoom() >= 16) {
                    map.setZoom(15);
                }
                var z = map.getZoom();
                /*map = new google.maps.Map(document.getElementById('map'), {
                    center: c,
                    zoom: z
                });*/
                //map.setCenter
                for(var y = 0; y < searchMarkers.length; y++) {
                    searchMarkers[y].setMap(null);
                }
                for(y = 0; y < markerList.length; y++) {
                    markerList[y].setMap(null);
                    if(y < master.length)
                    master[y].setMap(null);
                }
                searchMarkers = [];
                markerList = [];
                master = [];
            });
            //}

            google.maps.event.addListener(map, 'click', function() {
                for(var y = 0; y < searchMarkers.length; y++) {
                    searchMarkers[y].setMap(null);
                }
                searchMarkers = [];
            });

            google.maps.event.addListener(map, 'mouseup', function (event) {
                if(map.getZoom() >= 16) {
                    clearMarkers();
                    SHPParser.load(shpfile + '.shp', shpLoad, shpLoadError);
                    DBFParser.load(shpfile + '.dbf', dbfLoad, dbfLoadError);
                }
            });

            google.maps.event.addDomListener(document, 'keyup', function (e) {
                var code = (e.keyCode ? e.keyCode : e.which);
                if (code === 37 || code === 38 || code === 39 || code === 40) {
                    clearMarkers();
                    SHPParser.load(shpfile + '.shp', shpLoad, shpLoadError);
                    DBFParser.load(shpfile + '.dbf', dbfLoad, dbfLoadError);
                }
            });

            //find out how to do the clear button

            var labels = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
            var labelIndex = 0;
            var markerL = [];
            var searchMarkers = [];
            //var markerI;
            function addMarker(location, map) {
                var markerI = new google.maps.Marker({
                    position: location,
                    label: {
                        text: labels[labelIndex++ % labels.Length],
                        color:"#FFFFFF",
                        fontSize:"10px",
                        fontWeight:"bold",
                    },
                    map: map
                });
                markerL.push(markerI);
            }
            var loaded = false;
            var labeled = false;
            google.maps.event.addListener(map, 'zoom_changed', function() {
                zoom = map.getZoom();
                if(zoom >= 16 && !loaded) {
                    clearMarkers();
                    SHPParser.load(shpfile + '.shp', shpLoad, shpLoadError);
                    DBFParser.load(shpfile + '.dbf', dbfLoad, dbfLoadError);
                    loaded = true;
                /*} else if(zoom >= 16 && !loaded) {
                    //alert(map.getZoom());
                    //alert(ne + ", " + sw);
                    clearMarkers();
                    SHPParser.load(shpfile + '.shp', shpLoad, shpLoadError);
                    DBFParser.load(shpfile + '.dbf', dbfLoad, dbfLoadError);
                    loaded = true;
                    labeled = false;*/
                } else if(zoom < 16 && loaded) {
                    clearMarkers();
                    loaded = false;
                }/* else {
                    clearMarkers();
                    loaded = false;
                }*/
            });

            google.maps.event.addListener(map, 'bounds_changed', function() {
                if(map.getBounds() != null) {
                    ne = map.getBounds().getNorthEast();
                    sw = map.getBounds().getSouthWest();
                }
                //alert(ne + ", " + sw);
                zoom = map.getZoom();
                if(zoom >= 16 && !loaded) {
                    clearMarkers();
                    SHPParser.load(shpfile + '.shp', shpLoad, shpLoadError);
                    DBFParser.load(shpfile + '.dbf', dbfLoad, dbfLoadError);
                    loaded = true;
                /*} else if(zoom >= 16 && !loaded) { //loading/unloading doesn't work
                    //alert(map.getZoom());
                    clearMarkers();
                    SHPParser.load(shpfile + '.shp', shpLoad, shpLoadError);
                    DBFParser.load(shpfile + '.dbf', dbfLoad, dbfLoadError);
                    //loaded = true;*/
                } else if(zoom < 16 && loaded) {
                    clearMarkers();
                    loaded = false;
                    /*var currZoom = map.getZoom();
                    var currCen = map.getCenter();
                    map = new google.maps.Map(document.getElementById('map'), {
                        center: currCen,
                        zoom: currZoom
                    });*/
                    //loaded = false;
                    //markerList = [];
                }
            });

            //searchBox
            google.maps.event.addListener(searchBox, 'places_changed', function () {
                var places = searchBox.getPlaces();
                //gray(/opaque?) out all markers if text changed in search box. 
                clearMarkers(null);


                //SHPParser.load(shpfile + '.shp', shpLoad, shpLoadError);
                //DBFParser.load(shpfile + '.dbf', dbfLoad, dbfLoadError);

                minLat = 90;
                maxLat = -90;
                minLng = 180;
                maxLng = -180;
                for (var n = 0; n < places.length; n++) {
                    var place = places[n];
                    var num = -1;
                    for (var k = 0; k < master.length; k++) {
                        //alert(place.geometry.location.lat().toFixed(7) + "\n" + master[k].position.lat().toFixed(7)
                        //+ "\n" + place.geometry.location.lng().toFixed(7) + "\n" + master[k].position.lng().toFixed(7));
                        var latLoc = place.geometry.location.lat().toFixed(7);
                        var lngLoc = place.geometry.location.lng().toFixed(7);
                        var mstLat = master[k].lat().toFixed(7);
                        var mstLng = master[k].lng().toFixed(7);
                        //bool 
                        if (latLoc == mstLat && lngLoc == mstLoc) {
                            num = k;
                        }
                    }
                    if (num > -1) {
                        /*var marker = new google.maps.Marker({
                            map: map,
                            icon: master[num].icon,
                            title: place.name,
                            position: place.geometry.location
                        });*/
                        var marker = new MarkerWithLabel({
                            map: map,
                            //icon: master[num].icon,
                            title: place.name,
                            position: place.geometry.location,
                            draggable: false,
                            labelContent: place.name,
                            labelClass: "labels",
                            labelInBackground: false 
                        });
                        maxLat = place.geometry.location.lat();
                        maxLng = place.geometry.location.lng();
                    } else {
                        var markerImage = {
                            url: './images/marker.png',
                            scaledSize: new google.maps.Size(15, 15)
                        };
                        var marker = new google.maps.Marker({
                            map: map,
                            //icon: markerImage,
                            title: place.name,
                            position: place.geometry.location
                        });
                    }
                    searchMarkers.push(marker);
                }
                var tmp = searchMarkers.length - 1;
                var lat = searchMarkers[tmp].position.lat();
                var lng = searchMarkers[tmp].position.lng();
                //change boundaries for that location.
                var nE = new google.maps.LatLng(lat + .005, lng + .005);
                var sW = new google.maps.LatLng(lat - .005, lng - .005);
                var edge = new google.maps.LatLngBounds(sW, nE);
                map.fitBounds(edge);
            });
        }
        //var maxX = 0; var maxY = 0; var minX = 0; var minY = 0;
        
        function clearMarkers() {
        //alert(markerList.length+ ", " + map.getZoom());
            for (var v = 0; v < markerList.length; v++) {
                markerList[v].setMap(null);
            }
            /*var currZoom = map.getZoom();
                    var currCen = map.getCenter();
                    map = new google.maps.Map(document.getElementById('map'), {
                        center: currCen,
                        zoom: currZoom
             });*/
            markerList = [];
            master = [];
            //alert(markerList.length+ ", " + map.getZoom());alert(markerList.length+ ", " + map.getZoom());
        }

        // Handles the callback from loading DBFParser by assigning the dbf to a global.
        function dbfLoad(db) {
            dbf = db;
            if (dbf && shp) {
                render();
            }
        }

        // Handles the callback from loading SHPParser by assigning the shp to a global.
        function shpLoad(sh) {
            shp = sh;
            if (dbf && shp) {
                render();
            }
        }
        var minLat = 90; var maxLat = -90;
        var minLng = 180; var maxLng = -180;
        function render() {
            minLat = 90;
            maxLat = -90;
            minLng = 180;
            maxLng = -18;0
            if(map.getZoom()) {
                for (var i = 0; i < shp.records.length; i++) {
                    //var shape = shp.records[i].shape;
                    var dbfRecord = dbf.records[i];
                    //var pt = new google.maps.LatLng(shape.content.y, shape.content.x)
                    var pt = new google.maps.LatLng(dbfRecord["PRIM_LAT_D"], dbfRecord["PRIM_LONG_"]);
                    var lat = pt.lat();
                    var lng = pt.lng();
                    /*if (lat < minLat) minLat = lat;
                    if (lat > maxLat) maxLat = lat;
                    if (lng < minLng) minLng = lng;
                    if (lng > maxLng) maxLng = lng;
                    alert(lat + " " + lng);
                    if (lat > maxY || maxY == 0) maxY = lat;
                    else if (lat < minY || minY == 0) minY = lat;
                    if (lng > maxX || maxX == 0) maxX = lng;
                    else if (lng < minX || minX == 0) minX = lng;*/
                    var name = dbfRecord["FEATURE_NA"];
                    var type = dbfRecord["FEATURE_CL"];
                    var info = '<strong>' + name + '</strong><br />' + type;
                    var address;
                    //if(dbfRecord["ACTUAL_ADD"] != null)
                    //    address = dbfRecord["ACTUAL_ADD"];
                    //alert(shape.content.y.toString());
                    var neB = map.getBounds().getNorthEast();
                    var swB = map.getBounds().getSouthWest();
                    var inside = lat <= ne.lat() && lng <= ne.lng() 
                        && lat >= sw.lat() && lng >= sw.lng();
                    if(inside) {
                        createMarker(pt, info, type, name);
                    }// else {
                        //alert(ne.lat() + ", " + ne.lng() + "\n" + sw.lat() + ", " + sw.lng() + "\n" + lat + ", " + lng + "\n" + inside);
                    //    }
                    }
                }
                //ne = new google.maps.LatLng(maxLat, maxLng);
                //sw = new google.maps.LatLng(minLat, minLng);
                //bounds = new google.maps.LatLngBounds(sw, ne);
                //map.fitBounds(bounds);
                /*var text = "";
                for(var n =0; n < list.length-1; n++)
                    text += list[n] + ", ";
                text += list[list.length-1];*/
                //window.prompt("Copy to clipboard: Ctrl+C, Enter", text);
            }

        // error handler for shploader.
        function shpLoadError() {
            window.console.log('shp file failed to load');
        }

        // error handler for dbfloader.
        function dbfLoadError() {
            console.log('dbf file failed to load');
        }
        //google.maps.event.addDomListener(window, "load", initMap);

    </script>
    <!--<script src="https://maps.googleapis.com/maps/api/js?libraries=places&key=AIzaSyBSiI4RQkEiP2iDvTpFpCVdnFcHGa8Usbc"
    async defer></script>-->
  </body>
</html>
