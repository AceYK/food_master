import 'package:flutter/material.dart';

import '../model/food.dart';
import '../helper/show_dialog.dart';
import '../widget/rating_star.dart';

Widget buildContainer(List<FoodModel> foodModel, BuildContext context) {
  if (foodModel == null) {
    return Container();
  } else {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Container(
        margin: EdgeInsets.only(bottom: 70.0),
        height: 150.0,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: foodModel.length,
          itemBuilder: (BuildContext context, int index) {
            return Row(
              children: <Widget>[
                SizedBox(width: 10.0),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: _boxes(foodModel[index], context),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

Widget _boxes(FoodModel foodModel, context) {
  return GestureDetector(
      onTap: () {
        showDialogHelper(foodModel, context);
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).primaryColor, width: 1),
          borderRadius: BorderRadius.circular(24.0),
        ),
        child: new FittedBox(
          child: Material(
            color: Colors.white,
            elevation: 0,
            borderRadius: BorderRadius.circular(24.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  width: 180,
                  height: 200,
                  child: ClipRRect(
                    borderRadius: new BorderRadius.circular(24.0),
                    child: Image(
                      fit: BoxFit.fitHeight,
                      image: NetworkImage(foodModel.image),
                    ),
                  ),
                ),
                SizedBox(
                  width: 5.0,
                ),
                Column(
                  children: <Widget>[
                    Text(foodModel.name),
                    SizedBox(
                      height: 15.0,
                    ),
                    Text('Rating: ${foodModel.rating} star(s)'),
                    ratingStar(context, foodModel.rating),
                    SizedBox(
                      height: 15.0,
                    ),
                    Text('${foodModel.distance.toStringAsFixed(3)}km'),
                  ],
                ),
                SizedBox(
                  width: 5.0,
                ),
              ],
            ),
          ),
        ),
      ));
}
