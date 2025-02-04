part of '../flutter_artist.dart';

enum DataState {
  ready,
  pending,
  error;
}

extension DataStateExtension on DataState {
  IconData get iconData {
    switch (this) {
      case DataState.ready:
        return _dataStateReadyIconData;
      case DataState.pending:
        return _dataStatePendingIconData;
      case DataState.error:
        return _dataStateErrorIconData;
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
    }
  }
}
