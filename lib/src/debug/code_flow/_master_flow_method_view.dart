import 'package:flutter/material.dart';

import '../../core/_core_/core.dart';
import '../../core/icon/icon_constants.dart';
import '../../core/utils/_class_utils.dart';
import '__task_flow_const.dart';

class CodeFlowMethodView extends StatelessWidget {
  final MasterFlowItem masterFlowItem;

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
        _titleIconData(),
        color: _titleIconColor(),
        size: 18,
      ),
      title: SelectableText(
        getClassName(masterFlowItem.ownerClassInstance),
        style: _titleStyle(),
      ),
      subtitle: SelectableText(
        ".${masterFlowItem.funcCallInfo?.funcName}()",
        style: _subtitleStyle(),
      ),
    );
  }

  TextStyle _titleStyle() {
    return TextStyle(
      fontSize: 12,
      fontWeight: masterFlowItem.isPublicMethodCall()
          ? FontWeight.bold
          : FontWeight.normal,
      color: Colors.black,
      overflow: TextOverflow.ellipsis,
    );
  }

  TextStyle _subtitleStyle() {
    return TextStyle(
      fontSize: 11,
      fontWeight: masterFlowItem.isPublicMethodCall()
          ? FontWeight.bold
          : FontWeight.normal,
      overflow: TextOverflow.ellipsis,
    );
  }

  IconData _titleIconData() {
    if (masterFlowItem.isBlock()) {
      return FaIconConstants.blockIconData;
    } else if (masterFlowItem.isFilterModel()) {
      return FaIconConstants.filterModelIconData;
    } else if (masterFlowItem.isFormModel()) {
      return FaIconConstants.formModelIconData;
    } else {
      return FaIconConstants.otherClassIconData;
    }
  }

  Color _titleIconColor() {
    if (masterFlowItem.isLibCode) {
      if (masterFlowItem.isLibPublicMethod) {
        return CodeFlowConstants.libPublicCodeIconColor;
      } else {
        return CodeFlowConstants.libPrivateCodeIconColor;
      }
    } else {
      return CodeFlowConstants.devCodeIconColor;
    }
  }
}
