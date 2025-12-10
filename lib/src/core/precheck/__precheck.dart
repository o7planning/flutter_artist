import '../annotation/annotation.dart';
import '__chk_code.dart';

@RenameAnnotation()
abstract interface class Precheck {
  PrecheckCode get precheckCode;

  String get message;

  List<String>? get details;
}
