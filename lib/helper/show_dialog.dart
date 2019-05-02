import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../model/food.dart';
import '../widget/rating_star.dart';

void launchMap(FoodModel foodModel) async {
    String url =
        "https://www.google.com/maps/search/?api=1&query=${foodModel.latLng.latitude},${foodModel.latLng.longitude}&query_place_id=${foodModel.placeId}";
    if (await canLaunch(url)) {
      print("Can launch");
      await launch(url);
    } else {
      print("Could not launch");
      throw 'Could not launch Maps';
    }
}

void showDialogHelper(FoodModel foodModel, BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      // return object of type Dialog
      return AlertDialog(
        title: new Text(foodModel.name),
        // content: new Text("You sure you want to go?"),
        content: new Container(
          child: Column(
            children: <Widget>[
              ratingStar(context, foodModel.rating),
              SizedBox(
                height: 15.0,
              ),
              ClipRRect(
                borderRadius: new BorderRadius.circular(8.0),
                child: Image(
                  fit: BoxFit.fill,
                  image: NetworkImage(foodModel.image),
                  height: 150.0,
                ),
              ),
              SizedBox(
                height: 15.0,
              ),
              Text(
                  'The food is ${foodModel.distance.toStringAsFixed(3)}km away =D'),
              SizedBox(
                height: 10.0,
              ),
              Container(
                  padding: EdgeInsets.only(top: 10.0),
                  child: Text("You sure you want to go?"))
            ],
          ),
          height: 270.0,
        ),
        actions: <Widget>[
          // usually buttons at the bottom of the dialog
          new FlatButton(
            child: new Text("Go"),
            onPressed: () {
              launchMap(foodModel);
              Navigator.of(context).pop();
            },
          ),
          new FlatButton(
            child: new Text("Close"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
