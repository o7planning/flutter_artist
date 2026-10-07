part of '../core.dart';

class XApp {
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

  _AppBackendActionExecutionUnit? _getNextExecutionUnit(
      {required bool remove}) {
    if (_executionIntent == null) {
      return null;
    }
    final ExecutionIntent executionIntent = _executionIntent!;
    if (remove) {
      _executionIntent = null;
    }
    if (executionIntent is AppBackendActionIntent) {
      return _AppBackendActionExecutionUnit(
        executionIntent: executionIntent,
      );
    } else {
      throw "TODO - _getNextExecutionUnit - 1";
    }
  }
}
