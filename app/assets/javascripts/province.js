var map;



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
    var options=arguments[0];
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
    layer = new OpenLayers.Layer.Vector("Provinces");
    layer.events.on({
        "featureselected": onFeatureSelect,
        "featureunselected": onFeatureUnselect,
        "featuresadded": destroyPopups
    });
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
    json = new OpenLayers.Format.KML({
        extractStyles: true,
        extractAttributes: true
    });
    vectors=json.read(request.responseText);
    //if (vectors.length==0) return;
    for (var i in vectors ) {
        if (vectors[i].geometry != null) {
            vectors[i].geometry.transform(new	OpenLayers.Projection("EPSG:4326"), new OpenLayers.Projection("EPSG:900913"));
        }
 
    }
    name="Provinces";
  
    layers=map.getLayersByName(name);

    //if (layers[0].visibility) {
    layers[0].destroyFeatures();
    layers[0].addFeatures(vectors);
    select = new OpenLayers.Control.SelectFeature(layers);
    map.addControl(select);
    select.activate();
    if (vectors[0].geometry != null || vectors.length > 1 ) {
        map.zoomToExtent(layers[0].getDataExtent());
    }
//}

}



function destroyPopups() {
    if (map.popups.length > 0) {
        popup=map.popups[0]
        map.removePopup(popup);
        popup.destroy();
        delete popup;
        destroyPopups();
    }
    return;
}

function onFeatureSelect(event) {
    var feature = event.feature;
    // Since KML is user-generated, do naive protection against
    // Javascript.
    var content = feature.attributes.description;
    if (content.search("<script") != -1) {
        content = "Content contained Javascript! Escaped content below.<br />" + content.replace(/</g, "&lt;");
    }
    popup = new OpenLayers.Popup.FramedCloud(null,
        feature.geometry.getBounds().getCenterLonLat(),
        new OpenLayers.Size(100,100),
        content,
        null, true, onPopupClose);
    feature.popup = popup;
    map.addPopup(popup);
}
function onFeatureUnselect(event) {

    destroyPopups();
//    var feature = event.feature;
//    if(feature.popup) {
//        map.removePopup(feature.popup);
//        feature.popup.destroy();
//        delete feature.popup;
//    }
}

function onPopupClose(evt) {
    select.unselectAll();
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
