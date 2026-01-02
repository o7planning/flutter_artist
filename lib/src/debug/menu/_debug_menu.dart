import 'package:flutter/material.dart';
import 'package:flutter_artist_core/flutter_artist_core.dart';

import '../../core/_core_/core.dart';
import '../../core/icon/icon_constants.dart';

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
              showMenu(
                context: context,
                position: position,
                items: [
                  if (hasLogs)
                    _buildPopupMenuItem(
                      iconData: FaIconConstants.errorIconData,
                      iconColor: Colors.red,
                      title: 'Log Viewer',
                      onTab: _showLogViewerDialog,
                    ),
                  if (isSystemUser && hasLogs) _divider(),
                  if (isSystemUser &&
                      FlutterArtist.canShowDebugShelfStructureViewerDialog())
                    _buildPopupMenuItem(
                      iconData: FaIconConstants.shelfStructureIconData,
                      title: 'Shelf Structure Viewer',
                      onTab: _showDebugShelfStructureViewer,
                    ),
                  if (isSystemUser &&
                      FlutterArtist.debugCanShowUiComponentDialog())
                    _buildPopupMenuItem(
                      iconData: FaIconConstants.uiComponentsIconData,
                      title: 'UI Components Viewer',
                      onTab: _showUiComponentsDialog,
                    ),
                  if (isSystemUser)
                    _buildPopupMenuItem(
                      iconData: FaIconConstants.storageIconData,
                      title: 'Storage Viewer',
                      onTab: _showDebugStorageViewerDialog,
                    ),
                  if (isSystemUser) _divider(),
                  if (isSystemUser)
                    _buildPopupMenuItem(
                      iconData: FaIconConstants.clearCodeFlowIconData,
                      title: 'Clear Code Flow',
                      onTab: _clearCodeFlow,
                    ),
                  if (isSystemUser)
                    _buildPopupMenuItem(
                      iconData: FaIconConstants.flowLogIconData,
                      title: 'Code Flow Viewer',
                      onTab: _showFlowLogStructure,
                    ),
                  if (isSystemUser) _divider(),
                  if (isSystemUser &&
                      FlutterArtist.showRestDebugViewerDialog != null)
                    _buildPopupMenuItem(
                      iconData: FaIconConstants.restDebugIconData,
                      title: 'Rest Debug Viewer',
                      onTab: () {
                        _showRestDebugViewerDialog();
                      },
                    ),
                ],
              );
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

  PopupMenuItem _divider() {
    return const PopupMenuItem(
      height: 4,
      child: Divider(height: 2),
    );
  }

  PopupMenuItem _buildPopupMenuItem({
    required IconData iconData,
    Color? iconColor,
    required String title,
    required Function() onTab,
  }) {
    return PopupMenuItem(
      child: ListTile(
        leading: Icon(
          iconData,
          size: widget.menuItemIconSize,
          color: iconColor ?? widget.menuItemIconColor,
        ),
        title: Text(title),
        onTap: onTab,
      ),
    );
  }

  Future<void> _showUiComponentsDialog() async {
    Navigator.pop(context, null);
    await FlutterArtist.storage.showDebugFaUIComponentsViewerDialog();
  }

  Future<void> _showRestDebugViewerDialog() async {
    Navigator.pop(context, null);
    FlutterArtist.showRestDebugViewerDialog!(context);
  }

  Future<void> _showDebugStorageViewerDialog() async {
    Navigator.pop(context, null);
    await FlutterArtist.storage.showDebugStorageViewerDialog();
  }

  void _clearCodeFlow() {
    Navigator.pop(context, null);
    FlutterArtist.codeFlowLogger.clear();
  }

  Future<void> _showFlowLogStructure() async {
    Navigator.pop(context, null);
    await FlutterArtist.showCodeFlowViewerDialog();
  }

  Future<void> _showDebugShelfStructureViewer() async {
    Navigator.pop(context, null);
    await FlutterArtist.showDebugShelfStructureViewerDialog();
  }

  Future<void> _showLogViewerDialog() async {
    Navigator.pop(context, null);
    // docs: [14545].
    await FlutterArtist.showLogViewerDialog();
  }
}
