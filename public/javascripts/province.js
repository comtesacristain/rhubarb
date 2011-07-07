var map;

operating_mine_img = 'http://maps.google.com/intl/en_us/mapfiles/ms/micons/red-dot.png';
historic_mine_img = 'http://maps.google.com/intl/en_us/mapfiles/ms/micons/green-dot.png';
mineral_deposit_img = 'http://maps.google.com/intl/en_us/mapfiles/ms/micons/yellow-dot.png';
prospect_img = 'http://maps.google.com/intl/en_us/mapfiles/ms/micons/orange-dot.png';
unknown_img = 'http://maps.google.com/intl/en_us/mapfiles/ms/micons/purple-dot.png';

function initialize() {
    var default_args = {
        layers: new Array("operating mine","historic mine","mineral deposit"),
        resource: "deposits",
        latitude: -27.9,
        longitude: 133.2,
        zoom: 4,
        commodity: null,
        status: null,
        state: null,
        bounds: null
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
    }

    map = new OpenLayers.Map('map',mapOptions);

    var googleHybrid = new OpenLayers.Layer.Google("Google Hybrid", {
        "type": google.maps.MapTypeId.HYBRID,
        "sphericalMercator": true
    });
    var googleStreets = new OpenLayers.Layer.Google("Google Streets", {
        "sphericalMercator": true
    });
    map.addControl(new OpenLayers.Control.LayerSwitcher());

    map.addLayers([googleHybrid,googleStreets]);

    if (options.bounds) {
        bounds = options.bounds.transform(map.displayProjection, map.projection);
        map.zoomToExtent(bounds)
    }
    else {
        initCentre = new OpenLayers.LonLat(options.longitude, options.latitude);
        projectedpoint = initCentre.transform(map.displayProjection, map.projection);
        map.setCenter(initCentre, options.zoom);
    }
    var styleMap = new OpenLayers.StyleMap({fillColor: "#00ffff",fillOpacity:0.5,strokeOpacity:1,
                strokeColor: "white", strokeWidth:1});
    layer = new OpenLayers.Layer.Vector("Provinces",
                                    {styleMap: styleMap});
    map.addLayer(layer);
    getData(options);
}

function getData(options) {
    

    request = OpenLayers.Request.GET({
        url: "/provinces/"+options.eno+".kml",
            
        callback: drawLayer
    });
}


function drawLayer(request) {
    json = new OpenLayers.Format.KML();
    vectors=json.read(request.responseText);
    //if (vectors.length==0) return;

    vectors[0].geometry.transform(new	OpenLayers.Projection("EPSG:4326"), new OpenLayers.Projection("EPSG:900913"));
    name="Provinces";
  
    layers=map.getLayersByName(name);

    //if (layers[0].visibility) {
    layers[0].destroyFeatures();
    layers[0].addFeatures(vectors);
//}

}




String.prototype.parameterize = function () {
    return this.toLowerCase().replace(" ", "_")
}

String.prototype.titleize = function () {
    x = this.replace("_"," ").split(" ");
    for (var i in x) x[i]=x[i].capitalize();
    return x.join(" ");
}
String.prototype.capitalize = function(){
    if(this.length == 0) return this;
    return this[0].toUpperCase() + this.substr(1);
}
