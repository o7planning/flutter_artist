import 'package:flutter/material.dart';
import 'package:flutter_artist_commons_ui/flutter_artist_commons_ui.dart';

import '../../dialog/_x_shelf_dialog.dart';
import '../model/_debug_x_root_queue_item.dart';
import '_debug_task_unit_view.dart';

class DebugXShelfTaskUnitQueueView extends StatefulWidget {
  final DebugXRootQueueItem debugXShelfTaskUnitQueue;

  const DebugXShelfTaskUnitQueueView({
    super.key,
    required this.debugXShelfTaskUnitQueue,
  });

  @override
  State<StatefulWidget> createState() {
    return _DebugXShelfTaskUnitQueueViewState();
  }
}

class _DebugXShelfTaskUnitQueueViewState
    extends State<DebugXShelfTaskUnitQueueView> {
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
              children: [
                ...widget.debugXShelfTaskUnitQueue.mainTaskUnits.map(
                  (taskUnit) => DebugTaskUnitView(
                      taskUnit: taskUnit, isInMainQueue: true),
                ),
                ...widget.debugXShelfTaskUnitQueue.secondaryTaskUnits.map(
                    (taskUnit) => DebugTaskUnitView(
                        taskUnit: taskUnit, isInMainQueue: false))
              ],
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
        message: "XShelfID: ${widget.debugXShelfTaskUnitQueue.xShelf.xShelfId}",
        child: CircleAvatar(
          radius: 18,
          child: Center(
            child: Text(
              widget.debugXShelfTaskUnitQueue.xShelf.xShelfId.toString(),
              style: TextStyle(fontSize: 12),
            ),
          ),
        ),
      ),
      trailing: ElevatedButton(
        onPressed: () {
          _openXShelfDialog();
        },
        child: Icon(
          Icons.queue_play_next,
        ),
      ),
      title: Text(
          "Task Units in the Queue of XShelf (${widget.debugXShelfTaskUnitQueue.xShelf.shelf.name})"),
      subtitle: IconLabelText(
        label: "XShelf Task Type: ",
        text: widget.debugXShelfTaskUnitQueue.xShelf.xShelfType.name,
        textStyle: TextStyle(color: Colors.indigo, fontSize: 13),
      ),
    );
  }

  void _openXShelfDialog() {
    XShelfDialog.open(
      context: context,
      xShelf: widget.debugXShelfTaskUnitQueue.xShelf,
    );
  }
}
