part of '../../flutter_artist.dart';

class _FormTempError {
  final FormErrorMethod formErrorMethod;
  final AppError error;
  final StackTrace stackTrace;
  final String? propName;

  _FormTempError({
    required this.propName,
    required this.formErrorMethod,
    required Object error,
    required this.stackTrace,
  }) : error = ErrorUtils.toAppError(error);
}
