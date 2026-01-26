import 'package:flutter/material.dart';
import 'package:flutter_artist_core/flutter_artist_core.dart';
import 'package:tabbed_view/tabbed_view.dart';

import '../../core/_core_/core.dart';
import '../../core/icon/icon_constants.dart';
import '../../core/utils/_class_utils.dart';
import '../utils/_tab_theme_utils.dart';
import '../widgets/_html_info_view.dart';

@Deprecated("Xoa di")
class CriteriaValuesView extends StatelessWidget {
  final String filterCriteriaPath;
  final XFilterCriteria? xFilterCriteria;

  static const double fontSize = 11;

  const CriteriaValuesView({
    super.key,
    required this.xFilterCriteria,
    required this.filterCriteriaPath,
  });

  @override
  Widget build(BuildContext context) {
    final FilterCriteria? filterCriteria = xFilterCriteria?.filterCriteria;
    final Map<String, dynamic>? filterCriteriaMap =
        xFilterCriteria?.filterCriteriaMap;
    List<String> criteriaValueInfos =
        filterCriteria?.getDebugCriterionInfos() ?? [];
    final oneLevelJson = MapUtils.toOneLevelJson(filterCriteriaMap ?? {});
    //
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HtmlInfoView(
          showIcon: false,
          infoAsHtml:
              "Data of <b>$filterCriteriaPath</b> (<b>${getClassNameWithoutGenerics(filterCriteria)}</b>):",
          style: TextStyle(fontSize: 13),
        ),
        SizedBox(height: 5),
        Expanded(child: _buildTabs()),
      ],
    );
  }

  Widget _buildTabs() {
    List<TabData> tabs = [];

    tabs.add(
      TabData(
        text: ' Form Props Structure',
        closable: false,
        leading: (context, status) => Icon(
          FaIconConstants.formValueIconData,
          color: Colors.black,
          size: 16,
        ),
        content: Text("Test"),
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
    //
    return tabbedViewTheme;
  }
}
