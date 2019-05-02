import 'package:flutter/material.dart';

Widget _buildStar(BuildContext context, int index, double rating) {
  Icon icon;
  if (index >= rating) {
    icon = new Icon(
      Icons.star_border,
      color: Theme.of(context).primaryColor,
      size: 25.0,
    );
  } else if ((index >= (rating - 0.5)) && (index < rating)) {
    icon = new Icon(
      Icons.star_half,
      color: Theme.of(context).primaryColor,
      size: 25.0,
    );
  } else {
    icon = new Icon(
      Icons.star,
      color: Theme.of(context).primaryColor,
      size: 25.0,
    );
  }

  return icon;
}

Widget ratingStar(BuildContext context, double rating) {
  int starCount = 5;
  return new Material(
    color: Colors.transparent,
    child: new Wrap(
        alignment: WrapAlignment.start,
        children: new List.generate(
            starCount, (index) => _buildStar(context, index, rating))),
  );
}
