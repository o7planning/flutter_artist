import 'package:flutter/material.dart';
import 'package:tabbed_view/tabbed_view.dart';

import '../../core/_core_/core.dart';
import '../../core/icon/icon_constants.dart';
import '../../core/utils/_class_utils.dart';
import '../utils/_tab_theme_utils.dart';
import '__debug_filter_criteria_view.dart';
import '_debug_filter_model_criteria_view.dart';

class DebugFilterCriteriaView extends StatelessWidget {
  final Block? block;
  final Scalar? scalar;
  final FilterModel filterModel;
  final FilterCriteria? filterCriteria;
  final Function() onDebugFilterModelPressed;

  DebugFilterCriteriaView.block({
    super.key,
    required Block this.block,
    required this.onDebugFilterModelPressed,
  })  : filterCriteria = block.registeredOrDefaultFilterModel.filterCriteria,
        scalar = null,
        filterModel = block.registeredOrDefaultFilterModel;

  DebugFilterCriteriaView.scalar({
    super.key,
    required Scalar this.scalar,
    required this.onDebugFilterModelPressed,
  })  : filterCriteria = scalar.registeredOrDefaultFilterModel.filterCriteria,
        block = null,
        filterModel = scalar.registeredOrDefaultFilterModel;

  DebugFilterCriteriaView.filterModel({
    super.key,
    required FilterModel this.filterModel,
    required this.onDebugFilterModelPressed,
  })  : filterCriteria = filterModel.filterCriteria,
        block = null,
        scalar = null;

  @override
  Widget build(BuildContext context) {
    List<TabData> tabs = [];
    //
    if (filterCriteria != null) {
      tabs.add(
        TabData(
          text: getClassNameWithoutGenerics(filterCriteria!),
          closable: false,
          leading: (context, status) => Icon(
            FaIconConstants.filterCriteriaIconData,
            color: Colors.indigo,
            size: 16,
          ),
          content: FilterCriteriaView(
            filterModel: filterModel,
            onDebugFilterModelPressed: onDebugFilterModelPressed,
          ),
        ),
      );
    }
    tabs.add(
      TabData(
        text: getClassNameWithoutGenerics(filterModel),
        closable: false,
        leading: (context, status) => Icon(
          FaIconConstants.filterModelIconData,
          color: Colors.indigo,
          size: 16,
        ),
        content: DebugFilterModelCriteriaView(
          filterModel: filterModel,
        ),
      ),
    );
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
