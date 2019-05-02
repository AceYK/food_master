import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;

import '../model/food.dart';
import '../widget/box_slider.dart';
import '../widget/google_map.dart';
import '../helper/show_dialog.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return HomePageState();
  }
}

class HomePageState extends State<HomePage> {
  List<FoodModel> foodData;
  List<Marker> allMakers = [];
  LatLng currentPosition;

  @override
  void initState() {
    super.initState();
    _getData();
  }

  @override
  Widget build(BuildContext context) {
    if (currentPosition == null) {
      return Scaffold(
        appBar: new AppBar(
          title: new Text("Loading..."),
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(FontAwesomeIcons.arrowLeft),
            onPressed: () {},
          ),
          title: Text("Food Near Me"),
          actions: <Widget>[
            IconButton(
              icon: Icon(FontAwesomeIcons.search),
              onPressed: () {},
            )
          ],
        ),
        body: Stack(
          children: <Widget>[
            googleMap(context, allMakers, currentPosition),
            buildContainer(foodData, context),
            _refreshLocationWidget(),
            _randomFoodWidget(),
          ],
        ),
      );
    }
  }

  Widget _refreshLocationWidget() {
    return Container(
      child: RaisedButton(
          onPressed: _getData,
          child: Text('Refresh Location'),
          color: Theme.of(context).accentColor,
          shape: new RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(30.0))),
      margin: EdgeInsets.all(10.0),
    );
  }

  Widget _randomFoodWidget() {
    return Positioned(
      child: new Align(
        alignment: FractionalOffset.bottomCenter,
        child: Container(
          child: RaisedButton(
              onPressed: () {
                int randomFood = Random().nextInt(foodData.length);
                showDialogHelper(foodData[randomFood], context);
              },
              child: Text('Random Food'),
              color: Theme.of(context).primaryColor,
              elevation: 4.0,
              shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(30.0))),
          margin: EdgeInsets.only(bottom: 14.0),
        ),
      ),
    );
  }

  Future<void> _getCurrentLocation() async {
    final location = new Location();
    LocationData currentLocation = await location.getLocation();
    setState(() {
      currentPosition =
          LatLng(currentLocation.latitude, currentLocation.longitude);
    });
  }

  Future<String> _getData() async {
    await _getCurrentLocation();
    final url =
        'https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=${currentPosition.latitude},${currentPosition.longitude}&radius=200&keyword=food&type=restaurant&key=YOUR_API_KEY';
    final http.Response res = await http
        .get(Uri.encodeFull(url), headers: {"Accept": "application/json"});
    setState(() {
      final resBody = json.decode(res.body);
      final List data = resBody["results"];
      foodData = data.map((dynamic rawData) {
        String name = rawData["name"];
        LatLng latLng = LatLng(rawData["geometry"]["location"]["lat"],
            rawData["geometry"]["location"]["lng"]);
        double distance = pow(
                pow(latLng.latitude - currentPosition.latitude, 2) +
                    pow(latLng.longitude - currentPosition.longitude, 2),
                0.5) *
            637.1;
        String imageUrl;
        if (rawData.keys.contains("photos")) {
          String image = rawData["photos"][0]["photo_reference"];
          imageUrl =
              'https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=$image&key=YOUR_API_KEY';
        } else {
          imageUrl = rawData["icon"];
        }
        double rating =
            rawData["rating"] == null ? 0.0 : rawData["rating"].toDouble();
        String placeId = rawData["place_id"];
        allMakers.add(Marker(
            markerId: MarkerId(name),
            draggable: false,
            position: latLng,
            infoWindow: InfoWindow(
                title: name,
                onTap: () {
                  showDialogHelper(
                      FoodModel(
                          name, latLng, distance, imageUrl, placeId, rating),
                      context);
                })));
        return new FoodModel(name, latLng, distance, imageUrl, placeId, rating);
      }).toList();
      foodData.sort((a, b) => a.distance.compareTo(b.distance));
    });
    return "Success";
  }
}
