import 'package:flutter/material.dart';
import 'package:flutter_artist_core/flutter_artist_core.dart';
import 'package:flutter_artist_styles/flutter_artist_styles.dart';
import 'package:tabbed_view/tabbed_view.dart';

import '../../core/_core_/core.dart';
import '../../core/icon/icon_constants.dart';
import '../../core/utils/_class_utils.dart';
import '../utils/_tab_theme_utils.dart';
import '../widgets/_html_info_view.dart';
import '_debug_block_criteria_view.dart';
import '_debug_scalar_criteria_view.dart';

class DebugFilterModelCriteriaView extends StatefulWidget {
  final FilterModel filterModel;

  const DebugFilterModelCriteriaView({super.key, required this.filterModel});

  @override
  State<StatefulWidget> createState() {
    return _DebugFilterModelCriteriaViewState();
  }
}

class _DebugFilterModelCriteriaViewState
    extends State<DebugFilterModelCriteriaView> {
  late TabbedViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TabbedViewController(_getTabs());
  }

  @override
  void didUpdateWidget(covariant DebugFilterModelCriteriaView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.filterModel != oldWidget.filterModel) {
      _controller.setTabs(_getTabs());
    }
  }

  List<TabData> _getTabs() {
    List<TabData> tabs = [];

    for (Block block in widget.filterModel.blocks) {
      tabs.add(
        TabData(
          id: "block-${block.name}",
          text: ' ${getClassNameWithoutGenerics(block)}',
          closable: false,
          leading: (context, status) => Icon(
            FaIconConstants.blockIconData,
            color: TabThemeUtils.getTabIconColor(context, status),
            size: 16,
          ),
          view: DebugBlockCriteriaView(block: block),
        ),
      );
    }
    for (Scalar scalar in widget.filterModel.scalars) {
      tabs.add(
        TabData(
          id: "scalar-${scalar.name}",
          text: ' ${getClassNameWithoutGenerics(scalar)}',
          closable: false,
          leading: (context, status) => Icon(
            FaIconConstants.scalarIconData,
            color: TabThemeUtils.getTabIconColor(context, status),
            size: 16,
          ),
          view: DebugScalarCriteriaView(scalar: scalar),
        ),
      );
    }
    return tabs;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    String filterModelClassName =
        getClassNameWithoutGenerics(widget.filterModel);
    String criteriaClassName =
        widget.filterModel.getFilterCriteriaType().toString();

    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCriteriaShortDocument(
            context: context,
            filterModelClassName: filterModelClassName,
            criteriaClassName: criteriaClassName,
          ),
          const SizedBox(height: 12),
          Expanded(
            child: TabbedViewTheme(
              data: TabThemeUtils.getTabbedViewThemeData(context),
              child: TabbedView(controller: _controller),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCriteriaShortDocument({
    required BuildContext context,
    required String filterModelClassName,
    required String criteriaClassName,
  }) {
    return HtmlInfoView(
      infoAsHtml: "The <b>$criteriaClassName</b> object is created by the "
          "<b>$filterModelClassName.createNewFilterCriteria()</b> method, and can be retrieved via the "
          "<b>$filterModelClassName.filterCriteria</b> property. "
          "It is used as criteria to query data on the following blocks and scalars:",
      style: TextStyle(
        fontSize: 13,
        color: context.faColors.ink.label,
      ),
    );
  }
}
