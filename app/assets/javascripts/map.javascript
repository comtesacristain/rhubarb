
var map, select;
   operating_mine_img = 'http://maps.google.com/intl/en_us/mapfiles/ms/micons/red-dot.png';
   historic_mine_img = 'http://maps.google.com/intl/en_us/mapfiles/ms/micons/green-dot.png';
   mineral_deposit_img = 'http://maps.google.com/intl/en_us/mapfiles/ms/micons/yellow-dot.png';
   /*occurrence_img =  new google.maps.MarkerImage('http://gmaps-samples.googlecode.com/svn/trunk/markers/circular/bluecirclemarker.png',
      // This marker is 20 pixels wide by 32 pixels tall.
      new google.maps.Size(31, 31),
      // The origin for this image is 0,0.
      new google.maps.Point(0,0),
      // The anchor for this image is the base of the flagpole at 0,32.
      new google.maps.Point(0, 0), new google.maps.Size(8, 8));*/
   prospect_img = 'http://maps.google.com/intl/en_us/mapfiles/ms/micons/orange-dot.png';
   unknown_img = 'http://maps.google.com/intl/en_us/mapfiles/ms/micons/purple-dot.png';

  function initialize() {
	var default_args = {
		latitude: -27.9,
		longitude: 133.2,
		zoom: 4,
		commodity: null,
		layers: ["operating mine"]
	}
	options=arguments[0];
	for(var index in default_args) {
		if(!options[index]) options[index] = default_args[index];
	}
	var mapOptions = {
                projection: new OpenLayers.Projection("EPSG:900913"),
				displayProjection: new OpenLayers.Projection("EPSG:4326"),
                units: "m",
                maxResolution: 156543.0339,
                maxExtent: new OpenLayers.Bounds(-20037508.34, -20037508.34,
                                                 20037508.34, 20037508.34)
            };

	map = new OpenLayers.Map('map',mapOptions)
	var ghyb = new OpenLayers.Layer.Google("Google", {"sphericalMercator": true});
	map.addControl(new OpenLayers.Control.LayerSwitcher());

	var request = OpenLayers.Request.GET({
		url: "/deposits.json",
		params: {"status":"operating mine"},
		callback: drawLayer
	});
	map.addLayer(ghyb);
	initCentre = new OpenLayers.LonLat(options.longitude, options.latitude);
	projectedpoint = initCentre.transform(map.displayProjection, map.projection);
	//alert(initCentre);
	//alert(projectedpoint);
    map.setCenter(initCentre, options.zoom);

  }
  
  
  function drawLayer(request) {
	
	json = new OpenLayers.Format.GeoJSON;
	x=json.read(request.responseText);
	var styleMap = new OpenLayers.StyleMap({pointRadius: 10,
                         externalGraphic: operating_mine_img});
	for (var i in x) {
	x[i].geometry.transform(new
 OpenLayers.Projection("EPSG:4326"),  new
 OpenLayers.Projection("EPSG:900913"));
 }
	layer = new OpenLayers.Layer.Vector("Operating Mines");
	layer.addFeatures(x);
	
	map.addLayer(layer);

  var selectOptions = {onSelect: onFeatureSelect, onUnselect: onFeatureUnselect};
  select = new OpenLayers.Control.SelectFeature(layer, selectOptions);
  map.addControl(select);
  select.activate();
	
  }
  
   function onFeatureSelect(feature) {
            selectedFeature = feature;
            popup = new OpenLayers.Popup.FramedCloud("Popup", 
                                     feature.geometry.getBounds().getCenterLonLat(),
                                     null,
                                     "<div style='font-size:1em'>Name: <a href='"+feature.attributes.eno+"'>" + feature.attributes.name +"</a>"+
									 "<br />State: " + feature.attributes.state+
									 "<br />Commodities: " + feature.attributes.commodids+"</div>",
                                     null, true, onPopupClose);
            feature.popup = popup;
            map.addPopup(popup);
        }
        function onFeatureUnselect(feature) {
            map.removePopup(feature.popup);
            feature.popup.destroy();
            feature.popup = null;
        }    

		
		function onPopupClose(evt) {
            select.unselect(selectedFeature);
        }

