part of '../../flutter_artist.dart';

class Actionable<ENUM extends ECodeDetail> {
  final bool yes;

  final ENUM? errCode;
  final StackTrace? stackTrace;

  bool get no => !yes;

  Actionable._({
    required this.yes,
    required this.errCode,
    required this.stackTrace,
  });

  Actionable.yes()
      : errCode = null,
        stackTrace = null,
        yes = true;

  Actionable.no({
    required ENUM this.errCode,
    this.stackTrace,
  }) : yes = false;

  @Deprecated("Delete")
  Actionable _copyWith({required ActionableCode actionableCode}) {
    return Actionable._(
      yes: yes,
      errCode: errCode,
      stackTrace: stackTrace,
    );
  }

  String? get message => errCode?.message;

  List<String>? get details => errCode?.details;

  @override
  String toString() {
    return "${getClassName(this)}.$yes";
  }
}
