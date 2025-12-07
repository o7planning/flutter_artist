import 'package:flutter/material.dart';
import 'package:flutter_artist/src/debug/widgets/_html_info_view.dart';

import '../../core/_core_/core.dart';
import '../../core/built_in/empty_filter_criteria.dart';
import '../../core/utils/_class_utils.dart';
import '_criteria_values_info_view.dart';

abstract class BlkOrScrCriteriaView extends StatelessWidget {
  const BlkOrScrCriteriaView({super.key});

  String getBlockOrScalarClassName();

  String? getFilterModelClassName();

  FilterCriteria? getFilterCriteria();

  @override
  Widget build(BuildContext context) {
    String? filterModelClassName = getFilterModelClassName();
    FilterCriteria? filterCriteria = getFilterCriteria();
    String? criteriaClassName =
        filterCriteria == null ? null : getClassName(filterCriteria);
    //
    return Padding(
      padding: EdgeInsets.all(5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (filterModelClassName == null) //
            _showNoFilterModelInfo(),
          _buildCriteriaShortDocument(
            filterModelClassName: filterModelClassName,
            criteriaClassName: criteriaClassName,
          ),
          if (criteriaClassName != null) Divider(),
          if (filterCriteria != null)
            CriteriaValuesView(
              filterCriteria: filterCriteria,
              filterCriteriaPath:
                  "${getBlockOrScalarClassName()}.data.filterCriteria",
            ),
        ],
      ),
    );
  }

  Widget _showNoFilterModelInfo() {
    return HtmlInfoView(
      showIcon: false,
      infoAsHtml:
          "<b>${getBlockOrScalarClassName()}</b> is using <b>$EmptyFilterCriteria</b>.",
    );
  }

  Widget _buildCriteriaShortDocument({
    required String? filterModelClassName,
    required String? criteriaClassName,
  }) {
    if (criteriaClassName == null) {
      return HtmlInfoView(infoAsHtml: "<b>filterCriteria</b> is <b>null</b>.");
    } else {
      return HtmlInfoView(
        infoAsHtml:
            "<b>$criteriaClassName</b> is used as the criteria for filtering data on "
            "<b>${getBlockOrScalarClassName()}</b>. It is created by <b>$filterModelClassName.toFilterCriteriaObject()</b> "
            "and can be retrieved via <b>${getBlockOrScalarClassName()}.filterCriteria</b> property.",
      );
    }
  }
}
