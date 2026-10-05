import 'package:flutter/material.dart';
import 'package:flutter_artist_commons_ui/flutter_artist_commons_ui.dart';

import '../../../core/_core_/core.dart';
import '../../../core/icon/icon_constants.dart';
import '../../../core/utils/__utils.dart';
import '../../constants/_debug_constants.dart';

class GraphItemTaskBox extends StatefulWidget {
  final Task task;

  const GraphItemTaskBox({
    super.key,
    required this.task,
  });

  @override
  State<GraphItemTaskBox> createState() => _GraphItemTaskBoxState();
}

class _GraphItemTaskBoxState extends State<GraphItemTaskBox> {
  static const double minBoxWidth = 260;
  static const double graphBoxImageWidth = 32;
  static const double spacing = 5;
  static const double padding = 5;
  static const double iconSize = 16;

  @override
  Widget build(BuildContext context) {
    bool hasActiveWidget = widget.task.ui.hasVisibleViews();

    return SizedBox(
      width: minBoxWidth,
      child: Container(
        padding: const EdgeInsets.all(padding),
        decoration: BoxDecoration(
          color: hasActiveWidget
              ? DebugConstants.activeGraphBoxBgColor(context)
              : DebugConstants.inactiveGraphBoxBgColor(context),
          borderRadius: BorderRadius.circular(4),
          boxShadow: [
            DebugConstants.graphBoxShadow(context),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTaskShortInfo(),
            const SizedBox(height: 5),
            _buildDataStateRow(hasActiveWidget),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskShortInfo() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Icon(
          FaIconConstants.taskIconData,
          size: DebugConstants.graphBoxIconSize,
        ),
        const SizedBox(width: spacing),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconLabelText(
                  style: _getTaskNameTextStyle(),
                  label: 'Name: ',
                  text: widget.task.name,
                ),
                TooltipUtils.buildTooltip(
                  message: "TASK: ${getClassName(widget.task)}",
                  child: IconLabelText(
                    style: _getTaskNameTextStyle(),
                    label: 'Class: ',
                    text: getClassName(widget.task),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDataStateRow(bool active) {
    Color stateBgColor;
    switch (widget.task.dataState) {
      case TaskDataStateLoadedFresh():
        stateBgColor = DebugConstants.graphBoxDataStateReadyBgColor(context);
      case TaskDataStatePending():
        stateBgColor = DebugConstants.graphBoxDataStatePendingBgColor(context);
      case TaskDataStateLoadedStale():
        stateBgColor = Colors.orangeAccent;
      case TaskDataStateSubmissionAttemptedSuccess():
        stateBgColor = Colors.teal;
      case TaskDataStateSubmissionAttemptedFailed():
        stateBgColor = DebugConstants.graphBoxDataStateErrorBgColor(context);
    }

    return Container(
      padding: const EdgeInsets.all(3),
      color: stateBgColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(
            widget.task.hasError
                ? FaIconConstants.dataStateErrorIconData
                : FaIconConstants.dataStateLoadedIconData,
            size: iconSize,
            color: DebugConstants.graphBoxTextColor(context),
          ),
          const SizedBox(width: 2),
          Icon(
            active
                ? FaIconConstants.visibleTrueIconData
                : FaIconConstants.visibleFalseIconData,
            size: iconSize,
            color: DebugConstants.graphBoxTextColor(context),
          ),
          const SizedBox(width: 5),
          Text(
            "TASK",
            style: _getSummaryTextStyle(),
          ),
          const Spacer(),
          Text(
            widget.task.dataState.toBriefInfo(),
            style: _getSummaryTextStyle(),
          ),
        ],
      ),
    );
  }

  TextStyle _getTaskNameTextStyle() {
    return TextStyle(
      fontSize: DebugConstants.graphBoxFontSizeChildBox,
      overflow: TextOverflow.ellipsis,
    );
  }

  TextStyle _getSummaryTextStyle() {
    return TextStyle(
      fontSize: DebugConstants.graphBoxFontSizeChildBox,
      overflow: TextOverflow.ellipsis,
      color: DebugConstants.graphBoxTextColor(context),
      fontWeight: FontWeight.bold,
    );
  }
}
