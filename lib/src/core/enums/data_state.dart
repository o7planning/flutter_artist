import 'package:flutter/material.dart';

import '../icon/icon_constants.dart';

enum FilterDataState {
  none,
  pending,
  error,
  loaded;
}

enum FormDataState {
  none,
  pending,
  error,
  loaded;
}

enum ScalarDataState {
  none,
  pending,
  loaded;

  IconData get iconData {
    switch (this) {
      case ScalarDataState.loaded:
        return FaIconConstants.dataStateLoadedIconData;
      case ScalarDataState.pending:
        return FaIconConstants.dataStatePendingIconData;
      case ScalarDataState.none:
        return FaIconConstants.dataStateNoneIconData;
    }
  }

  String get name {
    switch (this) {
      case ScalarDataState.loaded:
        return "loaded";
      case ScalarDataState.pending:
        return "pending";
      case ScalarDataState.none:
        return "none";
    }
  }

  Color get color {
    switch (this) {
      case ScalarDataState.loaded:
        return Colors.indigo;
      case ScalarDataState.pending:
        return Colors.green;
      case ScalarDataState.none:
        return Colors.black12;
    }
  }
}
