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
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _controller = TabbedViewController(_getTabs());
      _initialized = true;
    } else {
      _controller.setTabs(_getTabs());
    }
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
        id: "General",
        text: ' General',
        closable: false,
        leading: (context, status) => Icon(
          Icons.apps,
          color: TabThemeUtils.getTabIconColor(context, status),
          size: 16,
        ),
        view: _buildGeneralTab(context),
      ),
      TabData(
        id: "Debug",
        text: ' Debug',
        closable: false,
        leading: (context, status) => Icon(
          Icons.bug_report,
          color: TabThemeUtils.getTabIconColor(context, status),
          size: 16,
        ),
        view: _buildDebugTab(),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return TabbedViewTheme(
      data: TabThemeUtils.getTabbedViewThemeData(context),
      child: TabbedView(controller: _controller),
    );
  }

  Widget _buildControlBar(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: double.maxFinite,
      margin: EdgeInsets.zero,
      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        children: [
          Text(
            "ACTIONS",
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface.withValues(alpha: 0.4),
              letterSpacing: 1.1,
            ),
          ),
          const Spacer(),
          Tooltip(
            message: "Tip & Document",
            child: SimpleSmallIconButton(
              iconData: FaIconConstants.tipDocument,
              iconSize: 14,
              iconColor: colorScheme.tertiary,
              onPressed: () {
                TipDocumentViewerDialog.show(
                  context: context,
                  tipDocument: TipDocument.debugState,
                );
              },
            ),
          )
        ],
      ),
    );
  }

  Widget _buildGeneralTab(BuildContext context) {
    return SingleChildScrollView(
      key: PageStorageKey('GeneralTab-${widget.blockOrScalar.hashCode}'),
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

  Widget _buildDebugTab() {
    return FARouteDebugger(
      routes: widget.blockOrScalar.faRoutes.toList(),
    );
  }
}
