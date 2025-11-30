part of '../../core.dart';

class _LazyFilterModel {
  final FilterModel filterModel;

  _LazyFilterModel({required this.filterModel});

  String toDebugString() {
    return _debugObjHtml(filterModel);
  }
}
