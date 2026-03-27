import 'package:flutter/material.dart';
import 'package:tabbed_view/tabbed_view.dart';

import '../../core/_core_/core.dart';
import '../../core/icon/icon_constants.dart';
import '../../core/utils/_class_utils.dart';
import '../utils/_tab_theme_utils.dart';
import '__debug_filter_criteria_view.dart';
import '_debug_filter_model_criteria_view.dart';

class DebugFilterCriteriaView extends StatefulWidget {
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
  State<StatefulWidget> createState() {
    return _DebugFilterCriteriaViewState();
  }
}

class _DebugFilterCriteriaViewState extends State<DebugFilterCriteriaView> {
  late TabbedViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TabbedViewController(_getTabs());
    _controller.selectedIndex = 0;
  }

  List<TabData> _getTabs() {
    List<TabData> tabs = [];
    if (widget.filterCriteria != null) {
      tabs.add(
        TabData(
          id: "filterCriteria",
          text: getClassNameWithoutGenerics(widget.filterCriteria!),
          closable: false,
          leading: (context, status) => Icon(
            FaIconConstants.filterCriteriaIconData,
            color: TabThemeUtils.getTabIconColor(context, status),
            size: 16,
          ),
          view: FilterCriteriaView(
            filterModel: widget.filterModel,
            onDebugFilterModelPressed: widget.onDebugFilterModelPressed,
          ),
        ),
      );
    }
    tabs.add(
      TabData(
        id: "filterModel",
        text: getClassNameWithoutGenerics(widget.filterModel),
        closable: false,
        leading: (context, status) => Icon(
          FaIconConstants.filterModelIconData,
          color: TabThemeUtils.getTabIconColor(context, status),
          size: 16,
        ),
        view: DebugFilterModelCriteriaView(
          filterModel: widget.filterModel,
        ),
      ),
    );
    return tabs;
  }

  @override
  Widget build(BuildContext context) {
    return TabbedViewTheme(
      data: TabThemeUtils.getTabbedViewThemeData(context),
      child: TabbedView(controller: _controller),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}
