part of '../_fa_core.dart';

@_RenameAnnotation()
abstract interface class ChkCodeDetail {
  ChkCode get chkCode;

  String get message;

  List<String>? get details;
}
