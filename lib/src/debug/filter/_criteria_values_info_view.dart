import 'package:flutter/material.dart';
import 'package:flutter_artist/src/debug/widgets/_json_view.dart';
import 'package:flutter_artist_core/flutter_artist_core.dart';

import '../../core/_core_/core.dart';
import '../../core/utils/_class_utils.dart';
import '../constants/_debug_constants.dart';
import '../widgets/_html_info_view.dart';

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
    List<String> criteriaValueInfos = filterCriteria?.getDebugInfos() ?? [];
    final oneLevelJson = MapUtils.toOneLevelJson(filterCriteriaMap ?? {});
    //
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HtmlInfoView(
          showIcon: false,
          infoAsHtml: "Data of <b>$filterCriteriaPath</b>:",
        ),
        SizedBox(height: 5),
        if (filterCriteria != null)
          HtmlInfoView(
            showIcon: false,
            infoAsHtml: "(This debug information is returned from the "
                "<b>${getClassNameWithoutGenerics(filterCriteria)}.getDebugInfos()</b> method).",
            style: TextStyle(
              fontSize: 11,
              fontStyle: FontStyle.normal,
            ),
          ),
        SizedBox(height: 10),
        ...criteriaValueInfos.map(
          (line) => ListTile(
            minLeadingWidth: 0,
            minVerticalPadding: 0,
            minTileHeight: 0,
            dense: true,
            visualDensity: VisualDensity(vertical: -3, horizontal: -3),
            contentPadding: EdgeInsets.zero,
            leading: Icon(
              Icons.arrow_circle_right_outlined,
              size: 14,
            ),
            title: Text(
              line,
              style: TextStyle(fontSize: DebugConstants.debugFontSize),
            ),
          ),
        ),
        if (filterCriteria == null)
          Text(
            "Filter Criteria is null",
            style: TextStyle(
              fontSize: DebugConstants.debugFontSize,
              fontStyle: FontStyle.normal,
            ),
          ),
        if (filterCriteriaMap != null && filterCriteriaMap.isNotEmpty)
          Divider(),
        if (filterCriteriaMap != null && filterCriteriaMap.isNotEmpty)
          Text(
            "Original Filter Criteria as Map<String,dynamic>:",
            style: TextStyle(
              fontSize: DebugConstants.debugFontSize,
              fontWeight: FontWeight.bold,
            ),
          ),
        if (filterCriteriaMap != null && filterCriteriaMap.isNotEmpty)
          SizedBox(height: 5),
        if (filterCriteriaMap != null && filterCriteriaMap.isNotEmpty)
          JsonView(
            json: oneLevelJson,
          ),
      ],
    );
  }
}
