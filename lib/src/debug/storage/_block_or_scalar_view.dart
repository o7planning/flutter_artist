import 'package:flutter/material.dart';
import 'package:flutter_artist_commons_ui/flutter_artist_commons_ui.dart';
import 'package:tabbed_view/tabbed_view.dart';

import '../../core/_core_/core.dart';
import '../../core/enums/_tip_document.dart';
import '../../core/icon/icon_constants.dart';
import '../dialog/_tip_document_viewer_dialog.dart';
import '../shelf/widget/_block_or_scalar_info_view.dart';
import '../shelf/widget/_shelf_info_view.dart';
import '../state_view/_debug_block_state_view.dart';
import '../state_view/_debug_fa_route_view.dart';
import '../state_view/_debug_scalar_state_view.dart';
import '../state_view/options/_debug_block_options.dart';
import '../state_view/options/_debug_form_options.dart';
import '../state_view/options/_debug_pagination_options.dart';
import '../state_view/options/_debug_scalar_options.dart';
import '../utils/_tab_theme_utils.dart';
import '_block_or_scalar.dart';

class BlockOrScalarView extends StatefulWidget {
  final BlockOrScalar blockOrScalar;

  const BlockOrScalarView({required this.blockOrScalar, super.key});

  @override
  State<BlockOrScalarView> createState() => _BlockOrScalarViewState();
}

class _BlockOrScalarViewState extends State<BlockOrScalarView> {
  late TabbedViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TabbedViewController(_getTabs());
  }

  @override
  void didUpdateWidget(covariant BlockOrScalarView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.blockOrScalar != oldWidget.blockOrScalar) {
      int currentIndex = _controller.selectedIndex ?? 0;
      _controller.setTabs(_getTabs());
      _controller.selectedIndex = currentIndex;
    }
  }

  List<TabData> _getTabs() {
    return [
      TabData(
        text: ' General',
        closable: false,
        leading: (context, status) =>
            const Icon(Icons.apps, color: Colors.indigo, size: 16),
        content: _buildTab1(context),
      ),
      TabData(
        text: ' Debug',
        closable: false,
        leading: (context, status) =>
            const Icon(Icons.bug_report, color: Colors.black, size: 16),
        content: _buildTab2(),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return TabbedViewTheme(
      data: TabThemeUtils.getTabbedViewThemeData(),
      child: TabbedView(controller: _controller),
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

  Widget _buildTab1(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ShelfInfoView(shelf: widget.blockOrScalar.shelf),
          const Divider(),
          BlockOrScalarInfoView(
            blockOrScalar: widget.blockOrScalar,
          ),
          const Divider(),
          _buildControlBar(context),
          SizedBox(height: 10),
          if (widget.blockOrScalar.block != null)
            DebugBlockStateView(
              block: widget.blockOrScalar.block!,
              vertical: false,
              debugBlockOptions: DebugBlockOptions(),
              debugFormOptions: DebugFormOptions(),
              debugPaginationOptions: DebugPaginationOptions(),
            ),
          if (widget.blockOrScalar.scalar != null)
            DebugScalarStateView(
              scalar: widget.blockOrScalar.scalar!,
              vertical: false,
              debugScalarOptions: DebugScalarOptions(),
            ),
        ],
      ),
    );
  }

  Widget _buildTab2() {
    return FARouteDebugger(
      routes: widget.blockOrScalar.faRoutes.toList(),
    );
  }
}
