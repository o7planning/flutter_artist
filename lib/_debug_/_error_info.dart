part of '../flutter_artist.dart';

class ErrorInfo {
  final int id;
  final String? frameName;
  final String message;
  final List<String>? errorDetails;
  final StackTrace? stackTrace;

  ErrorInfo({
    required this.id,
    required this.frameName,
    required this.message,
    required this.errorDetails,
    required this.stackTrace,
  });
}
