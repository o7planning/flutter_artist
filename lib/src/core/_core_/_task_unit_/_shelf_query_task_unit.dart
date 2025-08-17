part of '../core.dart';

@_TaskUnitClassAnnotation()
@_ShelfQueryAnnotation()
class _ShelfQueryTaskUnit extends _TaskUnit {
  final _XShelf _xShelf;

  _ShelfQueryTaskUnit({
    required _XShelf xShelf,
  })  : _xShelf = xShelf,
        super(
          taskType: TaskType.shelfQuery,
        );

  @override
  _XShelf get xShelf => _xShelf;

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
