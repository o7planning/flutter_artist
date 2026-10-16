import 'package:flutter/material.dart';

import '../../../../core/_core_/core.dart';
import '../../../../core/enums/_enums.dart';
import '../../../dialog/data_debug_dialog.dart';
import '_base_info_widget.dart';

class StageResultDataInfoWidget extends BaseInfoWidget {
  final Stage stage;

  const StageResultDataInfoWidget({
    super.key,
    required this.stage,
    required super.labelStyle,
    required super.textStyle,
  });

  @override
  String? getButtonTooltip() {
    return "Show Stage Result Data";
  }

  @override
  String getLabel() {
    return "Has Result Data?: ";
  }

  @override
  String? getLeftTooltip() {
    return null;
  }

  @override
  String getText() {
    return stage.submitResultData != null ? "true" : "false";
  }

  @override
  ButtonFunction? getButtonFunction() {
    return ButtonFunction(
      btnType: DebugBtnType.success,
      onPressed: stage.submitResultData == null
          ? null
          : (BuildContext context) {
              DataDebugDialog.show(
                context: context,
                title: '',
                targetObject: stage.submitResultData!,
              );
            },
    );
  }
}
