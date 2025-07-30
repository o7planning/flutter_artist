import 'package:flutter/material.dart';

import '../../core/_core/code.dart';

class CodeFlowFuncTraceInfoView extends StatelessWidget {
  final FuncCallInfo funcCallInfo;

  const CodeFlowFuncTraceInfoView({required this.funcCallInfo});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Location:",
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 5),
        SelectableText(
          " - ${funcCallInfo.filePath ?? ''}",
          style: const TextStyle(fontSize: 12),
        ),
        const SizedBox(height: 5),
        SelectableText(
          " - Line/Column: ${funcCallInfo.lineNumber ?? '-'}:${funcCallInfo.columnNumber ?? '-'}",
          style: const TextStyle(fontSize: 12),
        ),
      ],
    );
  }
}
