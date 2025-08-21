import 'package:flutter/material.dart';
import 'package:flutter_artist_commons_ui/flutter_artist_commons_ui.dart';

import '../model/_debug_task_unit.dart';

class DebugTaskUnitView extends StatefulWidget {
  final DebugTaskUnit taskUnit;

  const DebugTaskUnitView({
    super.key,
    required this.taskUnit,
  });

  @override
  State<StatefulWidget> createState() {
    return _DebugTaskUnitViewState();
  }
}

class _DebugTaskUnitViewState extends State<DebugTaskUnitView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5),
      margin: EdgeInsets.only(right: 5),
      width: 300,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black26),
        color: Colors.cyan.withAlpha(20),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              IconLabelText(
                label: "Task: ",
                text: widget.taskUnit.taskType.name,
                style: TextStyle(fontSize: 12),
              ),
              Spacer(),
              IconLabelText(
                label: "XShelfID: ",
                text: "${widget.taskUnit.xShelf.xShelfId}",
                style: TextStyle(fontSize: 12),
              ),
            ],
          ),
          Divider(),
          IconLabelText(
            label: "Name: ",
            text: widget.taskUnit.taskName,
            style: TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }
}
