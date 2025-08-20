import 'package:flutter/material.dart';

class DialogSizeUtils {
  static Size calculateDebugDialogSize(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double width = size.width > 1000 ? 1000 - 40 : size.width - 40;
    double height = size.height > 620 ? 620 - 40 : size.height - 40;
    return Size(width, height);
  }
}
