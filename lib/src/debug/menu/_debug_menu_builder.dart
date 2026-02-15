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
        if (isSystemUser &&
            FlutterArtist.canShowDebugShelfStructureViewerDialog())
          _buildPopupMenuItem(
            iconData: FaIconConstants.shelfStructureIconData,
            title: 'Shelf Structure Viewer',
            onTab: () {
              _showDebugShelfStructureViewer(context);
            },
          ),
        if (isSystemUser && FlutterArtist.debugCanShowUiComponentDialog())
          _buildPopupMenuItem(
            iconData: FaIconConstants.uiComponentsIconData,
            title: 'UI Components Viewer',
            onTab: () {
              _showUiComponentsDialog(context);
            },
          ),
        if (isSystemUser)
          _buildPopupMenuItem(
            iconData: FaIconConstants.storageIconData,
            title: 'Storage Viewer',
            onTab: () {
              _showDebugStorageViewerDialog(context);
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
            title: 'Code Flow Viewer',
            onTab: () {
              _showFlowLogStructure(context);
            },
          ),
        if (isSystemUser) _divider(),
        if (isSystemUser && FlutterArtist.showRestDebugViewerDialog != null)
          _buildPopupMenuItem(
            iconData: FaIconConstants.restDebugIconData,
            title: 'Rest Debug Viewer',
            onTab: () {
              _showRestDebugViewerDialog(context);
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

  Future<void> _showUiComponentsDialog(BuildContext context) async {
    Navigator.pop(context, null);
    await FlutterArtist.storage.showDebugFaUiComponentsViewerDialog();
  }

  Future<void> _showRestDebugViewerDialog(BuildContext context) async {
    Navigator.pop(context, null);
    FlutterArtist.showRestDebugViewerDialog!(context);
  }

  Future<void> _showDebugStorageViewerDialog(BuildContext context) async {
    Navigator.pop(context, null);
    await FlutterArtist.storage.showDebugStorageViewerDialog();
  }

  void _clearCodeFlow(BuildContext context) {
    Navigator.pop(context, null);
    FlutterArtist.codeFlowLogger.clear();
  }

  Future<void> _showFlowLogStructure(BuildContext context) async {
    Navigator.pop(context, null);
    await FlutterArtist.showCodeFlowViewerDialog();
  }

  Future<void> _showDebugShelfStructureViewer(BuildContext context) async {
    Navigator.pop(context, null);
    await FlutterArtist.showDebugShelfStructureViewerDialog();
  }

  Future<void> _showLogViewerDialog(BuildContext context) async {
    Navigator.pop(context, null);
    // docs: [14545].
    await FlutterArtist.showLogViewerDialog();
  }
}
