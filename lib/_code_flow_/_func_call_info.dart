part of '../flutter_artist.dart';

class FuncCallInfo {
  final String funcName;
  final String? callerFuncName;
  final String? filePath;
  final int? lineNumber;
  final int? columnNumber;
  final Map<String, dynamic>? arguments;

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
  })  : callerFuncName = null,
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
    // print("STACK TRACE: $currentStackTrace");
    final frames = currentStackTrace.toString().split('\n');

    String? myLine1; // First line not startWith "dart-sdk/"
    String? myLine2; // Second line not startWith "dart-sdk/"
    for (String frame in frames) {
      String line = frame.trim();
      if (line.startsWith("dart-sdk/")) {
        continue;
      } else {
        if (myLine1 == null) {
          myLine1 = line;
        } else if (myLine2 == null) {
          myLine2 = line;
          break;
        }
      }
    }
    _TraceLineInfo? info1;
    _TraceLineInfo? info2;
    if (myLine1 != null) {
      info1 = _TraceLineInfo.parseLine(myLine1);
    }
    if (myLine2 != null) {
      info2 = _TraceLineInfo.parseLine(myLine2);
    }
    //
    _TraceLineInfo? info;
    if (info1 != null && info1.isNamedFunction) {
      info = info1;
    } else if (info2 != null && info2.isNamedFunction) {
      info = info2;
    } else {
      info = info1;
    }
    //
    return FuncCallInfo._(
      funcName: info?.functionName ?? "-",
      callerFuncName: null,
      filePath: info?.filePath ?? "_",
      lineNumber: info?.lineNumber ?? -1,
      columnNumber: info?.columnNumber ?? -1,
      arguments: null,
    );
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

// packages/flutter_leantek/screens/okr_manager/filter/a.dart 128:66  [_onSelectTimeFrame]
// packages/flutter_leantek/screens/okr_manager/filter/a.dart 59:9    <fn>
class _TraceLineInfo {
  String filePath;
  int lineNumber;
  int columnNumber;
  String functionName;

  _TraceLineInfo({
    required this.filePath,
    required this.lineNumber,
    required this.columnNumber,
    required this.functionName,
  });

  bool get isNamedFunction {
    return functionName != "<fn>";
  }

  static _TraceLineInfo parseLine(String traceLine) {
    final idx = traceLine.indexOf(' ');
    final String filePath = traceLine.substring(0, idx).trim();

    // 128:66  [_onSelectTimeFrame]
    // 59:9    <fn>
    final suffix = traceLine.substring(idx).trim();
    final idx2 = suffix.indexOf(' ');
    // 128:66
    // 59:9
    final List<String> rowCol = suffix.substring(0, idx2).trim().split(":");
    final int lineNumber = int.parse(rowCol[0]);
    final int columnNumber = int.parse(rowCol[1]);

    // [_onSelectTimeFrame]
    // <fn>
    final String fName = suffix.substring(idx2).trim();
    //
    final String functionName;
    if (fName.startsWith("[")) {
      functionName = fName.substring(1, fName.length - 1);
    } else {
      functionName = fName;
    }
    return _TraceLineInfo(
      filePath: filePath,
      lineNumber: lineNumber,
      columnNumber: columnNumber,
      functionName: functionName,
    );
  }

  @override
  String toString() {
    return "[$functionName, $lineNumber]";
  }
}
