import 'package:flutter/material.dart';

import '../../core/_core/code.dart';
import '../constants/_debug_constants.dart';

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
        SelectableText.rich(
          style: TextStyle(fontSize: DebugConstants.graphBoxFontSizeRootBox),
          TextSpan(
            children: [
              TextSpan(text: "Data of "),
              TextSpan(
                text: filterCriteriaPath,
                style: TextStyle(
                  color: Colors.indigo,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextSpan(text: ":"),
            ],
          ),
        ),
        SizedBox(height: 5),
        if (filterCriteria != null)
          SelectableText.rich(
            TextSpan(
              style: TextStyle(
                fontSize: 11,
                fontStyle: FontStyle.normal,
              ),
              children: [
                TextSpan(text: "(This debug information is returned from the "),
                TextSpan(
                  text: "${getClassName(filterCriteria)}.getDebugInfos()",
                  style: TextStyle(
                    color: Colors.indigo,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(text: " method)."),
              ],
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
