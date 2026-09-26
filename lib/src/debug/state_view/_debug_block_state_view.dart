import 'package:flutter/material.dart';

import '../../core/_core_/core.dart';
import '../../core/widgets/_table_container.dart';
import '__debug_base_state_view.dart';
import 'options/_debug_block_options.dart';
import 'options/_debug_filter_options.dart';
import 'options/_debug_form_options.dart';
import 'options/_debug_pagination_options.dart';
import 'widgets/block_debug_box.dart';
import 'widgets/filter_debug_box.dart';
import 'widgets/form_debug_box.dart';
import 'widgets/pagination_debug_box.dart';

class DebugBlockStateView extends DebugBaseStateView {
  final Block block;
  final DebugFilterOptions? debugFilterOptions;
  final DebugBlockOptions? debugBlockOptions;
  final DebugFormOptions? debugFormOptions;
  final DebugPaginationOptions? debugPaginationOptions;

  final bool showTitle;
  final bool vertical;

  const DebugBlockStateView({
    super.key,
    required this.block,
    required this.vertical,
    this.showTitle = true,
    this.debugFilterOptions,
    required this.debugBlockOptions,
    required this.debugFormOptions,
    required this.debugPaginationOptions,
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
        if (debugFilterOptions != null && block.filterModel != null) {
          children.add(
            FilterDebugBox(
              filterModel: block.filterModel!,
              options: debugFilterOptions!,
            ),
          );
        }
        if (debugBlockOptions != null) {
          children.add(
            BlockDebugBox(
              block: block,
              options: debugBlockOptions!,
            ),
          );
        }
        if (debugFormOptions != null && block.formModel != null) {
          children.add(
            FormDebugBox(
              formModel: block.formModel!,
              options: debugFormOptions!,
            ),
          );
        }
        if (debugPaginationOptions != null) {
          children.add(
            PaginationDebugBox(
              block: block,
              options: debugPaginationOptions!,
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
                      block.name,
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
