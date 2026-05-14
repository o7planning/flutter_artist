import 'package:flutter/material.dart';
import 'package:flutter_artist_styles/flutter_artist_styles.dart';

class DebugConstants {
  static Color eventSourceIconColor(BuildContext context) =>
      Theme.of(context).colorScheme.primary;

  static Color listenerIconColor(BuildContext context) =>
      Theme.of(context).colorScheme.error;

  static Color classParametersColor(BuildContext context) {
    //  FaColorUtils.technicalHighlight(context);
    return context.faColors.ink.primary;
  }

  static Color rootGraphBoxBgColor(BuildContext context) {
    return Theme.of(context)
        .colorScheme
        .primaryContainer
        .withValues(alpha: 0.9);
  }

  static Color activeGraphBoxBgColor(BuildContext context) {
    return Theme.of(context).colorScheme.surface;
  }

  static Color? inactiveGraphBoxBgColor(BuildContext context) {
    return Theme.of(context)
        .colorScheme
        .surfaceContainerHighest
        .withValues(alpha: 0.5);
  }

  static Color graphBoxTextColor(BuildContext context) {
    return context.faColors.ink.label;
  }

  static BoxShadow graphBoxShadow(BuildContext context) {
    return BoxShadow(
      color: Colors.black.withValues(alpha: 0.2),
      spreadRadius: 0,
      blurRadius: 10,
      offset: const Offset(0, 4),
    );
  }

  static const double graphBoxIconSize = 32;
  static const double graphBoxImageWidth = 32;
  static const double graphBoxImageHeight = 24;
  static final double graphBoxFontSizeRootBox = 13;
  static final double graphBoxFontSizeChildBox = 11.5;
  static final double blockOrScalaInfoFontSize = 12;
  static final double debugFontSize = 13;

  static Color graphBoxDataStateReadyBgColor(BuildContext context) =>
      Colors.green;

  static Color graphBoxDataStatePendingBgColor(BuildContext context) =>
      Colors.black54;

  static Color graphBoxDataStateErrorBgColor(BuildContext context) =>
      Colors.redAccent;

  static Color graphBoxDataStateNoneBgColor(BuildContext context) =>
      Colors.grey;

  static const Color listenerTextColor = Colors.indigo;
  static const Color eventSourceTextColor = Colors.red;

  static Color nonEventOrListenerIconColor(BuildContext context) {
    // return FaColorUtils.primaryAction(context);
    return context.faColors.ink.primary;
  }

  static List<Color> filterColors(BuildContext context) {
    return [
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
  }

  static Color selectedGraphBoxBgColor(BuildContext context) {
    return Colors.green.withAlpha(20);
  }

  static Color shadowGraphBoxColor(BuildContext context) {
    return Colors.grey.withAlpha(127);
  }

  static Color graphBoxHighlighFilterColor(BuildContext context) {
    return Colors.amberAccent.withAlpha(80);
  }

  static TextStyle listenerTextStyle(BuildContext context) {
    return TextStyle(
      color: DebugConstants.listenerTextColor,
      fontWeight: FontWeight.bold,
    );
  }

  static TextStyle eventSourceTextStyle(BuildContext context) {
    return TextStyle(
      color: DebugConstants.eventSourceTextColor,
      fontWeight: FontWeight.bold,
    );
  }
}
