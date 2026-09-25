part of '../core.dart';

class FuncCallInfo {
  final String funcName;
  final String? callerFuncName;
  final String? filePath;
  final int? lineNumber;
  final int? columnNumber;
  final Map<String, dynamic>? arguments;

  static final Map<String, FuncCallInfo> _cache = {};
  static const int _maxCacheSize = 200;

  const FuncCallInfo._({
    required this.funcName,
    required this.callerFuncName,
    required this.filePath,
    required this.lineNumber,
    required this.columnNumber,
    required this.arguments,
  });

  FuncCallInfo({
    required this.funcName,
    this.arguments,
  })
      : callerFuncName = null,
        filePath = null,
        lineNumber = null,
        columnNumber = null;

  //
  // dart-sdk/lib/_internal/js_dev_runtime/patch/core_patch.dart 702:28                      get current
  // packages/flutter_leantek/screens/dashboard/section/my_goals_okr_completion.dart 242:37  <fn>
  // dart-sdk/lib/_internal/js_dev_runtime/patch/async_patch.dart 610:19                     <fn>
  // dart-sdk/lib/_internal/js_dev_runtime/patch/async_patch.dart 634:23                     <fn>
  // dart-sdk/lib/_internal/js_dev_runtime/patch/async_patch.dart 532:3                      _asyncStartSync
  // packages/flutter_leantek/screens/dashboard/section/my_goals_okr_completion.dart 239:16  [_onPressOkrCompletionStatus]
  // packages/flutter_leantek/screens/dashboard/section/my_goals_okr_completion.dart 107:35  <fn>
  //
  factory FuncCallInfo.fromCurrentStackTrace({
    required StackTrace currentStackTrace,
    required Map<String, dynamic>? arguments,
  }) {
    final trace = Trace.from(currentStackTrace);
    final frames = trace.frames;

    final selected = _FuncCallInfoUtils._pickBestFrame(frames);
    final key = _FuncCallInfoUtils._makeKey(selected);

    // ✅ DEV mode:
    if (kDebugMode) {
      return _FuncCallInfoUtils._buildInfo(selected, arguments);
    }

    // ✅ PROD:
    final cached = _cache[key];
    if (cached != null) return cached;

    final info = _FuncCallInfoUtils._buildInfo(selected, arguments);

    // Simple LRU-ish
    if (_cache.length > _maxCacheSize) {
      _cache.clear();
    }

    _cache[key] = info;
    return info;
  }

  bool isPrivateFunc() {
    return funcName.startsWith("_");
  }

  bool isPublicFunc() {
    return !funcName.startsWith("_");
  }

  bool hasTraceInfo() {
    return filePath != null;
  }

  @override
  String toString() {
    return 'FuncCallInfo('
        'functionName: $funcName, '
        'callerFunctionName: $callerFuncName, '
        'filePath: $filePath, '
        'lineNumber: $lineNumber, '
        'columnNumber: $columnNumber)';
  }
}
