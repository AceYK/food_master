import 'package:google_maps_flutter/google_maps_flutter.dart';

class FoodModel {
  String name;
  LatLng latLng;
  double distance;
  String image;
  String placeId;
  double rating;

  FoodModel(this.name, this.latLng, this.distance, this.image, this.placeId, this.rating);
}