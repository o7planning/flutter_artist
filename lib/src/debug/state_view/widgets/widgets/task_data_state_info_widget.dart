import 'package:flutter/material.dart';
import 'package:flutter_artist/src/core/enums/debug_btn_type.dart';

import '../../../../core/_core_/core.dart';
import '_base_info_widget.dart';

class TaskDataStateInfoWidget extends BaseInfoWidget {
  final Task task;

  const TaskDataStateInfoWidget({
    super.key,
    required this.task,
    required super.labelStyle,
    required super.textStyle,
  });

  @override
  String? getButtonTooltip() {
    return task.dataState.toBriefInfo();
  }

  @override
  String getLabel() {
    return "Data State: ";
  }

  @override
  String? getLeftTooltip() {
    return task.dataState.toBriefInfo();
  }

  @override
  String getText() {
    return task.dataState.toBriefInfo();
  }

  @override
  ButtonFunction? getButtonFunction() {
    switch (task.dataState) {
      case TaskDataStatePending(reason: TaskPendingReasonInitial()):
        return null;
      case TaskDataStateLoadedStale():
        return null;
      case TaskDataStatePending(reason: TaskPendingReasonFailed()):
        return ButtonFunction(
          btnType: DebugBtnType.error,
          onPressed: (BuildContext context) {
            task.showTaskErrorViewerDialog(context);
          },
        );
      case TaskDataStateLoadedFresh():
        return null;
      case TaskDataStateSubmissionAttemptedSuccess():
        return null;
      case TaskDataStateSubmissionAttemptedFailed():
        return null;
    }
  }
}
