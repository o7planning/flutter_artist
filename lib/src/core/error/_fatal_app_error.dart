import 'package:flutter_artist_core/flutter_artist_core.dart';

class FatalAppError extends AppError {
  FatalAppError({
    required super.errorMessage,
    super.errorDetails,
  });
}
