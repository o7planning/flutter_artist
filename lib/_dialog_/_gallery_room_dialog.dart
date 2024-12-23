part of '../flutter_artist.dart';

// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------

class _GalleryRoomDialog extends StatefulWidget {
  final Shelf? shelf;

  const _GalleryRoomDialog({
    required this.shelf,
    super.key,
  });

  @override
  State<_GalleryRoomDialog> createState() {
    return _GalleryRoomDialogState();
  }
}

class _GalleryRoomDialogState extends State<_GalleryRoomDialog> {
  Shelf? _currentShelf;

  @override
  void initState() {
    super.initState();
    Storage._loadAll();
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

    AlertDialog alert = _CustomAlertDialog(
      titleText: _currentShelf == null ? "Storage" : "Shelf Structure",
      content: contentWidget,
      contentPadding: EdgeInsets.zero,
      closeDialog: () {
        Navigator.of(context).pop();
      },
    );
    return alert;
  }

  Widget _buildMainWidget() {
    return Stack(
      children: [
        _currentShelf == null
            ? _GalleryStructureView(
                onSelectShelfToShowGraph: _setDetailedFlu,
              )
            : _ShelfStructureGraphView(
                shelf: _currentShelf!,
                onPressedBack: () {
                  _setDetailedFlu(null);
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
            "Global Flu Graph",
            style: TextStyle(
              fontSize: _graphBoxFontSizeChildBox,
              color: _graphBoxTextColor,
            ),
          ),
        ),
      ],
    );
  }

  void _setDetailedFlu(
    Shelf? shelf,
  ) {
    setState(() {
      _currentShelf = shelf;
    });
  }
}

Future<void> _showGalleryRoomDialog({
  required BuildContext context,
  required Shelf? shelf,
}) async {
  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return _GalleryRoomDialog(shelf: shelf);
    },
  );
}
