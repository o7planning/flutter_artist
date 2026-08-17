import 'package:flutter/material.dart';
import 'package:flutter_artist_commons_ui/flutter_artist_commons_ui.dart';

import '../../../core/_core_/core.dart';
import '../../../core/enums/active_element_type.dart';
import '../options/_debug_scalar_options.dart';
import 'widgets/active_info_widget.dart';
import '_debug_box.dart';
import 'debug_style_utils.dart';
import 'widgets/scalar_data_state_info_widget.dart';
import 'widgets/scalar_filter_criteria_info_widget.dart';

class ScalarDebugBox extends BaseDebugBox {
  final Scalar scalar;
  final DebugScalarOptions options;

  const ScalarDebugBox({
    super.key,
    required this.scalar,
    required this.options,
  });

  @override
  List<Widget> getChildIconLabelTexts(BuildContext context) {
    String? activeUI = scalar.ui.findActiveUiComponent();
    String? xActiveUI =
        scalar.ui.findActiveUiComponent(alsoCheckChildren: true);
    return [
      if (options.showUiActive)
        ActiveInfoWidget(
          activeElementType: ActiveElementType.scalar,
          activeUiComponentName: activeUI,
          xActiveUiComponentName: xActiveUI,
          labelStyle: DebugStyleUtils.getLabelStyle0(context),
          textStyle: DebugStyleUtils.getTextStyle0(context),
          checkAgain: () {
            String? activeUI = scalar.ui.findActiveUiComponent();
            print("Check again: $activeUI");
          },
        ),
      if (options.showLastQueryType)
        IconLabelText(
          label: "Last Query Type: ",
          text: scalar.lastQueryType.name,
          labelStyle: DebugStyleUtils.getLabelStyle(context),
          textStyle: DebugStyleUtils.getTextStyle0(context),
        ),
      if (options.showScalarDataState)
        ScalarDataStateInfoWidget(
          scalar: scalar,
          labelStyle: DebugStyleUtils.getLabelStyle(context),
          textStyle: DebugStyleUtils.getTextStyle(context),
        ),
      if (options.showLastQueryResultState)
        IconLabelText(
          label: "Last Query Result: ",
          text: scalar.lastQueryResultState?.name ?? "",
          labelStyle: DebugStyleUtils.getLabelStyle(context),
          textStyle: DebugStyleUtils.getTextStyle0(context),
        ),
      if (options.showPerformQueryCount)
        IconLabelText(
          label: "Query Count: ",
          text: scalar.debug.performQueryCount.toString(),
          labelStyle: DebugStyleUtils.getLabelStyle(context),
          textStyle: DebugStyleUtils.getTextStyle(context),
        ),
      if (scalar.filterModel != null && options.showFilterCriteria)
        ScalarFilterCriteriaInfoWidget(
          scalar: scalar,
          labelStyle: DebugStyleUtils.getLabelStyle(context),
          textStyle: DebugStyleUtils.getTextStyle0(context),
        ),
      if (options.showFilterCriteriaChangeCount)
        IconLabelText(
          label: "Filter Criteria Change Count: ",
          text: scalar.debug.filterCriteriaChangeCount.toString(),
          labelStyle: DebugStyleUtils.getLabelStyle(context),
          textStyle: DebugStyleUtils.getTextStyle0(context),
        ),
      IconLabelText(
        label: "Has Value?: ",
        text: (scalar.value != null).toString(),
        labelStyle: DebugStyleUtils.getLabelStyle(context),
        textStyle: DebugStyleUtils.getTextStyle0(context),
      ),
    ];
  }
}
