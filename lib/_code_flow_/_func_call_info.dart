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

  // dart-sdk/lib/_internal/js_dev_runtime/patch/core_patch.dart 702:28   get current
  // packages/flutter_leantek/screens/okr_manager/filter/a.dart 128:66  [_onSelectTimeFrame]
  // packages/flutter_leantek/screens/okr_manager/filter/a.dart 59:9    <fn>
  factory FuncCallInfo.fromCurrentStackTrace({
    required StackTrace currentStackTrace,
    required Map<String, dynamic>? arguments,
  }) {
    final frames = currentStackTrace.toString().split('\n');
    final String frame0 = frames[0].trim();
    final String frame1 = frames.length > 1 ? frames[1] : "";
    final String frame2 = frames.length > 2 ? frames[2] : "";
    //
    String line1;
    String line2;
    if (frame0.startsWith("dart-sdk/")) {
      line1 = frame1.trim();
      line2 = frame2.trim();
    } else {
      line1 = frame0.trim();
      line2 = frame1.trim();
    }

    final _TraceLineInfo info1 = _TraceLineInfo.parseLine(line1);
    final _TraceLineInfo info2 = _TraceLineInfo.parseLine(line2);

    return FuncCallInfo._(
      funcName: info1.functionName,
      callerFuncName: info2.functionName,
      filePath: info1.filePath,
      lineNumber: info1.lineNumber,
      columnNumber: info1.columnNumber,
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
}
