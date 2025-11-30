part of '../../core.dart';

class _LazyFormModel {
  final FormModel formModel;

  _LazyFormModel({required this.formModel});

  String toDebugString() {
    return _debugObjHtml(formModel);
  }
}
