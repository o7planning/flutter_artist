import 'package:flutter/material.dart';
import 'package:flutter_artist/src/core/enums/debug_btn_type.dart';

import '../../../../core/_core_/core.dart';
import '_base_info_widget.dart';

class BlockDataStateInfoWidget extends BaseInfoWidget {
  final Block block;

  const BlockDataStateInfoWidget({
    super.key,
    required this.block,
    required super.labelStyle,
    required super.textStyle,
  });

  @override
  String? getButtonTooltip() {
    return block.dataState.toBriefInfo();
  }

  @override
  String getLabel() {
    return "Data State: ";
  }

  @override
  String? getLeftTooltip() {
    return block.dataState.toBriefInfo();
  }

  @override
  String getText() {
    return block.dataState.toBriefInfo();
  }

  @override
  ButtonFunction? getButtonFunction() {
    switch (block.dataState) {
      case BlockDataStateNone():
        return null;
      case BlockDataStatePending(reason: BlockPendingReasonInitial()):
        return null;
      case BlockDataStatePending(reason: BlockPendingReasonFailed()):
        return ButtonFunction(
          btnType: DebugBtnType.error,
          onPressed: (BuildContext context) {
            block.showBlockErrorViewerDialog(context);
          },
        );
      case BlockDataStateLoadedFresh(:final transientErrorInfo):
        if (transientErrorInfo == null) {
          return null;
        }
        return ButtonFunction(
          btnType: DebugBtnType.warning,
          onPressed: (BuildContext context) {
            // block.showBlockErrorViewerDialog(context);
          },
        );
      case BlockDataStateLoadedStale(
          reason: BlockLoadedStateStaleReasonEvent()
        ):
        return null;
      case BlockDataStateLoadedStale(
          reason: BlockLoadedStateStaleReasonFailed(
            :final errorOrigin,
            :final errorInfo
          )
        ):
        if (errorInfo != null) {
          return ButtonFunction(
            btnType: DebugBtnType.error,
            onPressed: (BuildContext context) {
              block.showBlockErrorViewerDialog(context);
            },
          );
        }
        return null;
    }
  }
}
