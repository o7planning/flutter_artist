part of '../../core.dart';

@_ExecutionUnitClassAnnotation()
@_BlockBackendActionAnnotation()
class _BlockBackendActionExecutionUnit
    extends _ShelfMemberResultedExecutionUnit<BlockBackendActionResult> {
  final XBlock xBlock;
  final BlockBackendAction action;

  _BlockBackendActionExecutionUnit({
    required this.xBlock,
    required this.action,
  }) : super(
          executionUnitType: ExecutionUnitType.blockBackendAction,
          executionUnitResult: BlockBackendActionResult(),
        );

  @override
  BlockTodo? get executionTodo => null;


  @override
  XShelf get xShelf => xBlock.xShelf;

  @override
  int get xShelfId => xBlock.xShelfId;

  @override
  Shelf get shelf => xBlock.block.shelf;

  @override
  Block get owner => xBlock.block;

  @override
  String getObjectName() {
    return xBlock.block.name;
  }

 }
