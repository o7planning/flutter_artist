part of '__precheck.dart';

enum CheckAllow {
  allow,
  notAllow,
  error;
}

class CheckAllowResult {
  final CheckAllow result;
  final ErrorInfo? errorInfo;

  CheckAllowResult.allowed()
      : result = CheckAllow.allow,
        errorInfo = null;

  CheckAllowResult.notAllowed()
      : result = CheckAllow.notAllow,
        errorInfo = null;

  CheckAllowResult.error({required this.errorInfo}) : result = CheckAllow.error;
}
