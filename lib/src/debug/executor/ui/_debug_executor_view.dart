import 'package:flutter/material.dart';
import '../model/_debug_x_root_queue.dart';
import '_debug_x_shelf_task_unit_queue_view.dart';

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
