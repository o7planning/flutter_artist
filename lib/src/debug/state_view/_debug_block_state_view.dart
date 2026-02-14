import 'package:flutter/material.dart';

import '../../core/_core_/core.dart';
import '../../core/widgets/_table_container.dart';
import 'options/_debug_block_options.dart';
import 'options/_debug_filter_options.dart';
import 'options/_debug_form_options.dart';
import 'options/_debug_pagination_options.dart';
import 'widgets/_block_debug_box.dart';
import 'widgets/_filter_debug_box.dart';
import 'widgets/_form_debug_box.dart';
import 'widgets/_pagination_debug_box.dart';

class DebugBlockStateView extends StatelessWidget {
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
    return StorageAreaViewBuilder(
      ownerClassInstance: this,
      description: null,
      build: () {
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
              color: Colors.greenAccent.withAlpha(20),
              border: Border.all(width: 0.5)),
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              final int boxCount = children.length;
              //
              Widget mainWidget;
              if (vertical || boxCount <= 1) {
                mainWidget = _buildWithColumn(children);
              } else {
                if (boxCount == 3) {
                  if (constraints.constrainWidth() > 3 * minBoxWidth) {
                    mainWidget = _buildWithTableContainer(children);
                  } else if (constraints.constrainWidth() > 2 * minBoxWidth) {
                    mainWidget = _buildWithColumnAndTableContainer(children);
                  } else {
                    mainWidget = _buildWithColumn(children);
                  }
                } else if (boxCount == 2) {
                  if (constraints.constrainWidth() > 2 * minBoxWidth) {
                    mainWidget = _buildWithTableContainer(children);
                  } else {
                    mainWidget = _buildWithColumn(children);
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
                  if (showTitle) Text(block.name),
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

  Widget _buildWithColumn(List<Widget> children) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children.length <= 1
          ? children
          : (children
              .expand(
                (w) => [w, SizedBox(height: 5)],
              )
              .toList()
            ..removeLast()),
    );
  }

  Widget _buildWithTableContainer(List<Widget> children) {
    return TableContainer(
      flexes: children.map((child) => 1.0).toList(),
      padding: EdgeInsets.zero,
      widgets: children,
    );
  }

  Widget _buildWithColumnAndTableContainer(List<Widget> children) {
    assert(children.length == 3);
    //
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TableContainer(
          flexes: [1, 1],
          padding: EdgeInsets.zero,
          widgets: [children[0], children[1]],
        ),
        SizedBox(height: 5),
        children[2],
      ],
    );
  }
}
