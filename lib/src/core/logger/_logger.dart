import 'package:flutter_artist_core/flutter_artist_core.dart';

import '../_core_/core.dart';

class Logger {
  int __recentErrorCount = 0;
  int __recentWarningCount = 0;

  int __totalErrorCount = 0;
  int __totalWarningCount = 0;

  final int maxStoredLogEntryCount;

  final List<LogEntry> __logEntries = [];

  bool get hasRecentLogEntries =>
      __recentErrorCount != 0 || __recentWarningCount != 0;

  int get recentLogCount => __recentErrorCount + __recentWarningCount;

  int get recentErrorCount => __recentErrorCount;

  int get recentWarningCount => __recentWarningCount;

  int get totalLogCount => __totalErrorCount + __totalWarningCount;

  int get totalErrorCount => __totalErrorCount;

  int get totalWarningCount => __totalWarningCount;

  LogSummary get logSummary => LogSummary(
        recentErrorCount: __recentErrorCount,
        recentWarningCount: __recentWarningCount,
        totalErrorCount: __totalErrorCount,
        totalWarningCount: __totalWarningCount,
      );

  Logger({required this.maxStoredLogEntryCount});

  List<LogEntry> get logEntries => List.unmodifiable(__logEntries);

  LogEntry? get lastEntry => __logEntries.isEmpty ? null : __logEntries.first;

  bool hasRecentLogs() {
    return recentLogCount != 0;
  }

  bool hasRecentErrors() {
    return recentErrorCount != 0;
  }

  bool hasRecentWarnings() {
    return recentWarningCount != 0;
  }

  bool hasLogEntries() {
    return totalLogCount != 0;
  }

  bool hasErrors() {
    return totalErrorCount != 0;
  }

  bool hasWarnings() {
    return totalWarningCount != 0;
  }

  void setViewed() {
    __recentErrorCount = 0;
    __recentWarningCount = 0;
    FlutterArtist.internalNotifyLog();
  }

  void clear() {
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
    required Object? tipDocument,
  }) {
    __recentErrorCount++;
    __totalErrorCount++;
    final errorInfo = ErrorInfo(
      errorMessage: errorMessage,
      errorDetails: errorDetails,
      stackTrace: stackTrace,
    );
    final logEntry = LogEntry.error(
      shelfName: shelfName,
      methodName: methodName,
      errorInfo: errorInfo,
      tipDocument: tipDocument,
    );
    if (__logEntries.length > maxStoredLogEntryCount) {
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
    required Object? tipDocument,
  }) {
    __recentWarningCount++;
    __totalWarningCount++;
    final logEntry = LogEntry.warning(
      shelfName: shelfName,
      methodName: methodName,
      warningInfo: WarningInfo(
        warningMessage: warningMessage,
        stackTrace: stackTrace,
      ),
      tipDocument: tipDocument,
    );
    if (__logEntries.length > maxStoredLogEntryCount) {
      __logEntries.removeLast();
    }
    __logEntries.insert(0, logEntry);
    FlutterArtist.internalNotifyLog();
    return logEntry;
  }
}
