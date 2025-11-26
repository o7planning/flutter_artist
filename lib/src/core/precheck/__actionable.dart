import 'package:flutter_artist_core/flutter_artist_core.dart';

import '../utils/_class_utils.dart';
import '__precheck.dart';

class Actionable<ENUM extends Precheck> {
  final bool yes;

  final ENUM? errCode;
  final ErrorInfo? errorInfo;

  bool get no => !yes;

  Actionable.yes()
      : errCode = null,
        errorInfo = null,
        yes = true;

  Actionable.no({
    required ENUM this.errCode,
    this.errorInfo,
  }) : yes = false;

  String? get message => errCode?.message;

  List<String>? get details => errCode?.details;

  @override
  String toString() {
    return "${getClassName(this)}.$yes";
  }
}
