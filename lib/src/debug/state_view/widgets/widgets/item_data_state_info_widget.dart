import 'package:flutter/material.dart';

import '../../../../core/_core_/core.dart';
import '../../../../core/enums/_enums.dart';
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
    return block.blockCurrentItemModel.dataState.toBriefInfo();
  }

  @override
  String getLabel() {
    return "Item State: ";
  }

  @override
  String? getLeftTooltip() {
    return block.blockCurrentItemModel.dataState.toBriefInfo();
  }

  @override
  String getText() {
    return block.blockCurrentItemModel.dataState.toBriefInfo();
  }

  @override
  ButtonFunction? getButtonFunction() {
    switch (block.blockCurrentItemModel.dataState) {
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
