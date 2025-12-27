import 'package:flutter/material.dart';
import 'package:flutter_artist_commons_ui/flutter_artist_commons_ui.dart';

import '../../../core/_core_/core.dart';
import '../options/_debug_scalar_options.dart';
import '_active_info_widget.dart';
import '_debug_box.dart';

class ScalarDebugBox extends BaseDebugBox {
  final Scalar scalar;
  final DebugScalarOptions options;

  const ScalarDebugBox({
    super.key,
    required this.scalar,
    required this.options,
  });

  @override
  List<Widget> getChildIconLabelTexts() {
    String? activeUI = scalar.ui.findActiveUIComponent();
    String? xActiveUI =
        scalar.ui.findActiveUIComponent(alsoCheckChildren: true);
    return [
      if (options.showUIActive)
        ActiveInfoWidget(
          activeElementType: ActiveElementType.scalar,
          activeUIComponentName: activeUI,
          xActiveUIComponentName: xActiveUI,
          labelStyle: labelStyle0,
          textStyle: textStyle0,
          checkAgain: () {
            String? activeUI = scalar.ui.findActiveUIComponent();
            print("Check again: $activeUI");
          },
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
      if (options.showFilterCriteriaChangeCount)
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
