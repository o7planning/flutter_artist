part of '../../core.dart';

class _LazyFormModel {
  final FormModel formModel;

  _LazyFormModel({required this.formModel});

  @override
  String toString() {
    return "(${formModel.block.name})";
  }
}
