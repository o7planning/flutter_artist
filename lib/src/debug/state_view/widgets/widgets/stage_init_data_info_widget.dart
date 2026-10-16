import 'package:flutter/material.dart';

import '../../../../core/_core_/core.dart';
import '../../../../core/enums/_enums.dart';
import '../../../dialog/data_debug_dialog.dart';
import '_base_info_widget.dart';

class StageInitDataInfoWidget extends BaseInfoWidget {
  final Stage stage;

  const StageInitDataInfoWidget({
    super.key,
    required this.stage,
    required super.labelStyle,
    required super.textStyle,
  });

  @override
  String? getButtonTooltip() {
    return "Show Stage Init Data";
  }

  @override
  String getLabel() {
    return "Has Init Data?: ";
  }

  @override
  String? getLeftTooltip() {
    return null;
  }

  @override
  String getText() {
    return stage.initData != null ? "true" : "false";
  }

  @override
  ButtonFunction? getButtonFunction() {
    return ButtonFunction(
      btnType: DebugBtnType.success,
      onPressed: stage.initData == null
          ? null
          : (BuildContext context) {
              DataDebugDialog.show(
                context: context,
                title: '',
                targetObject: stage.initData!,
              );
            },
    );
  }
}
