import 'package:flutter/material.dart';
import 'package:flutter_artist/src/core/icon/icon_constants.dart';
import 'package:flutter_artist/src/debug/dialog/_tip_document_viewer_dialog.dart';
import 'package:flutter_artist_commons_ui/flutter_artist_commons_ui.dart';

import '../../core/_core_/core.dart';
import '../../core/enums/_tip_document.dart';
import '../shelf/widget/_block_or_scalar_info_view.dart';
import '../shelf/widget/_shelf_info_view.dart';
import '../state_view/_debug_block_state_view.dart';
import '../state_view/_debug_scalar_state_view.dart';
import '../state_view/options/_debug_block_options.dart';
import '../state_view/options/_debug_form_options.dart';
import '../state_view/options/_debug_pagination_options.dart';
import '../state_view/options/_debug_scalar_options.dart';
import '_block_or_scalar.dart';

class BlockOrScalarView extends StatelessWidget {
  final BlockOrScalar blockOrScalar;

  const BlockOrScalarView({required this.blockOrScalar, super.key});

  @override
  Widget build(BuildContext context) {
    List<ShelfBlockScalarType> listeners = [];
    List<ShelfBlockScalarType> eventSources = [];
    if (blockOrScalar.block != null) {
      listeners = FlutterArtist.storage.ev.getListenerShelfBlockScalarTypes(
        eventBlockOrScalar: BlockOrScalar.block(blockOrScalar.block!),
      );
      eventSources = FlutterArtist.storage.ev.getEventShelfBlockTypes(
        listenerBlockOrScalar: BlockOrScalar.block(blockOrScalar.block!),
      );
    } else if (blockOrScalar.scalar != null) {
      listeners = FlutterArtist.storage.ev.getListenerShelfBlockScalarTypes(
        eventBlockOrScalar: BlockOrScalar.scalar(blockOrScalar.scalar!),
      );
      eventSources = FlutterArtist.storage.ev.getEventShelfBlockTypes(
        listenerBlockOrScalar: BlockOrScalar.scalar(blockOrScalar.scalar!),
      );
    }
    //
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ShelfInfoView(shelf: blockOrScalar.shelf),
          const Divider(),
          BlockOrScalarInfoView(
            blockOrScalar: blockOrScalar,
          ),
          const Divider(),
          _buildControlBar(context),
          SizedBox(height: 10),
          if (blockOrScalar.block != null)
            DebugBlockStateView(
              block: blockOrScalar.block!,
              vertical: false,
              debugBlockOptions: DebugBlockOptions(),
              debugFormOptions: DebugFormOptions(),
              debugPaginationOptions: DebugPaginationOptions(),
            ),
          if (blockOrScalar.scalar != null)
            DebugScalarStateView(
              scalar: blockOrScalar.scalar!,
              vertical: false,
              debugScalarOptions: DebugScalarOptions(),
            ),
        ],
      ),
    );
  }

  Widget _buildControlBar(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      color: Colors.grey[100],
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 2, horizontal: 5),
        child: Row(
          children: [
            Spacer(),
            SimpleSmallIconButton(
              iconData: FaIconConstants.tipDocument,
              iconSize: 14,
              iconColor: Colors.deepOrange,
              onPressed: () {
                TipDocumentViewerDialog.open(
                  context: context,
                  tipDocument: TipDocument.debugState,
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
