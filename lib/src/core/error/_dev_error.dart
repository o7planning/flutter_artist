import 'package:flutter_artist_core/flutter_artist_core.dart';

class DevError extends AppError {
  DevError({
    required super.errorMessage,
    super.errorDetails,
  });
}
