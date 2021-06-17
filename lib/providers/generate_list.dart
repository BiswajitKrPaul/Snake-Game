import 'dart:math';

import 'package:flutter/material.dart';
import 'package:sizedbox/providers/constant.dart';

class GameGrid with ChangeNotifier {
  List gameGridList = List.generate(
      kTotalNoColumn, (index) => List.generate(kTotalNoRow, (index) => 0));
}
