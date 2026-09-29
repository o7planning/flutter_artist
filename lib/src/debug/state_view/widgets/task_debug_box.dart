import 'package:flutter/material.dart';
import 'package:flutter_artist_commons_ui/flutter_artist_commons_ui.dart';

import '../../../core/_core_/core.dart';
import '../../../core/enums/_enums.dart';
import '../options/_debug_task_options.dart';
import 'widgets/active_info_widget.dart';
import '_debug_box.dart';
import 'debug_style_utils.dart';
import 'widgets/task_data_state_info_widget.dart';

class TaskDebugBox extends BaseDebugBox {
  final Task task;
  final DebugTaskOptions options;

  const TaskDebugBox({
    super.key,
    required this.task,
    required this.options,
  });

  @override
  List<Widget> getChildIconLabelTexts(BuildContext context) {
    String? activeUI = task.ui.findVisibleView();
    String? xActiveUI = task.ui.findVisibleView();
    return [
      if (options.showUiActive)
        ActiveInfoWidget(
          activeElementType: ActiveElementType.task,
          activeUiComponentName: activeUI,
          xActiveUiComponentName: xActiveUI,
          labelStyle: DebugStyleUtils.getLabelStyle0(context),
          textStyle: DebugStyleUtils.getTextStyle0(context),
          checkAgain: () {
            String? activeUI = task.ui.findVisibleView();
            print("Check again: $activeUI");
          },
        ),
      if (options.showTaskDataState)
        TaskDataStateInfoWidget(
          task: task,
          labelStyle: DebugStyleUtils.getLabelStyle(context),
          textStyle: DebugStyleUtils.getTextStyle(context),
        ),
      if (options.showPerformLoadInitDataCount)
        IconLabelText(
          label: "Load Init Data Count: ",
          text: task.debug.performLoadInitDataCount.toString(),
          labelStyle: DebugStyleUtils.getLabelStyle(context),
          textStyle: DebugStyleUtils.getTextStyle(context),
        ),
      IconLabelText(
        label: "Has Init Data?: ",
        text: (task.initData != null).toString(),
        labelStyle: DebugStyleUtils.getLabelStyle(context),
        textStyle: DebugStyleUtils.getTextStyle0(context),
      ),
    ];
  }
}
