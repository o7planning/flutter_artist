import 'package:flutter_artist_core/flutter_artist_core.dart';

import '../_fa_core.dart';

class ErrorLogger {
  int _errorCount = 0;
  final int maxDisplayErrorCount;
  final List<LogErrorInfo> _errorInfos = [];

  int get errorCount => _errorCount;

  ErrorLogger({required this.maxDisplayErrorCount});

  List<LogErrorInfo> get errorInfos => [..._errorInfos];

  LogErrorInfo? get lastError => _errorInfos.isEmpty ? null : _errorInfos.first;

  LogErrorInfo addError({
    required String? shelfName,
    required String? methodName,
    required String errorMessage,
    required List<String>? errorDetails,
    required StackTrace? stackTrace,
  }) {
    final errorInfo = LogErrorInfo(
      id: ++_errorCount,
      shelfName: shelfName,
      methodName: methodName,
      errorMessage: errorMessage,
      errorDetails: errorDetails,
      stackTrace: stackTrace,
    );
    if (_errorInfos.length > maxDisplayErrorCount) {
      _errorInfos.removeLast();
    }
    _errorInfos.insert(0, errorInfo);
    FlutterArtist.internalIncreaseTotalErrorCount();
    FlutterArtist.internalNotifyError();
    return errorInfo;
  }
}
