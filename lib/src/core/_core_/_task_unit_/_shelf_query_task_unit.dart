part of '../core.dart';

@_TaskUnitClassAnnotation()
@_ShelfQueryAnnotation()
class _ShelfQueryTaskUnitOLD extends _TaskUnit {
  _XShelf xShelf;

  _ShelfQueryTaskUnitOLD({
    required this.xShelf,
  }) : super(
          taskType: TaskType.shelfQuery,
        );

  @override
  int get xShelfId => xShelf.xShelfId;

  @override
  Shelf get shelf => xShelf.shelf;

  @override
  Shelf get owner => xShelf.shelf;

  @override
  String getObjectName() {
    return xShelf.shelf.name;
  }
}

@_TaskUnitClassAnnotation()
@_ShelfQueryAnnotation()
class _ShelfQueryTaskUnit extends _TaskUnit {
  _QShelf xShelf;

  _ShelfQueryTaskUnit({
    required this.xShelf,
  }) : super(
          taskType: TaskType.shelfQuery,
        );

  @override
  int get xShelfId => xShelf.xShelfId;

  @override
  Shelf get shelf => xShelf.shelf;

  @override
  Shelf get owner => xShelf.shelf;

  @override
  String getObjectName() {
    return xShelf.shelf.name;
  }
}
