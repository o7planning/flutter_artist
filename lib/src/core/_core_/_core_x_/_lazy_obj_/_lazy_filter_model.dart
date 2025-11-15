part of '../../core.dart';

class _LazyFilterModel {
  final FilterModel filterModel;

  _LazyFilterModel({required this.filterModel});

  @override
  String toString() {
    return "(${filterModel.name})";
  }
}
