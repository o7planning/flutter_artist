part of '../flutter_artist.dart';

// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------

class _StorageDialog extends StatefulWidget {
  final Shelf? shelf;

  const _StorageDialog({
    required this.shelf,
    super.key,
  });

  @override
  State<_StorageDialog> createState() {
    return _StorageDialogState();
  }
}

class _StorageDialogState extends State<_StorageDialog> {
  Shelf? _currentShelf;

  @override
  void initState() {
    super.initState();
    FlutterArtist.storage._loadAll();
    _currentShelf = widget.shelf;
  }

  @override
  Widget build(BuildContext context) {
    Size size = _calculateDebugDialogSize(context);

    Widget contentWidget = _CustomAppContainer(
      padding: const EdgeInsets.all(2),
      width: size.width,
      height: size.height,
      child: _buildMainWidget(),
    );

    dialogs.CustomAlertDialog alert = dialogs.CustomAlertDialog(
      titleText: _currentShelf == null ? "Storage Viewer" : "Shelf Structure",
      content: contentWidget,
      contentPadding: EdgeInsets.zero,
    );
    return alert;
  }

  Widget _buildMainWidget() {
    return Stack(
      children: [
        _currentShelf == null
            ? _StorageStructureView(
                onSelectShelfToShowGraph: _setDetailedShelf,
              )
            : _ShelfStructureGraphView(
                shelf: _currentShelf!,
                onPressedBack: () {
                  _setDetailedShelf(null);
                },
              ),
        Positioned(
          bottom: 10,
          right: 10,
          child: _buildRightBottomButtons(),
        ),
      ],
    );
  }

  Widget _buildRightBottomButtons() {
    return Row(
      children: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            minimumSize: Size.zero,
            padding: const EdgeInsets.all(10),
            backgroundColor: Colors.blue.withAlpha(30),
          ),
          onPressed: null,
          child: const Text(
            "Storage Graph",
            style: TextStyle(
              fontSize: _graphBoxFontSizeChildBox,
              color: _graphBoxTextColor,
            ),
          ),
        ),
      ],
    );
  }

  void _setDetailedShelf(
    Shelf? shelf,
  ) {
    setState(() {
      _currentShelf = shelf;
    });
  }
}

Future<void> _showStorageDialog({
  required BuildContext context,
  required Shelf? shelf,
}) async {
  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return _StorageDialog(shelf: shelf);
    },
  );
}
