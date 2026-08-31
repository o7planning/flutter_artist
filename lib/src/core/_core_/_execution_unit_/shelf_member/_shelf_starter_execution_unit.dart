part of '../../core.dart';

@_ExecutionUnitClassAnnotation()
class _ShelfStarterExecutionUnit extends _ShelfMemberExecutionUnit {
  @override
  final XShelf xShelf;

  _ShelfStarterExecutionUnit({
    required this.xShelf,
  }) : super(
          executionUnitType: ExecutionUnitType.empty,
        );

  @override
  int get xShelfId => xShelf.xShelfId;

  @override
  Shelf get shelf => xShelf.shelf;

  @override
  Shelf get owner => xShelf.shelf;

  @override
  String getObjectName() {
    return getClassName(xShelf);
  }
}
