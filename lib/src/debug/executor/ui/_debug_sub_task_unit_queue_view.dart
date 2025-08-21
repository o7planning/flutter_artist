import 'package:flutter/material.dart';

import '../model/_debug_sub_task_unit_queue.dart';
import '_debug_task_unit_view.dart';

class DebugSubTaskUnitQueueView extends StatefulWidget {
  final DebugSubTaskUnitQueue subTaskUnitQueue;

  const DebugSubTaskUnitQueueView({
    super.key,
    required this.subTaskUnitQueue,
  });

  @override
  State<StatefulWidget> createState() {
    return _DebugSubTaskUnitQueueViewState();
  }
}

class _DebugSubTaskUnitQueueViewState extends State<DebugSubTaskUnitQueueView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.black26,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: widget.subTaskUnitQueue.taskUnits
            .map((taskUnit) => DebugTaskUnitView(taskUnit: taskUnit))
            .toList(),
      ),
    );
  }
}
