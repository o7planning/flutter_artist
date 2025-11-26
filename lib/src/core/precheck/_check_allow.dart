import 'package:flutter_artist_core/flutter_artist_core.dart';

enum CheckAllow {
  allow,
  notAllow,
  error;
}

class CheckAllowResult {
  final CheckAllow result;
  final ErrorInfo? errorInfo;

  CheckAllowResult.allow()
      : result = CheckAllow.allow,
        errorInfo = null;

  CheckAllowResult.notAllow()
      : result = CheckAllow.notAllow,
        errorInfo = null;

  CheckAllowResult.error({required this.errorInfo}) : result = CheckAllow.error;
}
