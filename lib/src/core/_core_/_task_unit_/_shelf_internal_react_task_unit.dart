part of '../core.dart';

@_TaskUnitClassAnnotation()
@_ShelfInternalReactAnnotation()
class _ShelfInternalReactTaskUnit extends _TaskUnit {
  final int _xShelfId;
  final Shelf _shelf;
  final EffectedShelfMembers shelfInternalListeners;

  _ShelfInternalReactTaskUnit({
    required Shelf shelf,
    required this.shelfInternalListeners,
  })  : _shelf = shelf,
        _xShelfId = __xShelfIdSequence++,
        super(
          taskType: TaskType.shelfInternalReact,
        );

  @override
  int get xShelfId => _xShelfId;

  @override
  Shelf get shelf => _shelf;

  @override
  Shelf get owner => _shelf;

  @override
  String getObjectName() {
    return _shelf.name;
  }
}
