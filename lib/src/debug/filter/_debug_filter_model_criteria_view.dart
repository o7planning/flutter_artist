import 'package:flutter/material.dart';
import 'package:tabbed_view/tabbed_view.dart';

import '../../core/_core_/core.dart';
import '../../core/icon/icon_constants.dart';
import '../../core/utils/_class_utils.dart';
import '../utils/_tab_theme_utils.dart';
import '../widgets/_html_info_view.dart';
import '_debug_block_criteria_view.dart';
import '_debug_scalar_criteria_view.dart';

class DebugFilterModelCriteriaView extends StatelessWidget {
  final FilterModel filterModel;

  const DebugFilterModelCriteriaView({super.key, required this.filterModel});

  @override
  Widget build(BuildContext context) {
    String filterModelClassName = getClassNameWithoutGenerics(filterModel);
    String criteriaClassName = filterModel.getFilterCriteriaType().toString();
    XFilterCriteria? xFilterCriteria = filterModel.debugXFilterCriteria;
    //
    return Padding(
      padding: EdgeInsets.all(5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCriteriaShortDocument(
            filterModelClassName: filterModelClassName,
            criteriaClassName: criteriaClassName,
          ),
          SizedBox(height: 10),
          Expanded(child: _buildTabs()),
        ],
      ),
    );
  }

  Widget _buildCriteriaShortDocument({
    required String filterModelClassName,
    required String criteriaClassName,
  }) {
    return HtmlInfoView(
      infoAsHtml: "The <b>$criteriaClassName</b> object is created by the "
          "<b>$filterModelClassName.toFilterCriteriaObject()</b> method, and can be retrieved via the "
          "<b>$filterModelClassName.filterCriteria</b> property. "
          "It is used as criteria to query data on the following blocks and scalars:",
      style: TextStyle(fontSize: 13),
    );
  }

  Widget _buildTabs() {
    List<TabData> tabs = [];

    for (Block block in filterModel.blocks) {
      tabs.add(
        TabData(
          text: ' ${getClassNameWithoutGenerics(block)}',
          closable: false,
          leading: (context, status) => Icon(
            FaIconConstants.blockIconData,
            color: Colors.black,
            size: 16,
          ),
          content: DebugBlockCriteriaView(block: block),
        ),
      );
    }
    for (Scalar scalar in filterModel.scalars) {
      tabs.add(
        TabData(
          text: ' ${getClassNameWithoutGenerics(scalar)}',
          closable: false,
          leading: (context, status) => Icon(
            FaIconConstants.scalarIconData,
            color: Colors.black,
            size: 16,
          ),
          content: DebugScalarCriteriaView(scalar: scalar),
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
    //
    return tabbedViewTheme;
  }
}
