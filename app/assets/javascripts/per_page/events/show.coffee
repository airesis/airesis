window.EventsShow =
  init: ->
    unless @votation
      @latlng = new (google.maps.LatLng)(EventsShow.latitudeOriginal, EventsShow.longitudeOriginal)
      @center = @latlng

      @myOptions =
        zoom: @zoom
        center: @center
        mapTypeId: google.maps.MapTypeId.ROADMAP
        panControl: false
        streetViewControl: false
        mapTypeControl: true
        draggable: true

      @map = new (google.maps.Map)(document.getElementById('map_canvas'), @myOptions)

      @marker = new google.maps.Marker
        map: @map
        position: @latlng
        draggable: false
