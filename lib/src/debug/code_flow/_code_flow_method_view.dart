import 'package:flutter/material.dart';

import '../../core/_core_/core.dart';

class CodeFlowMethodView extends StatelessWidget {
  final MethodCallExecutionTrace executionTrace;

  const CodeFlowMethodView({
    super.key,
    required this.executionTrace,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      horizontalTitleGap: 5,
      dense: true,
      visualDensity: const VisualDensity(
        horizontal: -3,
        vertical: -3,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 5),
      leading: Icon(
        executionTrace.titleIconData(),
        color: executionTrace.titleIconColor(),
        size: 18,
      ),
      title: SelectableText(
        executionTrace.getTitle(),
        style: _titleStyle(),
      ),
      subtitle: SelectableText(
        executionTrace.getSubtitle(),
        style: _subtitleStyle(),
      ),
    );
  }

  TextStyle _titleStyle() {
    return TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.normal,
      color: Colors.black,
      overflow: TextOverflow.ellipsis,
    );
  }

  TextStyle _subtitleStyle() {
    return TextStyle(
      fontSize: 11,
      fontWeight: FontWeight.normal,
      overflow: TextOverflow.ellipsis,
    );
  }
}
