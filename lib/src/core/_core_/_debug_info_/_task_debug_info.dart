part of '../core.dart';

class _TaskDebugInfo {
  final Task _task;

  int _lazyLoadCount = 0;

  int get lazyLoadCount => _lazyLoadCount;

  int _performLoadInitDataCount = 0;

  int get performLoadInitDataCount => _performLoadInitDataCount;

  String get classDefinition {
    return "${getClassName(_task)}$classParametersDefinition";
  }

  String get classParametersDefinition {
    return "<${_task.getInitDataType()}, ${_task.getResultDataType()}, "
        "${_task.getCreationPresetType()}, ${_task.getFormInputType()}>";
  }

  _TaskDebugInfo({required Task task}) : _task = task;
}
