import 'package:flutter/material.dart';
import 'package:flutter_artist_core/flutter_artist_core.dart';

import '../../core/_core_/core.dart';
import '../../core/icon/icon_constants.dart';

class DebugMenuBuilder {
  final double menuItemIconSize;
  final Color? menuItemIconColor;

  DebugMenuBuilder.build({
    this.menuItemIconSize = 18,
    this.menuItemIconColor,
  });

  Future<void> show({
    required BuildContext context,
    RelativeRect? position,
    PopupMenuPositionBuilder? positionBuilder,
  }) async {
    ILoggedInUser? loggedInUser = FlutterArtist.loggedInUser;
    bool hasLogs = FlutterArtist.logger.hasLogEntries();
    bool isSystemUser = loggedInUser?.isSystemUser ?? false;
    //
    await showMenu(
      context: context,
      position: position,
      positionBuilder: positionBuilder,
      items: [
        if (hasLogs)
          _buildPopupMenuItem(
            iconData: FaIconConstants.errorIconData,
            iconColor: Colors.red,
            title: 'Log Viewer',
            onTab: () {
              _showLogViewerDialog(context);
            },
          ),
        if (isSystemUser && hasLogs) _divider(),
        if (isSystemUser)
          _buildPopupMenuItem(
            iconData: FaIconConstants.appIconData,
            title: 'App Inspector',
            onTab: () {
              _showDebugAppInspectorDialog(context);
            },
          ),
        if (isSystemUser && FlutterArtist.canShowDebugShelfStructureInspector())
          _buildPopupMenuItem(
            iconData: FaIconConstants.shelfStructureIconData,
            title: 'Shelf Structure Inspector',
            onTab: () {
              _showDebugShelfStructureInspector(context);
            },
          ),
        if (isSystemUser && FlutterArtist.debugCanShowUiComponentDialog())
          _buildPopupMenuItem(
            iconData: FaIconConstants.uiComponentsIconData,
            title: 'UI Context Inspector',
            onTab: () {
              _showDebugUiContextInspector(context);
            },
          ),
        if (isSystemUser)
          _buildPopupMenuItem(
            iconData: FaIconConstants.themeIconData,
            title: 'Theme Inspector',
            onTab: () {
              _showDebugThemeInspector(context);
            },
          ),
        if (isSystemUser) _divider(),
        if (isSystemUser)
          _buildPopupMenuItem(
            iconData: FaIconConstants.clearCodeFlowIconData,
            title: 'Clear Code Flow',
            onTab: () {
              _clearCodeFlow(context);
            },
          ),
        if (isSystemUser)
          _buildPopupMenuItem(
            iconData: FaIconConstants.flowLogIconData,
            title: 'Code Flow Inspector',
            onTab: () {
              _showCodeFlowInspector(context);
            },
          ),
        if (isSystemUser) _divider(),
        if (isSystemUser && FlutterArtist.showDebugNetworkInspector != null)
          _buildPopupMenuItem(
            iconData: FaIconConstants.debugNetworkInspectorIconData,
            title: 'Network Inspector',
            onTab: () {
              _showDebugNetworkInspector(context);
            },
          ),
      ],
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
          size: menuItemIconSize,
          color: iconColor ?? menuItemIconColor,
        ),
        title: Text(title),
        onTap: onTab,
      ),
    );
  }

  PopupMenuItem _divider() {
    return const PopupMenuItem(
      height: 4,
      child: Divider(height: 2),
    );
  }

  Future<void> _showDebugUiContextInspector(BuildContext context) async {
    Navigator.pop(context, null);
    await FlutterArtist.showDebugUiContextInspector();
  }

  Future<void> _showDebugNetworkInspector(BuildContext context) async {
    Navigator.pop(context, null);
    FlutterArtist.showDebugNetworkInspector!(context);
  }

  Future<void> _showDebugAppInspectorDialog(BuildContext context) async {
    Navigator.pop(context, null);
    await FlutterArtist.showDebugAppInspectorDialog();
  }

  Future<void> _showDebugThemeInspector(BuildContext context) async {
    Navigator.pop(context, null);
    await FlutterArtist.showDebugThemeInspector();
  }

  void _clearCodeFlow(BuildContext context) {
    Navigator.pop(context, null);
    FlutterArtist.codeFlowLogger.clear();
  }

  Future<void> _showCodeFlowInspector(BuildContext context) async {
    Navigator.pop(context, null);
    await FlutterArtist.showCodeFlowInspector();
  }

  Future<void> _showDebugShelfStructureInspector(BuildContext context) async {
    Navigator.pop(context, null);
    await FlutterArtist.showDebugShelfStructureInspector();
  }

  Future<void> _showLogViewerDialog(BuildContext context) async {
    Navigator.pop(context, null);
    // docs: [14545].
    await FlutterArtist.showLogViewerDialog();
  }
}
