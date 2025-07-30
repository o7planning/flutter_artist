enum CheckAllow {
  allow,
  notAllow,
  error;
}

class CheckAllowResult {
  final CheckAllow result;
  final StackTrace? stackTrace;

  CheckAllowResult.allow()
      : result = CheckAllow.allow,
        stackTrace = null;

  CheckAllowResult.notAllow()
      : result = CheckAllow.notAllow,
        stackTrace = null;

  CheckAllowResult.error({required this.stackTrace})
      : result = CheckAllow.error;
}
