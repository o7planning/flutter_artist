import 'package:flutter/material.dart';

import '../../core/_core_/core.dart';
import '../../core/widgets/_table_container.dart';
import 'options/_debug_scalar_options.dart';
import 'widgets/_scalar_debug_box.dart';

class DebugScalarStateView extends StatelessWidget {
  final Scalar scalar;
  final DebugScalarOptions? debugScalarOptions;

  final bool showTitle;
  final bool vertical;

  const DebugScalarStateView({
    super.key,
    required this.scalar,
    required this.vertical,
    this.showTitle = true,
    required this.debugScalarOptions,
  });

  @override
  Widget build(BuildContext context) {
    const double minBoxWidth = 200;
    return StorageAreaViewBuilder(
      ownerClassInstance: this,
      description: null,
      build: () {
        List<Widget> children = [];
        if (debugScalarOptions != null) {
          children.add(
            ScalarDebugBox(
              scalar: scalar,
              options: debugScalarOptions!,
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
                  if (showTitle) Text(scalar.name),
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
