import 'package:flutter/material.dart';
import 'package:flutter_artist_commons_ui/flutter_artist_commons_ui.dart';

import '../../../core/_core_/core.dart';
import '../../../core/enums/_enums.dart';
import '../options/_debug_process_options.dart';
import '_debug_box.dart';
import 'debug_style_utils.dart';
import 'widgets/active_info_widget.dart';
import 'widgets/class_def_viewable_info_widget.dart';
import 'widgets/prozess_context_data_info_widget.dart';
import 'widgets/prozess_init_data_info_widget.dart';
import 'widgets/stages_info_widget.dart';

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
    final stages = prozess.orderedStages;
    final currentStageId = prozess.viewingStageEnum;

    final Stage? frontierStage = prozess.findFrontierStage();
    final StageEnum? frontierStageEnum = frontierStage?.stageId;

    return [
      if (options.showClassDefinition)
        ClassDefViewableInfoWidget(
          classDefViewable: prozess,
          labelStyle: DebugStyleUtils.getLabelStyle0(context),
          textStyle: DebugStyleUtils.getTextStyle0(context),
        ),
      if (options.showStagesInfo)
        StagesInfoWidget(
          prozess: prozess,
          labelStyle: DebugStyleUtils.getLabelStyle0(context),
          textStyle: DebugStyleUtils.getTextStyle0(context),
        ),
      if (options.showUiActive)
        ActiveInfoWidget(
          activeElementType: ActiveElementType.prozess,
          activeUiComponentName: activeUI,
          xActiveUiComponentName: activeUI,
          labelStyle: DebugStyleUtils.getLabelStyle0(context),
          textStyle: DebugStyleUtils.getTextStyle0(context),
          checkAgain: () {},
        ),
      if (options.showDataState)
        IconLabelText(
          label: "Prozess State: ",
          text: prozess.dataState.toBriefInfo(),
          labelStyle: DebugStyleUtils.getLabelStyle(context),
          textStyle: DebugStyleUtils.getTextStyle(context),
        ),
      if (options.showViewingStage)
        IconLabelText(
          label: "Viewing Stage: ",
          text: prozess.viewingStageEnum?.stageCode ?? " - ",
          labelStyle: DebugStyleUtils.getLabelStyle(context),
          textStyle: DebugStyleUtils.getTextStyle(context),
        ),
      if (options.showFrontierStage)
        IconLabelText(
          label: "Frontier Stage: ",
          text: frontierStageEnum?.stageCode ?? " - ",
          labelStyle: DebugStyleUtils.getLabelStyle(context),
          textStyle: DebugStyleUtils.getTextStyle(context),
        ),
      if (options.showPerformLoadInitDataCount)
        IconLabelText(
          label: "Load Init Data Count: ",
          text: prozess.debug.performLoadInitDataCount.toString(),
          labelStyle: DebugStyleUtils.getLabelStyle(context),
          textStyle: DebugStyleUtils.getTextStyle(context),
        ),
      if (options.showStageReexecutionAllowed)
        IconLabelText(
          label: "Stage Reexecution Allowed?: ",
          text: prozess.debug.isStageReexecutionAllowed.toString(),
          labelStyle: DebugStyleUtils.getLabelStyle0(context),
          textStyle: DebugStyleUtils.getTextStyle0(context),
        ),
      if (options.showInitData)
        ProzessInitDataInfoWidget(
          prozess: prozess,
          labelStyle: DebugStyleUtils.getLabelStyle(context),
          textStyle: DebugStyleUtils.getTextStyle0(context),
        ),
      if (options.showContextData)
        ProzessContextDataInfoWidget(
          prozess: prozess,
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
    BuildContext context,
    Stage stage,
    StageEnum? currentStageId,
  ) {
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
          // FIX: Keep border width constant (1.0) to prevent subpixel layout shifts
          // and avoid Flutter's strict fractional overflow detections.
          border: Border.all(
            color: isCurrent ? color : color.withValues(alpha: 0.35),
            width: 1.0,
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
