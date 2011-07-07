var map;

operating_mine_img = 'http://maps.google.com/intl/en_us/mapfiles/ms/micons/red-dot.png';
historic_mine_img = 'http://maps.google.com/intl/en_us/mapfiles/ms/micons/green-dot.png';
mineral_deposit_img = 'http://maps.google.com/intl/en_us/mapfiles/ms/micons/yellow-dot.png';
prospect_img = 'http://maps.google.com/intl/en_us/mapfiles/ms/micons/orange-dot.png';
unknown_img = 'http://maps.google.com/intl/en_us/mapfiles/ms/micons/purple-dot.png';
  
var default_layers = new Array("operating mine","historic mine","mineral deposit"); /* Default layers to be switched on */
  
function initialize() {
    var default_args = {
        controller: "deposits",
        latitude: -27.9,
        longitude: 133.2,
        zoom: 4,
        commodity: null,
        status: null,
        state: null
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

    map = new OpenLayers.Map('map',mapOptions);

    map.events.register("moveend", map, function(e) {
        getData(options);
    });
	
    var googleHybrid = new OpenLayers.Layer.Google("Google Hybrid", {
        "type":G_HYBRID_MAP,
        "sphericalMercator": true,
        numZoomLevels: 19
    });
    var googleStreets = new OpenLayers.Layer.Google("Google Streets", {
        "sphericalMercator": true,
        numZoomLevels: 19
    });
    map.addControl(new OpenLayers.Control.LayerSwitcher());
	
    map.addLayers([googleHybrid,googleStreets]);
    initCentre = new OpenLayers.LonLat(options.longitude, options.latitude);
    projectedpoint = initCentre.transform(map.displayProjection, map.projection);
    map.setCenter(initCentre, options.zoom);
    var layers=new Array;
    for (var i in default_layers) {

        layers[i] = (new OpenLayers.Layer.Vector(default_layers[i].titleize(),{
            styleMap:new OpenLayers.StyleMap({
                pointRadius: 12,
                externalGraphic: eval(default_layers[i].parameterize()+"_img")
            })
        }));

        layers[i].events.on({
            "featureselected": function(e) {
                selectedFeature = e.feature;
                popup = new OpenLayers.Popup.FramedCloud("Popup",
                    e.feature.geometry.getBounds().getCenterLonLat(),
                    null,
                    "<div style='font-size:1em'>Name: <a href='"+e.feature.attributes.eno+"'>" + e.feature.attributes.name +"</a>"+
                    "<br />State: " + e.feature.attributes.state+
                    "<br />Commodities: " + e.feature.attributes.commodids+"</div>",
                    null, true, onPopupClose);
                e.feature.popup = popup;
                map.addPopup(popup);
            },
            "featureunselected": function(e) {
                map.removePopup(e.feature.popup);
                e.feature.popup.destroy();
                e.feature.popup = null;
            }
        });
        if (options.status && options.status!="All" && options.status != default_layers[i]) layers[i].visibility = false;
    }
    var selectOptions = {};
    map.addLayers(layers);
    select = new OpenLayers.Control.SelectFeature(layers, selectOptions);
    map.addControl(select);
    select.activate();
    return map;
}

function getData(options) {
    bounds = map.getExtent();
    bounds=bounds.transform(map.projection,map.displayProjection).toBBOX();
    for (var i in default_layers) {
        parameters = new Object;
        parameters.bounds = "["+bounds+"]"
        //if (options.status) parameters.status=options.status;
        parameters.status = default_layers[i];
        if (options.state) parameters.state=options.state;
        if (options.commodity) parameters.commodity=options.commodity;

        request = OpenLayers.Request.GET({
            url: "/deposits.json",
            params: parameters,
            callback: drawLayer
        });
    }
	
}
  
function drawLayer(request) {
    json = new OpenLayers.Format.GeoJSON;
    vectors=json.read(request.responseText);
    if (vectors.length==0) return;
	
    for (var i in vectors) vectors[i].geometry.transform(new	OpenLayers.Projection("EPSG:4326"), new OpenLayers.Projection("EPSG:900913"));
    name=vectors[0].attributes.operating_status.titleize();
    for (var index in map.popups) map.popups[index].destroy();
    layers=map.getLayersByName(name);
	
    //if (layers[0].visibility) {
    layers[0].destroyFeatures();
    layers[0].addFeatures(vectors);
//}
	
}
  
		
function onPopupClose(evt) {
    select.unselect(selectedFeature);
}


		
String.prototype.parameterize = function () {
    return this.toLowerCase().replace(" ", "_")
}

String.prototype.titleize = function () {
    x = this.replace("_"," ").split(" ");
    for (var i in x) x[i]=x[i].capitalize();
    return x.join(" ");
}

String.prototype.capitalize = function () {
    return this.replace(/\b[a-z]/g, function (str, n) {
        return str.toUpperCase();
    });
}

