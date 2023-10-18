import 'package:flutter/material.dart';

class StaticMap extends StatefulWidget {
  const StaticMap({
    Key? key,
    required this.markers,
    required this.currentLocation,
    required this.googleMapsApiKey,
    required this.width,
    required this.height,
    required this.zoom,
    // required this.markerUrl,
    required this.onTap,
  }) : super(key: key);

  final List markers;
  final Map currentLocation;
  final String googleMapsApiKey;
  final int width;
  final int height;
  final int zoom;
  // final String markerUrl;
  final VoidCallback onTap;

  @override
  _StaticMapState createState() => _StaticMapState();
}

class _StaticMapState extends State<StaticMap> {
  String startUrl =
      'https://upload.wikimedia.org/wikipedia/commons/thumb/7/70/Solid_white.svg/2000px-Solid_white.svg.png';
  String nextUrl = '';
  static const int defaultWidth = 600;
  static const int defaultHeight = 400;
  Map<String, String> defaultLocation = {
    "latitude": '37.0902',
    "longitude": '-95.7192'
  };

  _buildUrl(Map currentLocation, List locations, int width, int height) {
    var finalUri;
    var baseUri = Uri(
        scheme: 'https',
        host: 'maps.googleapis.com',
        port: 443,
        path: '/maps/api/staticmap',
        queryParameters: {});

    if (currentLocation != null && widget.markers.length == 0) {
      // just center the map on the users location
      finalUri = baseUri.replace(queryParameters: {
        'center':
            '${currentLocation['latitude']},${currentLocation['longitude']}',
        'zoom': widget.zoom.toString(),
        'size': '${width}x$height',
        'key': '${widget.googleMapsApiKey}'
      });
    } else {
      List<String> markers = [];
      // Add a blue marker for the user
      var userLat = currentLocation['latitude'];
      var userLng = currentLocation['longitude'];
      String marker = '$userLat,$userLng';
      markers.add(marker);
      // Add a red marker for each location you decide to add
      widget.markers.forEach((location) {
        var lat = location['latitude'];
        var lng = location['longitude'];
        String marker = '$lat,$lng';
        markers.add(marker);
      });
      String markersString = markers.join('|');
      finalUri = baseUri.replace(queryParameters: {
        'markers': markersString,
        'size': '${width}x$height',
        'key': '${widget.googleMapsApiKey}'
      });
    }
    setState(() {
      startUrl = nextUrl;
      nextUrl = finalUri.toString();
    });
  }

  @override
  void initState() {
    // var currentLocation = widget.currentLocation;
    // if (widget.currentLocation == null) {
    //   currentLocation = defaultLocation;
    // }
    _buildUrl(
        widget.currentLocation, widget.markers, widget.width, widget.height);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // // var currentLocation = widget.currentLocation;
    // if (widget.currentLocation == null) {
    //   currentLocation = defaultLocation;
    // }
    // _buildUrl(currentLocation, widget.markers, widget.width, widget.height);
    return InkWell(
      onTap: widget.onTap,
      child: Container(
        alignment: Alignment.center,
        constraints: BoxConstraints(maxHeight: 100),
        child: FadeInImage(
          placeholder: NetworkImage(startUrl),
          image: NetworkImage(nextUrl),
          fit: BoxFit.cover,
          alignment: Alignment.topCenter,
        ),
      ),
    );
  }
}
