part of '../../flutter_artist.dart';

class Actionable<ENUM extends ECodeDetail> {
  final bool yes;

  final ENUM? eCode;
  final StackTrace? stackTrace;

  bool get no => !yes;

  Actionable._({
    required this.yes,
    required this.eCode,
    required this.stackTrace,
  });

  Actionable.yes()
      : eCode = null,
        stackTrace = null,
        yes = true;

  Actionable.no({
    required ENUM this.eCode,
    this.stackTrace,
  }) : yes = false;

  @Deprecated("Delete")
  Actionable _copyWith({required ActionableCode actionableCode}) {
    return Actionable._(
      yes: yes,
      eCode: eCode,
      stackTrace: stackTrace,
    );
  }

  String? get message => eCode?.message;

  List<String>? get details => eCode?.details;

  @override
  String toString() {
    return "${getClassName(this)}.$yes";
  }
}
