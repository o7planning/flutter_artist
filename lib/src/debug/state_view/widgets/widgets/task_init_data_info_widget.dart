import 'package:flutter/material.dart';

import '../../../../core/_core_/core.dart';
import '../../../../core/enums/_enums.dart';
import '../../../dialog/data_debug_dialog.dart';
import '_base_info_widget.dart';

class TaskInitDataInfoWidget extends BaseInfoWidget {
  final Task task;

  const TaskInitDataInfoWidget({
    super.key,
    required this.task,
    required super.labelStyle,
    required super.textStyle,
  });

  @override
  String? getButtonTooltip() {
    return "Show Task Init Data";
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
    return task.initData != null ? "true" : "false";
  }

  @override
  ButtonFunction? getButtonFunction() {
    return ButtonFunction(
      btnType: DebugBtnType.success,
      onPressed: task.initData == null
          ? null
          : (BuildContext context) {
              DataDebugDialog.show(
                context: context,
                title: '',
                targetObject: task.initData!,
              );
            },
    );
  }
}
