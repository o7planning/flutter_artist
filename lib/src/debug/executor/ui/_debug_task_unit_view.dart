import 'package:flutter/material.dart';

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
      decoration: BoxDecoration(
        color: Colors.black26,
      ),
      padding: EdgeInsets.all(10),
      child: Text("Task Unit: ${widget.taskUnit.shelf.name}"),
    );
  }
}
