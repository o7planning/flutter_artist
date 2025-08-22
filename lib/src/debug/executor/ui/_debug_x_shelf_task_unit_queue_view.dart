import 'package:flutter/material.dart';
import 'package:flutter_artist_commons_ui/flutter_artist_commons_ui.dart';

import '../model/_debug_x_shelf_task_unit_queue.dart';
import '_debug_task_unit_view.dart';

class DebugSubTaskUnitQueueView extends StatefulWidget {
  final DebugXShelfTaskUnitQueue debugXShelfTaskUnitQueue;

  const DebugSubTaskUnitQueueView({
    super.key,
    required this.debugXShelfTaskUnitQueue,
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
              children: widget.debugXShelfTaskUnitQueue.taskUnits
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
        message: "XShelfID: ${widget.debugXShelfTaskUnitQueue.xShelfId}",
        child: CircleAvatar(
          radius: 18,
          child: Center(
            child: Text(
              widget.debugXShelfTaskUnitQueue.xShelfId.toString(),
              style: TextStyle(fontSize: 12),
            ),
          ),
        ),
      ),
      title: Text(
          "Task Units in the Queue of ${widget.debugXShelfTaskUnitQueue.shelfName}"),
      subtitle: IconLabelText(
        label: "XShelf Task Type: ",
        text: widget.debugXShelfTaskUnitQueue.xShelfType.name,
        textStyle: TextStyle(color: Colors.indigo, fontSize: 13),
      ),
    );
  }
}
