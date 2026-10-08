part of '../core.dart';

class _ProzessDebugInfo<
    STAGE_ENUM extends StageEnum, //
    PROZESS_INIT_DATA extends ProzessInitData,
    PROZESS_CONTEXT_DATA extends ProzessContextData> {
  final Prozess<
      STAGE_ENUM, //
      PROZESS_INIT_DATA,
      PROZESS_CONTEXT_DATA> _prozess;

  int _performLoadInitDataCount = 0;

  int get performLoadInitDataCount => _performLoadInitDataCount;

  bool get isStageReexecutionAllowed => _prozess._isStageReexecutionAllowed;

  String get sharedContextInfo {
    return getClassName(_prozess._prozessContextData);
  }

  _ProzessDebugInfo({
    required Prozess<STAGE_ENUM, PROZESS_INIT_DATA, PROZESS_CONTEXT_DATA>
        prozess,
  }) : _prozess = prozess;
}
