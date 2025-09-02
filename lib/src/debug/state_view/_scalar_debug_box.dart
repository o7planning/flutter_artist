import 'package:flutter_artist_commons_ui/flutter_artist_commons_ui.dart';

import '../../core/_core_/core.dart';
import '_debug_box.dart';
import '_scalar_debug_options.dart';

class ScalarDebugBox extends BaseDebugBox {
  final Scalar scalar;
  final ScalarDebugOptions options;

  const ScalarDebugBox({
    super.key,
    required this.scalar,
    required this.options,
  });

  @override
  List<IconLabelText> getChildIconLabelTexts() {
    return [
      if (options.showUIActive)
        IconLabelText(
          label: "UI Active?: ",
          text: "${scalar.ui.hasActiveUIComponent()}",
          labelStyle: labelStyle0,
          textStyle: textStyle0,
        ),
      if (options.showLastQueryType)
        IconLabelText(
          label: "Last Query Type: ",
          text: scalar.lastQueryType.name,
          labelStyle: labelStyle,
          textStyle: textStyle0,
        ),
      if (options.showScalarDataState)
        IconLabelText(
          label: "Data State: ",
          text: scalar.dataState.name.toString(),
          labelStyle: labelStyle,
          textStyle: textStyle,
        ),
      if (options.showLastQueryResultState)
        IconLabelText(
          label: "Last Query Result: ",
          text: scalar.lastQueryResultState?.name ?? "",
          labelStyle: labelStyle,
          textStyle: textStyle0,
        ),
      if (options.showCallApiQueryCount)
        IconLabelText(
          label: "Query Count: ",
          text: scalar.callApiQueryCount.toString(),
          labelStyle: labelStyle,
          textStyle: textStyle,
        ),
      if (scalar.filterModel != null && options.showFilterCriteria)
        IconLabelText(
          label: "Filter Criteria: ",
          text: scalar.filterCriteria == null ? "null" : "[Not Null]",
          labelStyle: labelStyle,
          textStyle: textStyle0,
        ),
      if (scalar.filterModel != null && options.showFilterCriteriaChangeCount)
        IconLabelText(
          label: "Filter Criteria Change Count: ",
          text: scalar.filterCriteriaChangeCount.toString(),
          labelStyle: labelStyle,
          textStyle: textStyle0,
        ),
      IconLabelText(
        label: "Has Value?: ",
        text: (scalar.value != null).toString(),
        labelStyle: labelStyle,
        textStyle: textStyle0,
      ),
    ];
  }
}
