part of '../_fa_core.dart';

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
