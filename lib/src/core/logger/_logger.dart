import 'package:flutter_artist_core/flutter_artist_core.dart';

import '../_core_/core.dart';

class Logger {
  bool __viewed = true;
  int __recentErrorCount = 0;
  int __recentWarningCount = 0;

  int __totalErrorCount = 0;
  int __totalWarningCount = 0;

  final int maxDisplayLogEntryCount;

  final List<LogEntry> __logEntries = [];

  bool get viewed => __viewed;

  int get recentLogCount => __recentErrorCount + __recentWarningCount;

  int get recentErrorCount => __recentErrorCount;

  int get recentWarningCount => __recentWarningCount;

  int get totalLogCount => __totalErrorCount + __totalWarningCount;

  int get totalErrorCount => __totalErrorCount;

  int get totalWarningCount => __totalWarningCount;

  LogSummary get logSummary => LogSummary(
        viewed: __viewed,
        recentErrorCount: __recentErrorCount,
        recentWarningCount: __recentWarningCount,
        totalErrorCount: __totalErrorCount,
        totalWarningCount: __totalWarningCount,
      );

  Logger({required this.maxDisplayLogEntryCount});

  List<LogEntry> get logEntries => List.unmodifiable(__logEntries);

  LogEntry? get lastEntry => __logEntries.isEmpty ? null : __logEntries.first;

  void setViewed() {
    __viewed = true;
    __recentErrorCount = 0;
    __recentWarningCount = 0;
    FlutterArtist.internalNotifyLog();
  }

  void clear() {
    __viewed = true;
    __recentErrorCount = 0;
    __recentWarningCount = 0;
    __totalErrorCount = 0;
    __totalWarningCount = 0;
  }

  LogEntry addError({
    required String? shelfName,
    required String? methodName,
    required String errorMessage,
    required List<String>? errorDetails,
    required StackTrace? stackTrace,
  }) {
    __viewed = false;
    __recentErrorCount++;
    __totalErrorCount++;
    final errorInfo = ErrorInfo(
      errorMessage: errorMessage,
      errorDetails: [],
      stackTrace: stackTrace,
    );
    final logEntry = LogEntry.error(
      shelfName: shelfName,
      methodName: methodName,
      errorInfo: errorInfo,
    );
    if (__logEntries.length > maxDisplayLogEntryCount) {
      __logEntries.removeLast();
    }
    __logEntries.insert(0, logEntry);
    FlutterArtist.internalNotifyLog();
    return logEntry;
  }

  LogEntry addWarning({
    required String? shelfName,
    required String? methodName,
    required String warningMessage,
    required StackTrace? stackTrace,
  }) {
    __viewed = false;
    __recentWarningCount++;
    __totalWarningCount++;
    final logEntry = LogEntry.warning(
      shelfName: shelfName,
      methodName: methodName,
      warningInfo: WarningInfo(
        warningMessage: warningMessage,
        stackTrace: stackTrace,
      ),
    );
    if (__logEntries.length > maxDisplayLogEntryCount) {
      __logEntries.removeLast();
    }
    __logEntries.insert(0, logEntry);
    FlutterArtist.internalNotifyLog();
    return logEntry;
  }
}
