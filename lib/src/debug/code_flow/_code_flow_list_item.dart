import 'package:flutter/material.dart';

import '../../core/_core_/core.dart';
import '__code_flow_const.dart';
import '_code_flow_info_error_view.dart';
import '_code_flow_method_view.dart';

class CodeFlowListItem extends StatelessWidget {
  final CodeFlowItem codeFlowItem;
  final bool selected;

  final Function() onTap;

  const CodeFlowListItem({
    required this.codeFlowItem,
    required this.selected,
    required this.onTap,
    required super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: _backgroundColor(),
      child: codeFlowItem.isMethodCall()
          ? CodeFlowMethodView(
              codeFlowItem: codeFlowItem,
              selected: selected,
              textSelectable: false,
              onTap: onTap,
            )
          : CodeFlowInfoErrorView(
              codeFlowItem: codeFlowItem,
              textOverflow: TextOverflow.ellipsis,
              selected: selected,
              onTap: onTap,
            ),
    );
  }

  Color _backgroundColor() {
    return selected
        ? CodeFlowConstants.selectedCodeFlowItemBgColor
        : CodeFlowConstants.deselectedCodeFlowItemBgColor;
  }
}
