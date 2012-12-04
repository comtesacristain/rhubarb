var map;

var select;
//var default_layers = new Array("major_projects","deposits");
//var deposits_layers = new Array("operating mine","historic mine","mineral deposit")


var defaultLayers = {
    //"powerstations": ["renewable" , "fossil fuel" ],
    "major_projects" : [null],
    "occurrences": [null],
    "deposits" : ["historic mine" ,"mineral deposit" ,"operating mine"]
}
function initialize() {
    var default_args = {
        controller: "deposits",
        latitude: -27.9,
        longitude: 133.2,
        zoom: 4
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
        maxExtent: new OpenLayers.Bounds(-20037508.34, -20037508.34, 20037508.34, 20037508.34)
    };

    
    map = new OpenLayers.Map('map',mapOptions);
     

    var googleHybrid = new OpenLayers.Layer.Google("Google Hybrid", {
        type:google.maps.MapTypeId.HYBRID,
        "sphericalMercator": true,
        numZoomLevels: 19
    });
    var googleStreets = new OpenLayers.Layer.Google("Google Streets", {
        "sphericalMercator": true,
        numZoomLevels: 19
    });
    switcher = new OpenLayers.Control.LayerSwitcher();
    //latlong = new OpenLayers.Control.MousePosition({'element': document.getElementById('latlong')});
    //switcher.onLayerClick
    map.addControls([switcher]);//,latlong]);
    map.addLayers([googleHybrid,googleStreets]);
    initCentre = new OpenLayers.LonLat(options.longitude, options.latitude);
    initCentre.transform(map.displayProjection, map.projection);
    map.setCenter(initCentre, options.zoom);
    buildLayers();
    map.setCenter(initCentre, options.zoom);
    
    map.events.register("click", map, function(e) {
        var position = map.getLonLatFromPixel(e.xy);
        position.transform(map.projection, map.displayProjection)
        OpenLayers.Util.getElement("latlong").innerHTML = 
        'Identified location: '+ position.lon.toFixed(6) + ', ' + position.lat.toFixed(6);

    });

}


function buildLayers() {
    var layers=new Array;
    var layer;
    for (var key in defaultLayers) {
        if (defaultLayers.hasOwnProperty(key)) {
            for (var i in defaultLayers[key]) {
                if (!defaultLayers[key][i]) title = key.titleize();
                else title =  defaultLayers[key][i].titleize();
                if (key=="deposits") params = {
                    "status":defaultLayers[key][i]
                    }
                else params=null;
                layer = new OpenLayers.Layer.Vector(title, {
                    projection: map.displayProjection,
                    strategies: [new OpenLayers.Strategy.BBOX()],
                    protocol: new OpenLayers.Protocol.HTTP({
                        url: "/"+key+".kml",
                        params: params,
                        format: new OpenLayers.Format.KML({
                            extractStyles: true,
                            extractAttributes: true
                        })
                    })
                });
                layer.events.on({
                    "featureselected": onFeatureSelect,
                    "featureunselected": onFeatureUnselect,
                    "featuresadded": destroyPopups
                });
                layers.push(layer);
            }
        }
        map.addLayers(layers)
        select = new OpenLayers.Control.SelectFeature(layers);
        map.addControl(select);
        select.activate();
    }


}
//var layers=new Array;




/*for (var i in default_layers) {

        layers[i] = new OpenLayers.Layer.Vector(default_layers[i].titleize(), {
            projection: map.displayProjection,
            strategies: [new OpenLayers.Strategy.BBOX()],
            protocol: new OpenLayers.Protocol.HTTP({
                url: "/"+default_layers[i]+".kml",
                format: new OpenLayers.Format.KML({
                    extractStyles: true,
                    extractAttributes: true
                })
            })
        });
        layers[i].events.on({
            "featureselected": onFeatureSelect,
            "featureunselected": onFeatureUnselect,
            "featuresadded": destroyPopups
        });

    }
    map.addLayers(layers)
    select = new OpenLayers.Control.SelectFeature(layers);
    map.addControl(select);
    select.activate();*/
    


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

String.prototype.capitalize = function () {
    return this.replace(/\b[a-z]/g, function (str, n) {
        return str.toUpperCase();
    });
}
