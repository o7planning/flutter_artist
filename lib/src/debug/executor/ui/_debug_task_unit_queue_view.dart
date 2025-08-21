import 'package:flutter/material.dart';
import 'package:flutter_artist/src/debug/executor/ui/_debug_sub_task_unit_queue_view.dart';

import '../model/_debug_task_unit_queue.dart';

class DebugTaskUnitQueueView extends StatefulWidget {
  final DebugTaskUnitQueue taskUnitQueue;

  const DebugTaskUnitQueueView({
    super.key,
    required this.taskUnitQueue,
  });

  @override
  State<StatefulWidget> createState() {
    return _DebugTaskUnitQueueViewState();
  }
}

class _DebugTaskUnitQueueViewState extends State<DebugTaskUnitQueueView> {
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
        children: widget.taskUnitQueue.subQueues
            .where((sq) => sq.isNotEmpty)
            .map((subQueue) =>
                DebugSubTaskUnitQueueView(subTaskUnitQueue: subQueue))
            .toList(),
      ),
    );
  }
}
