part of '../_fa_core.dart';

class _FatalAppError extends AppError {
  _FatalAppError({
    required super.errorMessage,
    super.errorDetails,
  });
}
