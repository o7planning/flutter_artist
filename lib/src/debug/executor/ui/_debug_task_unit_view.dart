import 'package:flutter/material.dart';
import 'package:flutter_artist_commons_ui/flutter_artist_commons_ui.dart';

import '../model/_debug_execution_unit.dart';

class DebugExecutionUnitView extends StatefulWidget {
  final DebugExecutionUnit executionUnit;
  final bool isInMainQueue;

  const DebugExecutionUnitView({
    super.key,
    required this.executionUnit,
    required this.isInMainQueue,
  });

  @override
  State<StatefulWidget> createState() {
    return _DebugExecutionUnitViewState();
  }
}

class _DebugExecutionUnitViewState extends State<DebugExecutionUnitView> {
  final double fontSize = 14;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5),
      margin: EdgeInsets.only(right: 5),
      width: 300,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black26,
        ),
        color:
            widget.isInMainQueue ? Colors.cyan.withAlpha(20) : Colors.black12,
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
                text: widget.executionUnit.executionUnitType.name,
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
              //     child: Text("${widget.executionUnit.xShelf.xShelfId}"),
              //   ),
              // ),
            ],
          ),
          Divider(),
          IconLabelText(
            label: "Name: ",
            text: widget.executionUnit.taskName,
            style: TextStyle(fontSize: fontSize),
          ),
        ],
      ),
    );
  }

// void _showXShelfDialog() {
//   XShelfDialog.showXShelfDialog(
//     context: context,
//     xShelf: widget.executionUnit.xShelf,
//   );
// }
}
