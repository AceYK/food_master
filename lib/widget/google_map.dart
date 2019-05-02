import 'package:flutter/material.dart';
import 'dart:math';
import 'package:google_maps_flutter/google_maps_flutter.dart';

List<LatLng> drawCircle(LatLng point, radius, dir) {
  double d2r = pi / 180;
  double r2d = 180 / pi;
  int earthsradius = 3963;

  int points = 300;
  // find the raidus in lat/lon
  double rlat = (radius / earthsradius) * r2d;
  double rlng = rlat / cos(point.latitude * d2r);

  List<LatLng> extp = [];
  int start;
  int end;
  if (dir == 1) {
    start = 0;
    end = points + 1; // one extra here makes sure we connect the path
  } else {
    start = points + 1;
    end = 0;
  }
  for (var i = start; (dir == 1 ? i < end : i > end); i = i + dir) {
    var theta = pi * (i / (points / 2));
    double ey = point.longitude + (rlng * cos(theta));
    double ex = point.latitude + (rlat * sin(theta));
    extp.add(LatLng(ex, ey));
  }
  return extp;
}

Widget googleMap(
    BuildContext context, List<Marker> allMarkers, LatLng currentPosition) {
  return Container(
    height: MediaQuery.of(context).size.height,
    width: MediaQuery.of(context).size.width,
    child: GoogleMap(
      markers: Set.from(allMarkers),
      initialCameraPosition: CameraPosition(
          target: LatLng(
              currentPosition.latitude - 0.0018, currentPosition.longitude),
          zoom: 16.3),
      // mapType: MapType.terrain,
      myLocationEnabled: true,
      polylines: {
        Polyline(
            polylineId: PolylineId('circle'),
            points: drawCircle(currentPosition, 0.2, 1),
            color: Theme.of(context).primaryColor)
      },
    ),
  );
}
