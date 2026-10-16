import 'package:flutter/material.dart';
import 'package:flutter_artist_commons_ui/flutter_artist_commons_ui.dart';

import '../../../core/_core_/core.dart';
import '../../../core/enums/_enums.dart';
import '../options/_debug_stage_options.dart';
import '_debug_box.dart';
import 'debug_style_utils.dart';
import 'stage_data_state_info_widget.dart';
import 'widgets/active_info_widget.dart';
import 'widgets/class_def_viewable_info_widget.dart';
import 'widgets/stage_init_data_info_widget.dart';
import 'widgets/stage_result_data_info_widget.dart';

class StageDebugBox extends BaseDebugBox {
  final Stage stage;
  final DebugStageOptions options;

  const StageDebugBox({
    super.key,
    required this.stage,
    required this.options,
  });

  @override
  List<Widget> getChildIconLabelTexts(BuildContext context) {
    final String? activeUI = stage.ui.findVisibleView();

    return [
      if (options.showClassDefinition)
        ClassDefViewableInfoWidget(
          classDefViewable: stage,
          labelStyle: DebugStyleUtils.getLabelStyle0(context),
          textStyle: DebugStyleUtils.getTextStyle0(context),
        ),
      if (options.showUiActive)
        ActiveInfoWidget(
          activeElementType: ActiveElementType.stage,
          activeUiComponentName: activeUI,
          xActiveUiComponentName: activeUI,
          labelStyle: DebugStyleUtils.getLabelStyle0(context),
          textStyle: DebugStyleUtils.getTextStyle0(context),
          checkAgain: () {},
        ),
      IconLabelText(
        label: "Stage Name: ",
        text: stage.name,
        labelStyle: DebugStyleUtils.getLabelStyle1(context),
        textStyle: DebugStyleUtils.getTextStyle0(context),
      ),
      if (options.showStageDataState)
        StageDataStateInfoWidget(
          stage: stage,
          labelStyle: DebugStyleUtils.getLabelStyle(context),
          textStyle: DebugStyleUtils.getTextStyle(context),
        ),
      if (options.showPerformLoadInitDataCount)
        IconLabelText(
          label: "Load Init Data Count: ",
          text: stage.debug.performLoadInitDataCount.toString(),
          labelStyle: DebugStyleUtils.getLabelStyle(context),
          textStyle: DebugStyleUtils.getTextStyle(context),
        ),
      if (options.showInitData)
        StageInitDataInfoWidget(
          stage: stage,
          labelStyle: DebugStyleUtils.getLabelStyle(context),
          textStyle: DebugStyleUtils.getTextStyle(context),
        ),
      if (options.showResultData)
        StageResultDataInfoWidget(
          stage: stage,
          labelStyle: DebugStyleUtils.getLabelStyle(context),
          textStyle: DebugStyleUtils.getTextStyle(context),
        ),
    ];
  }
}
