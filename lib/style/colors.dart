import 'package:flutter/material.dart';

enum FoodColors {
  blue("Blue", Colors.blue),
  green("Green", Colors.green);

  const FoodColors(this.name, this.color);

  final String name;
  final Color color;
}
