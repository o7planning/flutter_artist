import 'package:flutter/material.dart';
import 'package:flutter_artist/src/core/enums/debug_btn_type.dart';
import 'package:flutter_artist_commons_ui/flutter_artist_commons_ui.dart';
import 'package:flutter_artist_styles/flutter_artist_styles.dart';

import '../../../../core/_core_/core.dart';
import '_base_info_widget.dart';

class ScalarDataStateInfoWidget extends BaseInfoWidget {
  final Scalar scalar;

  const ScalarDataStateInfoWidget({
    super.key,
    required this.scalar,
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
    return scalar.dataState.name;
  }

  @override
  ButtonFunction? getButtonFunction() {
    switch (scalar.dataState) {
      case ScalarDataStateNone():
        return null;
      case ScalarDataStatePending(reason: ScalarPendingReasonInitial()):
        return null;
      case ScalarDataStatePending(reason: ScalarPendingReasonFailed()):
        return ButtonFunction(
          btnType: DebugBtnType.error,
          onPressed: (BuildContext context) {
            scalar.showScalarErrorViewerDialog(context);
          },
        );
      case ScalarDataStateLoadedFresh(:final transientErrorInfo):
        if (transientErrorInfo == null) {
          return null;
        }
        return ButtonFunction(
          btnType: DebugBtnType.warning,
          onPressed: (BuildContext context) {
            // scalar.showScalarErrorViewerDialog(context);
          },
        );
      case ScalarDataStateLoadedStale(
          reason: ScalarLoadedStateStaleReasonEvent()
        ):
        return null;
      case ScalarDataStateLoadedStale(
          reason: ScalarLoadedStateStaleReasonFailed(errorInfo: null)
        ):
        return null;
      case ScalarDataStateLoadedStale(
          reason: ScalarLoadedStateStaleReasonFailed(:final errorInfo?)
        ):
        return ButtonFunction(
          btnType: DebugBtnType.error,
          onPressed: (BuildContext context) {
            scalar.showScalarErrorViewerDialog(context);
          },
        );
    }
  }
}
