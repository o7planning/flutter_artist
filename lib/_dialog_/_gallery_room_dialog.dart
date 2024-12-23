part of '../flutter_artist.dart';

// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------

class _GalleryRoomDialog extends StatefulWidget {
  final Frame? frame;

  const _GalleryRoomDialog({
    required this.frame,
    super.key,
  });

  @override
  State<_GalleryRoomDialog> createState() {
    return _GalleryRoomDialogState();
  }
}

class _GalleryRoomDialogState extends State<_GalleryRoomDialog> {
  Frame? _currentFrame;

  @override
  void initState() {
    super.initState();
    FlutterArtist._loadAll();
    _currentFrame = widget.frame;
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
      titleText: _currentFrame == null ? "Gallery Room" : "Frame Structure",
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
        _currentFrame == null
            ? _GalleryStructureView(
                onSelectFrameToShowGraph: _setDetailedFlu,
              )
            : _FrameStructureGraphView(
                frame: _currentFrame!,
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
    Frame? frame,
  ) {
    setState(() {
      _currentFrame = frame;
    });
  }
}

Future<void> _showGalleryRoomDialog({
  required BuildContext context,
  required Frame? frame,
}) async {
  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return _GalleryRoomDialog(frame: frame);
    },
  );
}
