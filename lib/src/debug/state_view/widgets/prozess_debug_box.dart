import 'package:flutter/material.dart';
import 'package:flutter_artist_commons_ui/flutter_artist_commons_ui.dart';

import '../../../core/_core_/core.dart';
import '../../../core/enums/_enums.dart';
import '../../utils/_debug.dart';
import '../options/_debug_prozess_options.dart';
import '_debug_box.dart';
import 'debug_style_utils.dart';
import 'widgets/active_info_widget.dart';

class ProzessDebugBox extends BaseDebugBox {
  final Prozess prozess;
  final DebugProzessOptions options;

  const ProzessDebugBox({
    super.key,
    required this.prozess,
    required this.options,
  });

  Color _getStageColor(StageDataState state) {
    if (state.hasError) return Colors.red.shade700;
    return switch (state) {
      StageDataStateNone() => Colors.grey.shade500,
      StageDataStatePending() => Colors.amber.shade800,
      StageDataStateLoadedFresh() => Colors.green.shade700,
      StageDataStateLoadedStale() => Colors.orange.shade700,
      StageDataStateSubmissionAttemptedSuccess() => Colors.teal.shade700,
      StageDataStateSubmissionAttemptedFailed() => Colors.red.shade700,
    };
  }

  @override
  List<Widget> getChildIconLabelTexts(BuildContext context) {
    final String? activeUI = prozess.ui.findVisibleView();
    final stages = prozess.stages;
    final currentStageId = prozess.currentStageId;

    return [
      if (options.showUiActive)
        ActiveInfoWidget(
          activeElementType: ActiveElementType.prozess,
          activeUiComponentName: activeUI,
          xActiveUiComponentName: activeUI,
          labelStyle: DebugStyleUtils.getLabelStyle0(context),
          textStyle: DebugStyleUtils.getTextStyle0(context),
          checkAgain: () {},
        ),
      if (options.showCurrentStage)
        IconLabelText(
          label: "Current Stage: ",
          text: prozess.currentStageId.name,
          labelStyle: DebugStyleUtils.getLabelStyle(context),
          textStyle: DebugStyleUtils.getTextStyle(context),
        ),
      if (options.showStageHistory)
        IconLabelText(
          label: "History: ",
          text: prozess.stageHistory.isEmpty
              ? "[]"
              : prozess.stageHistory.map((e) => e.name).join(" ➔ "),
          labelStyle: DebugStyleUtils.getLabelStyle(context),
          textStyle: DebugStyleUtils.getTextStyle0(context),
        ),
      if (options.showContextData)
        IconLabelText(
          label: "Context Data: ",
          text: debugObj(prozess.contextData),
          labelStyle: DebugStyleUtils.getLabelStyle(context),
          textStyle: DebugStyleUtils.getTextStyle0(context),
        ),
      if (options.showStagePipeline && stages.isNotEmpty) ...[
        const Divider(height: 8),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (int i = 0; i < stages.length; i++) ...[
                if (i > 0)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    child: Icon(
                      Icons.chevron_right,
                      size: 13,
                      color: Colors.grey.shade400,
                    ),
                  ),
                _buildStagePill(context, stages[i], currentStageId),
              ],
            ],
          ),
        ),
      ],
    ];
  }

  Widget _buildStagePill(
      BuildContext context, Stage stage, Enum currentStageId) {
    final bool isCurrent = stage.stageId == currentStageId;
    final Color color = _getStageColor(stage.dataState);

    return InkWell(
      onTap: () {
        if (stage.hasError) {
          stage.showStageErrorViewerDialog(context);
        }
      },
      borderRadius: BorderRadius.circular(4),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
        decoration: BoxDecoration(
          color: isCurrent ? color.withValues(alpha: 0.15) : Colors.transparent,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            color: isCurrent ? color : color.withValues(alpha: 0.35),
            width: isCurrent ? 1.4 : 0.8,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isCurrent)
              Padding(
                padding: const EdgeInsets.only(right: 3),
                child: Container(
                  width: 5,
                  height: 5,
                  decoration:
                      BoxDecoration(color: color, shape: BoxShape.circle),
                ),
              ),
            Text(
              stage.name,
              style: TextStyle(
                fontSize: 10,
                fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                color: isCurrent ? color : Colors.grey.shade800,
              ),
            ),
            const SizedBox(width: 3),
            Text(
              "(${stage.dataState.toBriefInfo()})",
              style: TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.w500,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
