part of '../core.dart';

class _StageDebugInfo {
  final Stage _stage;

  int _lazyLoadCount = 0;

  int get lazyLoadCount => _lazyLoadCount;

  int _performLoadInitDataCount = 0;

  int get performLoadInitDataCount => _performLoadInitDataCount;

  String get classDefinition {
    return "${getClassName(_stage)}$classParametersDefinition";
  }

  String get classParametersDefinition {
    return "<${_stage.getStageEnumType()}, ${_stage.getInitDataType()}, ${_stage
        .getResultDataType()}, "
        "${_stage.getProzessContextDataType()}, ${_stage.getFormInputType()}>";
  }

  _StageDebugInfo({required Stage stage}) : _stage = stage;
}
