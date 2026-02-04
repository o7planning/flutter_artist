import 'package:flutter/material.dart';
import 'package:flutter_artist_commons_ui/flutter_artist_commons_ui.dart';

import '../../core/_core_/core.dart';
import '../../core/utils/_class_utils.dart';
import '../state_view/_debug_scalar_state_view.dart';
import '../state_view/options/_debug_scalar_options.dart';
import '../widgets/_html_info_view.dart';

class DebugScalarCriteriaView extends StatelessWidget {
  final Scalar scalar;

  const DebugScalarCriteriaView({super.key, required this.scalar});

  @override
  Widget build(BuildContext context) {
    FilterModel filterModel = scalar.registeredOrDefaultFilterModel;
    String scalarClassName = getClassNameWithoutGenerics(scalar);
    String filterClassName = getClassNameWithoutGenerics(filterModel);
    //
    return Padding(
      padding: EdgeInsets.all(5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCriteriaShortDocument(
            filterClassName: filterClassName,
            scalarClassName: scalarClassName,
          ),
          SizedBox(height: 10),
          IconLabelSelectableText(
            icon: Icon(
              Icons.arrow_circle_right_outlined,
              size: 14,
            ),
            label: "$scalarClassName.filterCriteria: ",
            text: scalar.filterCriteria == null ? "null" : "not null",
            labelStyle: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
            textStyle: TextStyle(
              fontSize: 13,
              color: scalar.filterCriteria == null ? Colors.red : Colors.indigo,
            ),
          ),
          SizedBox(height: 10),
          Expanded(
            child: SingleChildScrollView(
              child: DebugScalarStateView(
                scalar: scalar,
                vertical: false,
                debugScalarOptions: DebugScalarOptions(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCriteriaShortDocument({
    required String filterClassName,
    required String scalarClassName,
  }) {
    return HtmlInfoView(
      infoAsHtml:
          "The <b>$filterClassName.filterCriteria</b> is used as a parameter to query the <b>$scalarClassName</b>. "
          "If successful, it will be assigned to <b>$scalarClassName.filterCriteria</b>. "
          "Otherwise, the <b>$scalarClassName.filterCriteria</b> can be set to <b>null</b>. "
          "The <b>$scalarClassName.filterCriteria</b> can also be <b>null</b> "
          "if the <b>$scalarClassName</b> is in the <b>'none'</b> or <b>'pending'</b> state.",
      style: TextStyle(fontSize: 13),
    );
  }
}
