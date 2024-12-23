part of '../flutter_artist.dart';

class DebugMenu extends StatefulWidget {
  final double menuItemIconSize;
  final Color? menuItemIconColor;
  final Widget Function({required int errorCount}) menuButtonBuilder;
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
    return _DebugMenuState();
  }
}

class _DebugMenuState extends State<DebugMenu> implements FluErrorListener {
  @override
  void initState() {
    super.initState();
    Storage.addErrorListener(this);
  }

  @override
  void onError() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    ILoggedInUser? loggedInUser = Storage.loggedInUser;
    bool hasRecentErrors = Storage.hasRecentErrors();
    bool isSystemUser = loggedInUser?.isSystemUser ?? false;
    //
    return InkWell(
      onTapDown: !isSystemUser && !hasRecentErrors
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
                  if (hasRecentErrors)
                    _buildPopupMenuItem(
                      iconData: _errorIconData,
                      title: 'Recent Errors',
                      onTab: _showRecentErrors,
                    ),
                  if (isSystemUser && hasRecentErrors) _divider(),
                  if (isSystemUser && Storage.canShowShelfStructure())
                    _buildPopupMenuItem(
                      iconData: _shelfStructureIconData,
                      title: 'Shelf Structure',
                      onTab: _showFluStructure,
                    ),
                  if (isSystemUser && Storage._canShowUiComponentDialog())
                    _buildPopupMenuItem(
                      iconData: _uiComponentsIconData,
                      title: 'UI Components',
                      onTab: _showUiComponentsDialog,
                    ),
                  if (isSystemUser)
                    _buildPopupMenuItem(
                      iconData: _storageIconData,
                      title: 'Storage',
                      onTab: _showStorage,
                    ),
                  if (isSystemUser) _divider(),
                  if (isSystemUser)
                    _buildPopupMenuItem(
                      iconData: _clearCodeFlowIconData,
                      title: 'Clear Code Flow',
                      onTab: _clearCodeFlow,
                    ),
                  if (isSystemUser)
                    _buildPopupMenuItem(
                      iconData: _flowLogIconData,
                      title: 'Code Flow Viewer',
                      onTab: _showFlowLogStructure,
                    ),
                  if (isSystemUser) _divider(),
                  if (isSystemUser && Storage._showRestDebugDialog != null)
                    _buildPopupMenuItem(
                      iconData: _restDebugIconData,
                      title: 'Rest Debug Viewer',
                      onTab: () {
                        _showRestDebugDialog();
                      },
                    ),
                ],
              );
            },
      child: widget.menuButtonBuilder(
        errorCount: Storage._totalErrorCount,
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
    required String title,
    required Function() onTab,
  }) {
    return PopupMenuItem(
      child: ListTile(
        leading: Icon(
          iconData,
          size: widget.menuItemIconSize,
          color: widget.menuItemIconColor,
        ),
        title: Text(title),
        onTap: onTab,
      ),
    );
  }

  Future<void> _showUiComponentsDialog() async {
    Navigator.pop(context, null);
    await Storage.showUiComponentsDialog();
  }

  Future<void> _showRestDebugDialog() async {
    Navigator.pop(context, null);
    Storage._showRestDebugDialog!(context);
  }

  Future<void> _showStorage() async {
    Navigator.pop(context, null);
    await Storage.showStorageDialog();
  }

  void _clearCodeFlow() {
    Navigator.pop(context, null);
    Storage.codeFlowLogger.clear();
  }

  Future<void> _showFlowLogStructure() async {
    Navigator.pop(context, null);
    await Storage.showFlowLogDialog();
  }

  Future<void> _showFluStructure() async {
    Navigator.pop(context, null);
    await Storage.showShelfStructure();
  }

  Future<void> _showRecentErrors() async {
    Navigator.pop(context, null);
    await Storage.showRecentErrors();
  }
}
