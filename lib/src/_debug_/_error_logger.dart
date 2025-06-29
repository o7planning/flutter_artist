part of '../../flutter_artist.dart';

class ErrorLogger {
  int _errorCount = 0;
  final int maxDisplayErrorCount;
  final List<LogErrorInfo> _errorInfos = [];

  int get errorCount => _errorCount;

  ErrorLogger({required this.maxDisplayErrorCount});

  List<LogErrorInfo> get errorInfos => [..._errorInfos];

  LogErrorInfo? get lastError => _errorInfos.isEmpty ? null : _errorInfos.first;

  void addError({
    required String? shelfName,
    required String message,
    required List<String>? errorDetails,
    required StackTrace? stackTrace,
  }) {
    final errorInfo = LogErrorInfo(
      id: ++_errorCount,
      shelfName: shelfName,
      message: message,
      errorDetails: errorDetails,
      stackTrace: stackTrace,
    );
    if (_errorInfos.length > maxDisplayErrorCount) {
      _errorInfos.removeLast();
    }
    _errorInfos.insert(0, errorInfo);
    FlutterArtist._totalErrorCount++;
    FlutterArtist._notifyError();
  }
}
