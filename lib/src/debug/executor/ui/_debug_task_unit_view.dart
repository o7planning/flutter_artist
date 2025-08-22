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
  final double fontSize = 14;

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
                textStyle: TextStyle(
                  fontSize: fontSize,
                  color: Colors.blue,
                ),
              ),
              // Spacer(),
              // Tooltip(
              //   message: "XShelf ID",
              //   child: ElevatedButton(
              //     style: ElevatedButton.styleFrom(
              //       minimumSize: Size.zero,
              //       padding: EdgeInsets.symmetric(vertical: 2, horizontal: 8),
              //     ),
              //     onPressed: () {
              //       _showXShelfDialog();
              //     },
              //     child: Text("${widget.taskUnit.xShelf.xShelfId}"),
              //   ),
              // ),
            ],
          ),
          Divider(),
          IconLabelText(
            label: "Name: ",
            text: widget.taskUnit.taskName,
            style: TextStyle(fontSize: fontSize),
          ),
        ],
      ),
    );
  }

// void _showXShelfDialog() {
//   XShelfDialog.showXShelfDialog(
//     context: context,
//     xShelf: widget.taskUnit.xShelf,
//   );
// }
}
