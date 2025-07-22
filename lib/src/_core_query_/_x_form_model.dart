part of '../../flutter_artist.dart';

class _XFormModel {
  final _XShelf xShelf;
  _ForceType forceTypeForForm = _ForceType.decidedAtRuntime;
  bool queried = false;
  final FormModel formModel;
  final ExtraFormInput? extraFormInput;

  late final _XBlock xBlock;

  final FormSaveResult _formSaveResult = FormSaveResult();

  int get xShelfId => xShelf.xShelfId;

  _XFormModel({
    required this.xShelf,
    required this.formModel,
    required this.extraFormInput,
  });

  @override
  String toString() {
    return "${getClassName(this)}(${getClassName(
        formModel)} - needQuery: $forceTypeForForm)";
  }
}
