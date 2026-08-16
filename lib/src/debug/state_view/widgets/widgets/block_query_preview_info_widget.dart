import 'package:flutter/material.dart';

import '../../../../core/_core_/core.dart';
import '../../../../core/enums/debug_btn_type.dart';
import '_base_info_widget.dart';

class BlockQueryPreviewInfoWidget extends BaseInfoWidget {
  final Block block;

  const BlockQueryPreviewInfoWidget({
    super.key,
    required this.block,
    required super.labelStyle,
    required super.textStyle,
  });

  @override
  String? getButtonTooltip() {
    return null;
  }

  @override
  ButtonFunction? getButtonFunction() {
    return ButtonFunction(
        btnType: block.blockSyncSessionState == null
            ? DebugBtnType.success
            : DebugBtnType.warning,
        onPressed: (BuildContext context) {
          block.showDebugSyncSessionState(
            context: context,
          );
        });
  }

  @override
  String getLabel() {
    return "Query Count: ";
  }

  @override
  String? getLeftTooltip() {
    return "performQueryCount / performQueryByItemIdsCount";
  }

  @override
  String getText() {
    return "${block.debug.performQueryCount} / ${block.debug.performQueryByItemIdsCount}";
  }
}
