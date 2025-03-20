part of '../flutter_artist.dart';

///
/// FormModel with Query Options
///
class _FormModelOpt {
  final FormModel formModel;

  _FormModelOpt({
    required this.formModel,
  });

  @override
  String toString() {
    return "${getClassName(this)}(${getClassName(formModel)})";
  }
}
