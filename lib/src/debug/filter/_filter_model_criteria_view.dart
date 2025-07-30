import 'package:flutter/material.dart';

import '../../core/_core_/core.dart';
import '../../core/utils/_class_utils.dart';
import '../constants/_debug_constants.dart';
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
    return SelectableText.rich(
      style: TextStyle(fontSize: DebugConstants.debugFontSize),
      TextSpan(
        children: [
          TextSpan(text: "The "),
          TextSpan(
            text: criteriaClassName,
            style: TextStyle(
              color: Colors.indigo,
              fontWeight: FontWeight.bold,
            ),
          ),
          TextSpan(text: " object is created by the "),
          TextSpan(
            text: "$filterModelClassName.toFilterCriteriaObject()",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          TextSpan(text: " method, and can be retrieved via the "),
          TextSpan(
            text: "$filterModelClassName.filterCriteria",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          TextSpan(
              text:
                  " property. It is used as criteria to query data on the following blocks and scales:"),
        ],
      ),
    );
  }
}
