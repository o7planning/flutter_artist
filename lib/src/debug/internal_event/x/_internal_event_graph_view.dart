import 'package:flutter/material.dart';
import 'package:flutter_force_directed_graph/flutter_force_directed_graph.dart';

import '../../../core/_core_/core.dart';
import '../../__root_debug_view.dart';

class InternalEventGraphView extends StatelessWidget {
  final RootDebugController controller;
  final Shelf shelf;
  final bool showTitle;

  const InternalEventGraphView({
    super.key,
    this.showTitle = true,
    required this.controller,
    required this.shelf,
  });

  @override
  Widget build(BuildContext context) {
    ForceDirectedGraphController<int> controller =
        ForceDirectedGraphController();

    final fdgWidget = ForceDirectedGraphWidget(
      controller: controller,
      onDraggingStart: (data) {
        print('Dragging started on node $data');
      },
      onDraggingEnd: (data) {
        print('Dragging ended on node $data');
      },
      onDraggingUpdate: (data) {
        print('Dragging updated on node $data');
      },
      nodesBuilder: (context, data) {
        return Container(
          width: 24,
          height: 24,
          alignment: Alignment.center,
          color: Colors.red,
          child: Text('$data'),
        );
      },
      edgesBuilder: (context, a, b, distance) {
        return Container(
          width: distance,
          height: 16,
          color: Colors.blue,
          alignment: Alignment.center,
          child: Text('$a <-> $b'),
        );
      },
    );
    return Center(child: fdgWidget);
  }
}
