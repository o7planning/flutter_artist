part of '../core.dart';

@_TaskUnitClassAnnotation()
@_ShelfInternalReactAnnotation()
class _ShelfInternalReactTaskUnit extends _TaskUnit {
  final XShelf _xShelf;
  final EffectedShelfMembers shelfInternalListeners;

  _ShelfInternalReactTaskUnit({
    required XShelf xShelf,
    required this.shelfInternalListeners,
  })  : _xShelf = xShelf,
        super(
          taskType: TaskType.shelfInternalReact,
        );

  @override
  XShelf get xShelf => _xShelf;

  @override
  int get xShelfId => _xShelf.xShelfId;

  @override
  Shelf get shelf => _xShelf.shelf;

  @override
  Shelf get owner => _xShelf.shelf;

  @override
  String getObjectName() {
    return _xShelf.shelf.name;
  }
}
