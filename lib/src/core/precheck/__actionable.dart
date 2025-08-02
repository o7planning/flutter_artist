import '../utils/_class_utils.dart';
import '__precheck.dart';

class Actionable<ENUM extends Precheck> {
  final bool yes;

  final ENUM? errCode;
  final StackTrace? stackTrace;

  bool get no => !yes;

  Actionable.yes()
      : errCode = null,
        stackTrace = null,
        yes = true;

  Actionable.no({
    required ENUM this.errCode,
    this.stackTrace,
  }) : yes = false;

  String? get message => errCode?.message;

  List<String>? get details => errCode?.details;

  @override
  String toString() {
    return "${getClassName(this)}.$yes";
  }
}
