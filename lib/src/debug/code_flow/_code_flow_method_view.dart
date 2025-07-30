import 'package:flutter/material.dart';

import '../../core/_core/code.dart';
import '../../core/icon/icon_constants.dart';
import '../../core/utils/_class_utils.dart';
import '__code_flow_const.dart';

class CodeFlowMethodView extends StatelessWidget {
  final CodeFlowItem codeFlowItem;
  final bool selected;
  final bool textSelectable;
  final Function()? onTap;

  const CodeFlowMethodView({
    super.key,
    required this.codeFlowItem,
    required this.textSelectable,
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
        color: _titleIconColor(),
        size: 18,
      ),
      trailing: selected
          ? const Icon(
              Icons.check_box_outlined,
              size: 16,
              color: Colors.deepOrangeAccent,
            )
          : null,
      title: textSelectable
          ? SelectableText(
              _title(),
              style: _titleStyle(),
            )
          : Text(
              _title(),
              style: _titleStyle(),
            ),
      subtitle: textSelectable
          ? SelectableText(
              _subtitle(),
              style: _subtitleStyle(),
            )
          : Text(
              _subtitle(),
              style: _subtitleStyle(),
            ),
      onTap: onTap,
    );
  }

  TextStyle _titleStyle() {
    return TextStyle(
      fontSize: 12,
      fontWeight: codeFlowItem.isPublicMethodCall()
          ? FontWeight.bold
          : FontWeight.normal,
      color: Colors.black,
      overflow: TextOverflow.ellipsis,
    );
  }

  TextStyle _subtitleStyle() {
    return TextStyle(
      fontSize: 11,
      fontWeight: codeFlowItem.isPublicMethodCall()
          ? FontWeight.bold
          : FontWeight.normal,
      overflow: TextOverflow.ellipsis,
    );
  }

  IconData _titleIconData() {
    if (codeFlowItem.isBlock()) {
      return FaIconConstants.blockIconData;
    } else if (codeFlowItem.isFilterModel()) {
      return FaIconConstants.filterModelIconData;
    } else if (codeFlowItem.isFormModel()) {
      return FaIconConstants.formModelIconData;
    } else {
      return FaIconConstants.otherClassIconData;
    }
  }

  Color _titleIconColor() {
    if (codeFlowItem.isLibCode) {
      if (codeFlowItem.isLibPublicMethod) {
        return CodeFlowConstants.libPublicCodeIconColor;
      } else {
        return CodeFlowConstants.libPrivateCodeIconColor;
      }
    } else {
      return CodeFlowConstants.devCodeIconColor;
    }
  }

  String _title() {
    return getClassName(codeFlowItem.ownerClassInstance);
  }

  String _subtitle() {
    return ".${codeFlowItem.funcCallInfo?.funcName}()";
  }
}
