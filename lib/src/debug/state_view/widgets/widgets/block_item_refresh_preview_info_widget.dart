import 'package:flutter/material.dart';
import 'package:flutter_artist/src/core/enums/debug_btn_type.dart';

import '../../../../core/_core_/core.dart';
import '_base_info_widget.dart';

class BlockItemRefreshPreviewInfoWidget extends BaseInfoWidget {
  final Block block;

  const BlockItemRefreshPreviewInfoWidget({
    super.key,
    required this.block,
    required super.labelStyle,
    required super.textStyle,
  });

  @override
  String? getButtonTooltip() {
    return block.blockItemSyncSessionState == null
        ? "Clean item state (No active item sync session)"
        : "Item has accumulated refresh reactions";
  }

  @override
  ButtonFunction? getButtonFunction() {
    return ButtonFunction(
      btnType: block.blockItemSyncSessionState == null
          ? DebugBtnType.success
          : DebugBtnType.warning,
      onPressed: (BuildContext context) {
        block.showDebugItemSyncSessionState(
          context: context,
        );
      },
    );
  }

  @override
  String getLabel() {
    return "Item Refresh Count: ";
  }

  @override
  String? getLeftTooltip() {
    return "performLoadItemDetailByIdCount";
  }

  @override
  String getText() {
    return block.debug.performLoadItemDetailByIdCount.toString();
  }
}
