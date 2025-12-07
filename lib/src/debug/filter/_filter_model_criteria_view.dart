import 'package:flutter/material.dart';

import '../../core/_core_/core.dart';
import '../../core/utils/_class_utils.dart';
import '../widgets/_html_info_view.dart';
import '_blocks_scalars_view.dart';
import '_criteria_values_info_view.dart';

class FilterModelCriteriaView extends StatelessWidget {
  final FilterModel filterModel;

  const FilterModelCriteriaView({super.key, required this.filterModel});

  @override
  Widget build(BuildContext context) {
    String filterModelClassName = getClassName(filterModel);
    String criteriaClassName = filterModel.getFilterCriteriaType().toString();
    FilterCriteria? filterCriteria = filterModel.filterCriteria;
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
          BlocksScalarsView(
            filterModel: filterModel,
          ),
          Divider(),
          CriteriaValuesView(
            filterCriteria: filterCriteria,
            filterCriteriaPath: "$filterModelClassName.filterCriteria",
          ),
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
          "It is used as criteria to query data on the following blocks and scales:",
    );
  }
}
