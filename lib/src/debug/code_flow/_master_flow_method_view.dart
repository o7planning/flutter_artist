import 'package:flutter/material.dart';

import '../../core/_core_/core.dart';
import '../../core/icon/icon_constants.dart';
import '../../core/utils/_class_utils.dart';
import '__task_flow_const.dart';

class CodeFlowMethodView extends StatelessWidget {
  final MethodCallMasterFlowItem masterFlowItem;

  const CodeFlowMethodView({
    super.key,
    required this.masterFlowItem,
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
        masterFlowItem.titleIconData(),
        color: masterFlowItem.titleIconColor(),
        size: 18,
      ),
      title: SelectableText(
        masterFlowItem.getTitle(),
        style: _titleStyle(),
      ),
      subtitle: SelectableText(
        masterFlowItem.getSubtitle(),
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
