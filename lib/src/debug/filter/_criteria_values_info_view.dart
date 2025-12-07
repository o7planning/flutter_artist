import 'package:flutter/material.dart';

import '../../core/_core_/core.dart';
import '../../core/utils/_class_utils.dart';
import '../constants/_debug_constants.dart';
import '../widgets/_html_info_view.dart';

class CriteriaValuesView extends StatelessWidget {
  final String filterCriteriaPath;
  final FilterCriteria? filterCriteria;

  static const double fontSize = 11;

  const CriteriaValuesView({
    super.key,
    required this.filterCriteria,
    required this.filterCriteriaPath,
  });

  @override
  Widget build(BuildContext context) {
    List<String> criteriaValueInfos = filterCriteria?.getDebugInfos() ?? [];
    //
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HtmlInfoView(
          showIcon: false,
          infoAsHtml: "Data of <b>filterCriteriaPath</b>:",
        ),
        SizedBox(height: 5),
        if (filterCriteria != null)
          HtmlInfoView(
            showIcon: false,
            infoAsHtml: "(This debug information is returned from the "
                "<b>${getClassName(filterCriteria)}.getDebugInfos()</b> method).",
            style: TextStyle(
              fontSize: 11,
              fontStyle: FontStyle.normal,
            ),
          ),
        SizedBox(height: 10),
        ...criteriaValueInfos.map(
          (line) => ListTile(
            minLeadingWidth: 0,
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
      ],
    );
  }
}
