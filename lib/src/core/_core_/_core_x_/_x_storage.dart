part of '../core.dart';

class XStorage {
  ExecutionIntent? _executionIntent;

  bool get isEmpty {
    return _executionIntent == null;
  }

  bool get isNotEmpty => !isEmpty;

  void _addExecutionIntent(
    ExecutionIntent executionIntent,
  ) {
    _executionIntent = executionIntent;
  }

  _StorageBackendActionExecutionUnit? _getNextExecutionUnit(
      {required bool remove}) {
    if (_executionIntent == null) {
      return null;
    }
    final ExecutionIntent executionIntent = _executionIntent!;
    if (remove) {
      _executionIntent = null;
    }
    if (executionIntent is StorageBackendActionIntent) {
      return _StorageBackendActionExecutionUnit(
        executionIntent: executionIntent,
      );
    } else {
      throw "TODO - _getNextExecutionUnit - 1";
    }
  }
}
