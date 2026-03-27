import 'package:flutter/material.dart';

import '../../core/_core_/core.dart';
import '__task_flow_const.dart';

class CodeFlowFuncTraceInfoView extends StatelessWidget {
  final FuncCallInfo funcCallInfo;

  const CodeFlowFuncTraceInfoView({super.key, required this.funcCallInfo});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Location:",
          style: codeStyle(context, isBold: true),
        ),
        const SizedBox(height: 5),
        SelectableText(
          " - ${funcCallInfo.filePath ?? ''}",
          style: codeStyle(context, isBold: false),
        ),
        const SizedBox(height: 5),
        SelectableText(
          " - Line/Column: ${funcCallInfo.lineNumber ?? '-'}:${funcCallInfo.columnNumber ?? '-'}",
          style: codeStyle(context, isBold: false),
        ),
      ],
    );
  }
}
