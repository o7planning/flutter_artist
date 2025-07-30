import 'package:flutter/material.dart';

import '../../core/_core_/core.dart';
import '../../core/icon/icon_constants.dart';

class CodeFlowInfoErrorView extends StatelessWidget {
  final CodeFlowItem codeFlowItem;
  final bool selected;
  final Function()? onTap;
  final TextOverflow textOverflow;

  const CodeFlowInfoErrorView({
    super.key,
    required this.codeFlowItem,
    required this.textOverflow,
    required this.selected,
    required this.onTap,
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
        _titleIconData(),
        size: 16,
        color: _titleIconColor(),
      ),
      title: Text(
        _title(),
        style: TextStyle(
          fontSize: 12,
          color: _titleIconColor(),
          overflow: textOverflow,
        ),
      ),
      onTap: onTap,
    );
  }

  Color _titleIconColor() {
    if (codeFlowItem.isError()) {
      return Colors.red;
    } else if (codeFlowItem.isInfo()) {
      return Colors.deepOrangeAccent;
    } else {
      return Colors.black;
    }
  }

  IconData _titleIconData() {
    if (codeFlowItem.isError()) {
      return FaIconConstants.errorIconData;
    } else if (codeFlowItem.isInfo()) {
      return FaIconConstants.infoIconData;
    } else {
      return Icons.question_mark;
    }
  }

  String _title() {
    if (codeFlowItem.isError()) {
      return codeFlowItem.errorInfo?.error?.errorMessage ?? " - ";
    } else if (codeFlowItem.isInfo()) {
      return codeFlowItem.info ?? " - ";
    } else {
      return "TODO";
    }
  }
}
