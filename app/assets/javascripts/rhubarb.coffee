class @Rhubarb
  baseLayers: [new OpenLayers.Layer.Google 'Google Streets'
    new OpenLayers.Layer.Google 'Google Hybrid'
      type: google.maps.MapTypeId.HYBRID]
  
  map: null
  
  mapProperties:
    projection: new OpenLayers.Projection "EPSG:900913"
    displayProjection: new OpenLayers.Projection "EPSG:4326"
    controls: [
      new OpenLayers.Control.LayerSwitcher(),
      new OpenLayers.Control.Navigation(),
      new OpenLayers.Control.PanZoom(),
      new OpenLayers.Control.ArgParser(),
      new OpenLayers.Control.Attribution()
    ]
  
  layerOptions: null  
    
  centreLongitude: 133.2
  centreLatitude: -27.9 
  
  zoomLevel: 4
  
  # Functions returning thingies
  displayProjection: ->
    @mapProperties.displayProjection
    
  projection: ->
    @mapProperties.projection
  
  displayCentrePoint: ->
    new OpenLayers.LonLat @centreLongitude, @centreLatitude
  
  centrePoint: ->
    @displayCentrePoint().transform(@displayProjection(),@projection())
  
  constructor: (map, options={}) ->    
    for option, type of options
      if option in @mapProperties
        @mapProperties[option] = type
      else
       this[option] = type
    options.layerOptions ? -> 
      @layerOptions = options.layerOptions
    
    @map = new OpenLayers.Map map, @mapOptions 

    @map.addLayers(@baseLayers)
    @setCentre() if @centrePoint()? and @zoomLevel?
    @setLayers() if @layerOptions?
  
  setCentre: ->
     @map.setCenter(@centrePoint(),@zoomLevel)    

  setLayers: ->
    url = "/" + @layerOptions.controller+".kml?"
    for option, type of @layerOptions
       url =  url + option + "=" + type + "&"
    layer = new OpenLayers.Layer.Vector @layerOptions.controller
    @map.addLayer layer
    request = OpenLayers.Request.GET
      url: url
      callback : =>
        kml = new OpenLayers.Format.KML
          extractStyles: true
          extractAttributes: true
        vectors=kml.read request.responseText
        for vector in vectors
          vector.geometry.transform(@displayProjection(), @projection());
        layer = @map.getLayersByName(@layerOptions.controller)[0]
        layer.addFeatures(vectors)
        @map.zoomToExtent layer.getDataExtent()
