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
      items: <PopupMenuEntry>[
        if (hasLogs)
          _buildPopupMenuItem(
            iconData: FaIconConstants.errorIconData,
            iconColor: Theme.of(context).colorScheme.error,
            title: 'Log Viewer',
            onTap: () {
              _showLogViewerDialog(context);
            },
          ),
        if (isSystemUser && hasLogs) _divider(),
        if (isSystemUser)
          _buildPopupMenuItem(
            iconData: FaIconConstants.appIconData,
            title: 'App Inspector',
            onTap: () {
              _showDebugAppInspectorDialog(context);
            },
          ),
        if (isSystemUser && FlutterArtist.canShowDebugShelfStructureInspector())
          _buildPopupMenuItem(
            iconData: FaIconConstants.shelfStructureIconData,
            title: 'Shelf Structure Inspector',
            onTap: () {
              _showDebugShelfStructureInspector(context);
            },
          ),
        if (isSystemUser && FlutterArtist.debugCanShowUiComponentDialog())
          _buildPopupMenuItem(
            iconData: FaIconConstants.uiComponentsIconData,
            title: 'UI Context Inspector',
            onTap: () {
              _showDebugUiContextInspector(context);
            },
          ),
        if (isSystemUser)
          _buildPopupMenuItem(
            iconData: FaIconConstants.themeIconData,
            title: 'Theme Inspector',
            onTap: () {
              _showDebugThemeInspector(context);
            },
          ),
        if (isSystemUser) _divider(),
        if (isSystemUser)
          _buildPopupMenuItem(
            iconData: FaIconConstants.flowLogIconData,
            title: 'Code Flow Inspector',
            onTap: () {
              _showCodeFlowInspector(context);
            },
            trainingIconData: FaIconConstants.clearCodeFlowIconData,
            // trainingIconColor: Theme.of(context).colorScheme.primary,
            trainingCallback: () {
              _clearCodeFlowLogger(context);
            },
          ),
        if (isSystemUser) _divider(),
        if (isSystemUser && FlutterArtist.showDebugNetworkInspector != null)
          _buildPopupMenuItem(
            iconData: FaIconConstants.debugNetworkInspectorIconData,
            title: 'Network Inspector',
            onTap: () {
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
    required Function() onTap,
    IconData? trainingIconData,
    Color? trainingIconColor,
    VoidCallback? trainingCallback,
  }) {
    return PopupMenuItem(
      padding: EdgeInsets.all(0),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 8),
        leading: Icon(
          iconData,
          size: menuItemIconSize,
          color: iconColor ?? menuItemIconColor,
        ),
        trailing: trainingIconData == null
            ? null
            : IconButton(
                icon: Icon(
                  trainingIconData,
                  size: menuItemIconSize,
                  color: trainingIconColor,
                ),
                tooltip: "Clear Data",
                onPressed: trainingCallback,
              ),
        title: SizedBox(
          width: 180,
          child: Text(
            title,
            maxLines: 1,
          ),
        ),
        onTap: onTap,
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
    await FlutterArtist.showDebugNetworkInspector();
  }

  Future<void> _showDebugAppInspectorDialog(BuildContext context) async {
    Navigator.pop(context, null);
    await FlutterArtist.showDebugAppInspectorDialog();
  }

  Future<void> _showDebugThemeInspector(BuildContext context) async {
    Navigator.pop(context, null);
    await FlutterArtist.showDebugThemeInspector();
  }

  void _clearCodeFlowLogger(BuildContext context) {
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
