import 'package:flutter/material.dart';

import '../../core/_core_/core.dart';
import '__debug_base_state_view.dart';
import 'options/_debug_form_options.dart';
import 'options/_debug_task_options.dart';
import 'widgets/form_debug_box.dart';
import 'widgets/task_debug_box.dart';

class DebugTaskStateView extends DebugBaseStateView {
  final Task task;
  final DebugTaskOptions? debugTaskOptions;
  final DebugFormOptions? debugFormOptions;

  final bool showTitle;
  final bool vertical;

  const DebugTaskStateView({
    super.key,
    required this.task,
    required this.vertical,
    this.showTitle = true,
    required this.debugTaskOptions,
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

        List<Widget> children = [];
        if (debugTaskOptions != null) {
          children.add(
            TaskDebugBox(
              task: task,
              options: debugTaskOptions!,
            ),
          );
        }
        if (debugFormOptions != null && task.formModel != null) {
          children.add(
            FormDebugBox(
              formModel: task.formModel!,
              options: debugFormOptions!,
            ),
          );
        }
        //
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
              //
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
                  // Never run:
                  mainWidget = SizedBox();
                }
              }
              //
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (showTitle)
                    Text(
                      task.name,
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
