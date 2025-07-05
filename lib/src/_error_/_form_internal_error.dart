part of '../../flutter_artist.dart';

class _FormInternalError {
  final FormErrorMethod formErrorMethod;
  final Object error;
  final StackTrace stackTrace;
  final String? propName;

  _FormInternalError({
    required this.propName,
    required this.formErrorMethod,
    required this.error,
    required this.stackTrace,
  });
}
