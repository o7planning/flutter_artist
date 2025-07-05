part of '../../flutter_artist.dart';

class _FormInternalError {
  final FormErrorMethod formErrorMethod;
  final AppError error;
  final StackTrace stackTrace;
  final String? propName;

  _FormInternalError({
    required this.propName,
    required this.formErrorMethod,
    required Object error,
    required this.stackTrace,
  }) : error = ErrorUtils.toAppError(error);
}
