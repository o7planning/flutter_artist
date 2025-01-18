part of '../flutter_artist.dart';

///
/// BlockForm with Query Options
///
class _BlockFormOpt {
  final BlockForm blockForm;

  _BlockFormOpt({
    required this.blockForm,
  });

  @override
  String toString() {
    return "${getClassName(this)}(${blockForm.block.name})";
  }
}
