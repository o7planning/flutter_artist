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
      padding: EdgeInsets.all(5),
      margin: EdgeInsets.all(5),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _buildTitle(),
          Divider(),
          SingleChildScrollView(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: widget.subTaskUnitQueue.taskUnits
                  .map((taskUnit) => DebugTaskUnitView(taskUnit: taskUnit))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTitle() {
    return ListTile(
      dense: true,
      visualDensity: VisualDensity(horizontal: -3, vertical: -3),
      contentPadding: EdgeInsets.all(0),
      leading: Tooltip(
        message: "XShelfID: ${widget.subTaskUnitQueue.subQueueId}",
        child: CircleAvatar(
          radius: 18,
          child: Center(
            child: Text(
              widget.subTaskUnitQueue.subQueueId.toString(),
              style: TextStyle(fontSize: 12),
            ),
          ),
        ),
      ),
      title:
          Text("Sub Queue (${widget.subTaskUnitQueue.taskUnits.length} Tasks)"),
    );
  }
}
