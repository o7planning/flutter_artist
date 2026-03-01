import 'package:flutter/material.dart';
import 'package:flutter_artist_core/flutter_artist_core.dart';

import '../../core/_core_/core.dart';
import '_debug_menu_builder.dart';

// Docs: [14857] - Debug Menu.
class DebugMenu extends StatefulWidget {
  final double menuItemIconSize;
  final Color? menuItemIconColor;
  final Widget Function({required LogSummary logSummary}) menuButtonBuilder;
  final RelativeRect Function(TapDownDetails details)? calculatePopupPosition;

  const DebugMenu.custom({
    super.key,
    required this.menuButtonBuilder,
    required this.menuItemIconSize,
    required this.menuItemIconColor,
    this.calculatePopupPosition,
  });

  @override
  State<StatefulWidget> createState() {
    return __DebugMenuState();
  }
}

class __DebugMenuState extends State<DebugMenu> implements ILogListener {
  @override
  void initState() {
    super.initState();
    FlutterArtist.addLogListener(this);
  }

  @override
  void onLog() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // docs: [14683].
    ILoggedInUser? loggedInUser = FlutterArtist.loggedInUser;
    bool hasLogs = FlutterArtist.logger.hasLogEntries();
    bool isSystemUser = loggedInUser?.isSystemUser ?? false;
    //
    return InkWell(
      onTapDown: !isSystemUser && !hasLogs
          ? null
          : (TapDownDetails details) {
              // Getting the tap position
              final RelativeRect position =
                  widget.calculatePopupPosition != null
                      ? widget.calculatePopupPosition!(details)
                      : RelativeRect.fromLTRB(
                          details.globalPosition.dx,
                          details.globalPosition.dy + 22,
                          details.globalPosition.dx,
                          details.globalPosition.dy,
                        );

              // Showing the menu
              DebugMenuBuilder.build(
                menuItemIconSize: widget.menuItemIconSize,
                menuItemIconColor: widget.menuItemIconColor,
              ).show(context: context, position: position);
            },
      child: widget.menuButtonBuilder(
        logSummary: LogSummary(
          recentErrorCount: FlutterArtist.logger.recentErrorCount,
          recentWarningCount: FlutterArtist.logger.recentWarningCount,
          totalErrorCount: FlutterArtist.logger.totalErrorCount,
          totalWarningCount: FlutterArtist.logger.totalWarningCount,
        ),
      ),
    );
  }
}
