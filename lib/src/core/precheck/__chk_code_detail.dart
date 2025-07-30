import '../_core/annotation/annotation.dart';
import '__chk_code.dart';

@RenameAnnotation()
abstract interface class ChkCodeDetail {
  ChkCode get chkCode;

  String get message;

  List<String>? get details;
}
