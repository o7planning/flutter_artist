import 'package:flutter/material.dart';
import 'package:flutter_artist/src/core/enums/debug_btn_type.dart';

import '../../../../core/_core_/core.dart';
import '_base_info_widget.dart';

class BlockItemDataStateInfoWidget extends BaseInfoWidget {
  final Block block;

  const BlockItemDataStateInfoWidget({
    super.key,
    required this.block,
    required super.labelStyle,
    required super.textStyle,
  });

  @override
  String? getButtonTooltip() {
    return block.blockItemDataState.toBriefInfo();
  }

  @override
  String getLabel() {
    return "Item State: ";
  }

  @override
  String? getLeftTooltip() {
    return block.blockItemDataState.toBriefInfo();
  }

  @override
  String getText() {
    return block.blockItemDataState.toBriefInfo();
  }

  @override
  ButtonFunction? getButtonFunction() {
    switch (block.blockItemDataState) {
      case BlockItemDataStateNone():
        return null;
      case BlockItemDataStateFresh():
        return null;
      case BlockItemDataStateStale(:final errorInfo):
        if (errorInfo == null) {
          return null;
        }
        return ButtonFunction(
          btnType: DebugBtnType.error,
          onPressed: (BuildContext context) {
            block.showBlockErrorViewerDialog(context);
          },
        );
    }
  }
}
