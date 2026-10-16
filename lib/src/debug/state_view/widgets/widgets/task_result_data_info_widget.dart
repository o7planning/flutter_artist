import 'package:flutter/material.dart';

import '../../../../core/_core_/core.dart';
import '../../../../core/enums/_enums.dart';
import '../../../dialog/data_debug_dialog.dart';
import '_base_info_widget.dart';

class TaskResultDataInfoWidget extends BaseInfoWidget {
  final Task task;

  const TaskResultDataInfoWidget({
    super.key,
    required this.task,
    required super.labelStyle,
    required super.textStyle,
  });

  @override
  String? getButtonTooltip() {
    return "Show Task Result Data";
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
    return task.submitResultData != null ? "true" : "false";
  }

  @override
  ButtonFunction? getButtonFunction() {
    return ButtonFunction(
      btnType: DebugBtnType.success,
      onPressed: task.submitResultData == null
          ? null
          : (BuildContext context) {
              DataDebugDialog.show(
                context: context,
                title: '',
                targetObject: task.submitResultData!,
              );
            },
    );
  }
}
