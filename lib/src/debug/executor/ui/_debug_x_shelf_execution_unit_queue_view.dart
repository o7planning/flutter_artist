import 'package:flutter/material.dart';
import 'package:flutter_artist_commons_ui/flutter_artist_commons_ui.dart';

import '../../dialog/_x_shelf_dialog.dart';
import '../model/_debug_x_root_queue_item.dart';
import '_debug_execution_unit_view.dart';

class DebugXShelfExecutionUnitQueueView extends StatefulWidget {
  final DebugXRootQueueItem debugXShelfExecutionUnitQueue;

  const DebugXShelfExecutionUnitQueueView({
    super.key,
    required this.debugXShelfExecutionUnitQueue,
  });

  @override
  State<StatefulWidget> createState() {
    return _DebugXShelfExecutionUnitQueueViewState();
  }
}

class _DebugXShelfExecutionUnitQueueViewState
    extends State<DebugXShelfExecutionUnitQueueView> {
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
                ...widget.debugXShelfExecutionUnitQueue.mainExecutionUnits.map(
                  (executionUnit) => DebugExecutionUnitView(
                      executionUnit: executionUnit, isInMainQueue: true),
                ),
                ...widget.debugXShelfExecutionUnitQueue.secondaryExecutionUnits
                    .map((executionUnit) => DebugExecutionUnitView(
                        executionUnit: executionUnit, isInMainQueue: false))
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
        message:
            "XShelfID: ${widget.debugXShelfExecutionUnitQueue.xShelf.xShelfId}",
        child: CircleAvatar(
          radius: 18,
          child: Center(
            child: Text(
              widget.debugXShelfExecutionUnitQueue.xShelf.xShelfId.toString(),
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
          "Execution Units in the Queue of XShelf (${widget.debugXShelfExecutionUnitQueue.xShelf.shelf.name})"),
      subtitle: IconLabelText(
        label: "XShelf Execution Unit Type: ",
        text: widget.debugXShelfExecutionUnitQueue.xShelf.xShelfType.name,
        textStyle: TextStyle(color: Colors.indigo, fontSize: 13),
      ),
    );
  }

  void _openXShelfDialog() {
    XShelfDialog.show(
      context: context,
      xShelf: widget.debugXShelfExecutionUnitQueue.xShelf,
    );
  }
}
