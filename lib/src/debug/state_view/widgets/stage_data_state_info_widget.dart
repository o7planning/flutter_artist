import 'package:flutter/material.dart';

import '../../../core/_core_/core.dart';
import '../../../core/enums/_enums.dart';
import 'widgets/_base_info_widget.dart';

class StageDataStateInfoWidget extends BaseInfoWidget {
  final Stage stage;

  const StageDataStateInfoWidget({
    super.key,
    required this.stage,
    required super.labelStyle,
    required super.textStyle,
  });

  @override
  String? getButtonTooltip() => stage.dataState.toBriefInfo();

  @override
  String getLabel() => "Stage State: ";

  @override
  String? getLeftTooltip() => stage.dataState.toBriefInfo();

  @override
  String getText() => stage.dataState.toBriefInfo();

  @override
  ButtonFunction? getButtonFunction() {
    if (stage.hasError) {
      return ButtonFunction(
        btnType: DebugBtnType.error,
        onPressed: (BuildContext context) {
          stage.showStageErrorViewerDialog(context);
        },
      );
    }
    return null;
  }
}
