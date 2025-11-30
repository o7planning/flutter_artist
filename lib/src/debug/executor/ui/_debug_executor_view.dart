import 'package:flutter/material.dart';
import 'package:flutter_artist/src/debug/executor/ui/_debug_x_shelf_task_unit_queue_view.dart';

import '../model/_debug_x_root_queue.dart';

class DebugExecutorView extends StatefulWidget {
  final DebugXRootQueue debugXShelfQueue;

  const DebugExecutorView({
    super.key,
    required this.debugXShelfQueue,
  });

  @override
  State<StatefulWidget> createState() {
    return _DebugExecutorViewState();
  }
}

class _DebugExecutorViewState extends State<DebugExecutorView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      padding: EdgeInsets.all(5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: widget.debugXShelfQueue.debugXRootQueueItems
            .where((sq) => sq.isNotEmpty)
            .map(
              (subQueue) => DebugXShelfTaskUnitQueueView(
                  debugXShelfTaskUnitQueue: subQueue),
            )
            .toList(),
      ),
    );
  }
}
