part of '../core.dart';

@_TaskUnitClassAnnotation()
@_ShelfInternalReactAnnotation()
class _ShelfExternalReactTaskUnit extends _TaskUnit {
  final int _xShelfId;
  final _XShelf _xShelf;
  final EffectedShelfMembers shelfInternalListeners;

  _ShelfExternalReactTaskUnit({
    required _XShelf xShelf,
    required this.shelfInternalListeners,
  })  : _xShelf = xShelf,
        _xShelfId = __xShelfSequence++,
        super(
          taskType: TaskType.shelfInternalReact,
        );

  @override
  _XShelf get xShelf => _xShelf;

  @override
  int get xShelfId => _xShelfId;

  @override
  Shelf get shelf => _xShelf.shelf;

  @override
  Shelf get owner => _xShelf.shelf;

  @override
  String getObjectName() {
    return _xShelf.shelf.name;
  }
}
