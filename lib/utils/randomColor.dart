import 'dart:math';

import 'package:flutter/material.dart';

Color randomColor() {
  List<Color> colors = [
    Colors.green,
    Colors.red,
    Colors.blue,
    Colors.deepOrange,
    Color.fromRGBO(34, 111, 255, 1),
  ];
  Random random = new Random();

  int index = 0;

  index = random.nextInt(colors.length);
  return colors[index];
}

Color randomMomentsColor() {
  List<Color> colors = [
    Colors.green,
    Colors.red[400],
    Colors.blue,
    Colors.deepOrange[300],
  ];
  Random random = new Random();

  int index = 0;

  index = random.nextInt(colors.length);
  return colors[index];
}

