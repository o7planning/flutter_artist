import 'package:flutter/material.dart';

class DebugConstants {
  static const Color listenerTextColor = Colors.indigo;
  static const Color eventSourceTextColor = Colors.red;

  static const Color eventSourceIconColor = Colors.red;
  static const Color listenerIconColor = Colors.indigo;

  static const Color nonEventOrListenerIconColor = Colors.indigo;

  static const Color classParametersColor = Colors.purpleAccent;

  static const List<Color> filterColors = [
    Colors.lightBlueAccent, //
    Colors.indigo, //
    Colors.greenAccent, //
    Colors.brown, //
    Colors.purple, //
    Colors.teal, //
    Colors.purpleAccent, //
    Colors.black54, //
    Colors.deepOrangeAccent, //
    Colors.amber, //
    Colors.deepOrangeAccent, //
  ];

  static final Color rootGraphBoxBgColor = Colors.indigo.withAlpha(60);
  static final Color selectedGraphBoxBgColor = Colors.green.withAlpha(20);
  static final Color activeGraphBoxBgColor = Colors.white;
  static final Color? inactiveGraphBoxBgColor = Colors.grey[200];

  static final Color shadowGraphBoxColor = Colors.grey.withAlpha(127);

  static final BoxShadow graphBoxShadow = BoxShadow(
    color: shadowGraphBoxColor,
    spreadRadius: 1,
    blurRadius: 5,
    offset: const Offset(0, 3),
  );

  static const double graphBoxImageWidth = 32;
  static const double graphBoxImageHeight = 24;

  static final double graphBoxFontSizeRootBox = 13;

  static final double debugFontSize = 13;

  static final double graphBoxFontSizeChildBox = 11.5;

  static final double blockOrScalaInfoFontSize = 12;

  static final Color graphBoxDataStateReadyBgColor = Colors.green;
  static final Color graphBoxDataStatePendingBgColor = Colors.black54;
  static final Color graphBoxDataStateErrorBgColor = Colors.deepOrangeAccent;
  static final Color graphBoxDataStateNoneBgColor = Colors.white;

  static final Color graphBoxTextColor = Colors.white;
  static final Color graphBoxHighlighFilterColor =
      Colors.amberAccent.withAlpha(80);

//

  static final TextStyle listenerTextStyle = TextStyle(
    color: DebugConstants.listenerTextColor,
    fontWeight: FontWeight.bold,
  );

  static final TextStyle eventSourceTextStyle = TextStyle(
    color: DebugConstants.eventSourceTextColor,
    fontWeight: FontWeight.bold,
  );
}
