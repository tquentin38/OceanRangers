import 'package:flame/game.dart';
import 'package:flutter/material.dart';

double maxX = 2880; //2880
double maxY = 1620; //1620

Vector2 getMaxedSize(BuildContext context) {
  double width = MediaQuery.of(context).size.width;
  if (width > maxX) {
    width = maxX;
  }

  double height = MediaQuery.of(context).size.height;
  if (height > maxY) {
    height = maxY;
  }

  double max = maxY + getMaxHeight(context);
  if (width < height) {
    height = width * max / maxX;
  } else {
    if (width * max / maxX < height) {
      height = width * max / maxX;
    } else {
      width = height * maxX / max;
    }
  }

  return Vector2(width, height);
}

double getPaddingSide(BuildContext context) {
  double width = getMaxedSize(context).x;
  if (MediaQuery.of(context).size.width > width) {
    return (MediaQuery.of(context).size.width - width) / 2;
  }
  return 0;
}

double getMaxHeight(BuildContext context) {
  double h = MediaQuery.of(context).size.height / 15;
  if (h > 40) {
    h = 40;
  }
  return h;
}

double getPaddingVertical(BuildContext context) {
  double height = getMaxedSize(context).y;

  double max = height + getMaxHeight(context);
  if (MediaQuery.of(context).size.height > max) {
    return (MediaQuery.of(context).size.height - max) / 2;
  }
  return 0;
}
