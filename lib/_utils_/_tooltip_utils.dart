part of '../flutter_artist.dart';

Tooltip _buildTooltip({
  required String message,
  required Widget child,
}) {
  return Tooltip(
    textStyle: TextStyle(fontSize: 11.5, color: Colors.white),
    message: message,
    child: child,
  );
}

Tooltip _buildCustomTooltip({
  required String message,
  required Widget child,
  double verticalOffset = 18,
}) {
  return Tooltip(
    textStyle: TextStyle(fontSize: 11.5, color: Colors.white),
    message: message,
    verticalOffset: verticalOffset,
    triggerMode: TooltipTriggerMode.manual,
    decoration: BoxDecoration(
      color: Colors.blueGrey,
      borderRadius: BorderRadius.circular(5),
    ),
    child: child,
  );
}
