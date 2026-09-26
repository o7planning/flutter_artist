import 'package:flutter/material.dart' hide Flow;

import '../../../flutter_artist.dart';
import '__debug_base_state_view.dart';
import 'widgets/form_debug_box.dart';
import 'widgets/prozess_debug_box.dart';
import 'widgets/stage_debug_box.dart';

class DebugProzessStateView extends DebugBaseStateView {
  final Prozess prozess;
  final DebugProzessOptions? debugProzessOptions;
  final DebugStageOptions? debugStageOptions;
  final DebugFormOptions? debugFormOptions;

  final bool showTitle;
  final bool vertical;

  const DebugProzessStateView({
    super.key,
    required this.prozess,
    required this.vertical,
    this.showTitle = true,
    required this.debugProzessOptions,
    this.debugStageOptions,
    this.debugFormOptions,
  });

  @override
  Widget build(BuildContext context) {
    const double minBoxWidth = 200;
    return StorageSectionViewBuilder(
      ownerClassInstance: this,
      description: null,
      build: () {
        final theme = Theme.of(context);
        final colorScheme = theme.colorScheme;

        // Resolve current active stage in the Prozess
        final Stage? currentStage = prozess.findStage(prozess.currentStageId);

        List<Widget> children = [];

        // 1. Prozess Pipeline Overview
        if (debugProzessOptions != null) {
          children.add(
            ProzessDebugBox(
              prozess: prozess,
              options: debugProzessOptions!,
            ),
          );
        }

        // 2. Active Stage Detail Box
        if (debugStageOptions != null && currentStage != null) {
          children.add(
            StageDebugBox(
              stage: currentStage,
              options: debugStageOptions!,
            ),
          );
        }

        // 3. Form Model of Active Stage (if any)
        if (debugFormOptions != null &&
            currentStage != null &&
            currentStage.formModel != null) {
          children.add(
            FormDebugBox(
              formModel: currentStage.formModel!,
              options: debugFormOptions!,
            ),
          );
        }

        return Container(
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: colorScheme.primary.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(4),
            border: Border.all(
              color: theme.dividerColor.withValues(alpha: 0.2),
              width: 0.5,
            ),
          ),
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              final int boxCount = children.length;

              Widget mainWidget;
              if (vertical || boxCount <= 1) {
                mainWidget = buildWithColumn(children);
              } else {
                if (boxCount == 3) {
                  if (constraints.constrainWidth() > 3 * minBoxWidth) {
                    mainWidget = buildWithTableContainer(children);
                  } else if (constraints.constrainWidth() > 2 * minBoxWidth) {
                    mainWidget = buildWithColumnAndTableContainer(children);
                  } else {
                    mainWidget = buildWithColumn(children);
                  }
                } else if (boxCount == 2) {
                  if (constraints.constrainWidth() > 2 * minBoxWidth) {
                    mainWidget = buildWithTableContainer(children);
                  } else {
                    mainWidget = buildWithColumn(children);
                  }
                } else {
                  mainWidget = const SizedBox();
                }
              }

              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (showTitle)
                    Text(
                      prozess.name,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.primary,
                        fontSize: 12,
                      ),
                    ),
                  if (showTitle) const Divider(height: 10),
                  mainWidget,
                ],
              );
            },
          ),
        );
      },
    );
  }
}
