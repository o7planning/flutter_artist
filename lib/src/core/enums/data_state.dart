import 'package:flutter/material.dart';

import '../icon/icon_constants.dart';

enum DataState {
  ready,
  pending,
  error,
  none;

  IconData get iconData {
    switch (this) {
      case DataState.ready:
        return FaIconConstants.dataStateReadyIconData;
      case DataState.pending:
        return FaIconConstants.dataStatePendingIconData;
      case DataState.error:
        return FaIconConstants.dataStateErrorIconData;
      case DataState.none:
        return FaIconConstants.dataStateNoneIconData;
    }
  }

  String get name {
    switch (this) {
      case DataState.ready:
        return "ready";
      case DataState.pending:
        return "pending";
      case DataState.error:
        return "error";
      case DataState.none:
        return "none";
    }
  }

  Color get color {
    switch (this) {
      case DataState.ready:
        return Colors.indigo;
      case DataState.pending:
        return Colors.green;
      case DataState.error:
        return Colors.red;
      case DataState.none:
        return Colors.black12;
    }
  }
}
