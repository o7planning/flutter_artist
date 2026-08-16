import 'package:flutter/material.dart';
import 'package:flutter_artist/src/core/enums/debug_btn_type.dart';
import 'package:flutter_artist_commons_ui/flutter_artist_commons_ui.dart';
import 'package:flutter_artist_styles/flutter_artist_styles.dart';

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
    return null;
  }

  @override
  String getLabel() {
    return "Data State: ";
  }

  @override
  String? getLeftTooltip() {
    return null;
  }

  @override
  String getText() {
    return block.dataState.name;
  }

  @override
  ButtonFunction? getButtonFunction() {
    switch (block.dataState) {
      case BlockDataStateNone():
        return null;
      case BlockDataStatePending(reason: PendingReasonInitial()):
        return null;
      case BlockDataStatePending(
          reason: PendingReasonFetchFailed(errorInfo: null)
        ):
        return null;
      case BlockDataStatePending(
          reason: PendingReasonFetchFailed(:final errorInfo?)
        ):
        return ButtonFunction(
          btnType: DebugBtnType.error,
          onPressed: (BuildContext context) {
            block.showBlockErrorViewerDialog(context);
          },
        );
      case BlockDataStateLoadedFresh(:final transientErrorInfo ):
        if(transientErrorInfo == null) {
          return null;
        }
        return ButtonFunction(
          btnType: DebugBtnType.warning,
          onPressed: (BuildContext context) {
            // block.showBlockErrorViewerDialog(context);
          },
        );
      case BlockDataStateLoadedStale(reason: LoadedStateStaleReasonEvent()):
        return null;
      case BlockDataStateLoadedStale(
          reason: LoadedStateStaleReasonFetchFailed(errorInfo: null)
        ):
        return null;
      case BlockDataStateLoadedStale(
          reason: LoadedStateStaleReasonFetchFailed(:final errorInfo?)
        ):
        return ButtonFunction(
          btnType: DebugBtnType.error,
          onPressed: (BuildContext context) {
            block.showBlockErrorViewerDialog(context);
          },
        );
    }
  }
}
