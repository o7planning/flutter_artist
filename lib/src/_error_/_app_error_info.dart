part of '../../flutter_artist.dart';

class AppErrorInfo {
  final AppError error;
  final String? methodName;
  final StackTrace? stackTrace;

  AppErrorInfo({
    required this.error,
    required this.methodName,
    required this.stackTrace,
  });
}
