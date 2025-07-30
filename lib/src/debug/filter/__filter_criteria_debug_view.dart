import 'package:flutter/material.dart';
import 'package:tabbed_view/tabbed_view.dart';

import '../../core/_core/code.dart';
import '../../core/icon/icon_constants.dart';
import '../utils/_tab_theme_utils.dart';
import '_block_criteria_view.dart';
import '_filter_model_criteria_view.dart';
import '_scalar_criteria_view.dart';

class FilterCriteriaDebugView extends StatelessWidget {
  final Block? block;
  final Scalar? scalar;
  final FilterModel? filterModel;

  const FilterCriteriaDebugView.block({
    super.key,
    required Block this.block,
  })  : scalar = null,
        filterModel = null;

  const FilterCriteriaDebugView.scalar({
    super.key,
    required Scalar this.scalar,
  })  : block = null,
        filterModel = null;

  const FilterCriteriaDebugView.filterModel({
    super.key,
    required FilterModel this.filterModel,
  })  : block = null,
        scalar = null;

  @override
  Widget build(BuildContext context) {
    List<TabData> tabs = [];
    FilterModel? _filterModel = filterModel;
    if (block != null) {
      _filterModel = block!.filterModel;
      //
      tabs.add(
        TabData(
          text: getClassName(block!),
          closable: false,
          leading: (context, status) => Icon(
            FaIconConstants.blockIconData,
            color: Colors.indigo,
            size: 16,
          ),
          content: SingleChildScrollView(
            child: BlockCriteriaView(
              block: block!,
            ),
          ),
        ),
      );
    }
    if (scalar != null) {
      _filterModel = scalar!.filterModel;
      //
      tabs.add(
        TabData(
          text: getClassName(scalar!),
          closable: false,
          leading: (context, status) => Icon(
            FaIconConstants.scalarIconData,
            color: Colors.indigo,
            size: 16,
          ),
          content: SingleChildScrollView(
            child: ScalarCriteriaView(
              scalar: scalar!,
            ),
          ),
        ),
      );
    }
    if (_filterModel != null) {
      tabs.add(
        TabData(
          text: getClassName(_filterModel),
          closable: false,
          leading: (context, status) => Icon(
            FaIconConstants.filterModelIconData,
            color: Colors.indigo,
            size: 16,
          ),
          content: SingleChildScrollView(
            child: FilterModelCriteriaView(
              filterModel: _filterModel,
            ),
          ),
        ),
      );
    }
    //
    TabbedViewController _controller = TabbedViewController(tabs);
    TabbedView tabbedView = TabbedView(controller: _controller);

    TabbedViewThemeData themeData = TabThemeUtils.getTabbedViewThemeData();

    TabbedViewTheme tabbedViewTheme = TabbedViewTheme(
      data: themeData,
      child: tabbedView,
    );
    return tabbedViewTheme;
  }
}
