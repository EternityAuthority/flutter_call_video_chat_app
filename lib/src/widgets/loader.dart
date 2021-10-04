import 'package:flutter/material.dart';

import 'package:waya/utils/color_loader.dart';

circle() {
  return Center(
    child: ColorLoader(radius: 20, dotRadius: 5),
  );
}
