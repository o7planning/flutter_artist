import 'package:flutter/material.dart';
import 'package:flutter_artist_commons_ui/flutter_artist_commons_ui.dart';

import '../_debug_/_debug_constants.dart';
import '../_debug_/_shelf_structure_graph_view.dart';
import '../_debug_/_storage_structure_view.dart';
import '../_dialog_size.dart';
import '../../widgets/_custom_app_container.dart';
import '../../core/_fa_core.dart';

class StorageDialog extends StatefulWidget {
  final Shelf? shelf;

  const StorageDialog({
    required this.shelf,
    super.key,
  });

  @override
  State<StorageDialog> createState() {
    return _StorageDialogState();
  }

  static Future<void> showStorageDialog({
    required BuildContext context,
    required Shelf? shelf,
  }) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return StorageDialog(shelf: shelf);
      },
    );
  }
}

class _StorageDialogState extends State<StorageDialog> {
  Shelf? _currentShelf;

  @override
  void initState() {
    super.initState();
    FlutterArtist.storage.debugLoadAll();
    _currentShelf = widget.shelf;
  }

  @override
  Widget build(BuildContext context) {
    Size size = DialogSizeUtils.calculateDebugDialogSize(context);

    Widget contentWidget = CustomAppContainer(
      padding: const EdgeInsets.all(2),
      width: size.width,
      height: size.height,
      child: _buildMainWidget(),
    );

    FaAlertDialog alert = FaAlertDialog(
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
            ? StorageStructureView(
                onSelectShelfToShowGraph: _setDetailedShelf,
              )
            : ShelfStructureGraphView(
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
          child: Text(
            "Storage Graph",
            style: TextStyle(
              fontSize: DebugConstants.graphBoxFontSizeChildBox,
              color: DebugConstants.graphBoxTextColor,
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
