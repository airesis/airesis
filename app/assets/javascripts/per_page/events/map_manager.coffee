class Airesis.MapManager
  constructor: (mapCanvasId, latng, center, zoom)->
    @basename = 'event_meeting_attributes_place_attributes_';
    @geocoder = new (google.maps.Geocoder)
    @latlng = if latng? then latng else new (google.maps.LatLng)(42.407235, 14.260254)
    @center = if center? then center else @latlng
    @zoom = if zoom? then zoom else 8
    @mapCanvasId = mapCanvasId
    @myOptions =
      zoom: @zoom
      center: @center
      mapTypeId: google.maps.MapTypeId.ROADMAP
      panControl: true
      streetViewControl: false
      mapTypeControl: false
    @map = new (google.maps.Map)(document.getElementById(@mapCanvasId), @myOptions)
    @markerCache = {}
    @marker = new (google.maps.Marker)(
      map: @map
      position: @latlng
      draggable: true)
    google.maps.event.addListener @marker, 'dragend', @listenMarkerPosition
    google.maps.event.addListener @map, 'center_changed', @listenCenterChanged
    google.maps.event.addListener @map, 'zoom_changed', @listenZoomChanged

    @mapField('municipality_id').on 'change', =>
      @codeAddress()
    @mapField('address').on 'keyup', =>
      @codeAddress()
  listenMarkerPosition: =>
    location_ = @marker.getPosition()
    @mapField('latitude_original').val location_.lat()
    @mapField('longitude_original').val location_.lng()
  listenCenterChanged: =>
    location_ = @map.getCenter()
    @mapField('latitude_center').val location_.lat()
    @mapField('longitude_center').val location_.lng()
  listenZoomChanged: =>
    @mapField('zoom').val @map.getZoom()
  mapField: (name)=>
    $("##{@basename}#{name}")
  putMarker: (address) =>
    if @markerCache[address] is undefined
      $('.loading_place').show()
      @geocoder.geocode {'address': address}, (results, status) =>
        if status == google.maps.GeocoderStatus.OK
          @markerCache[address] = results
          @posizionaMappa results[0].geometry.location, results[0].geometry.viewport
          @listenMarkerPosition()
          $('.loading_place').hide()
    else
      @listenMarkerPosition()
    return
  codeAddress: ->
    Airesis.delay (=>
      comune = $('#event_meeting_attributes_place_attributes_municipality_id').find(':selected').text()
      if comune != null
        address = comune + ', ' + @mapField('address').val()
        @putMarker address
      return
    ), 600
    return
  posizionaMappa: (latlng, viewport) ->
    @map.setCenter latlng
    @marker.setPosition latlng
    @map.fitBounds viewport
  refresh: ->
    google.maps.event.trigger @map, 'resize'
    @map.setCenter @latlng
