part of '../../flutter_artist.dart';

@_FilterViewChangeAnnotation()
class _FilterViewChangeTaskUnit extends _TaskUnit {
  _XFilterModel xFilterModel;

  _FilterViewChangeTaskUnit({
    required this.xFilterModel,
  }) : super(taskType: TaskType.filterModelFilterViewChanged);

  @override
  int get xShelfId => xFilterModel.xShelfId;

  @override
  Shelf get shelf => xFilterModel.filterModel.shelf;

  @override
  FilterModel get owner => xFilterModel.filterModel;

  @override
  String getObjectName() {
    return xFilterModel.filterModel.name;
  }
}
