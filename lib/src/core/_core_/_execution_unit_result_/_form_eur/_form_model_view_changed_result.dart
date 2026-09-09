part of '../../core.dart';

class FormModelViewChangedResult
    extends ExecutionUnitResult<FormModelViewChangedPrecheck> {
  FormModelViewChangedResult({super.precheck});

  @override
  bool get successForFirst {
    if (precheck != null) {
      return false;
    }
    return errorInfo == null;
  }
}
