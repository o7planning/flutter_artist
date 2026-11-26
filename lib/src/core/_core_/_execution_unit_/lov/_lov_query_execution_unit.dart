part of '../../core.dart';

@_ExecutionUnitClassAnnotation()
class _LovQueryExecutionUnit<
    ID extends Comparable, //
    ITEM extends Identifiable<ID>> extends _ShelfMemberExecutionUnit {
  final XLovModel<ID, ITEM> xLovModel;

  @override
  final LovQueryIntent<ID, ITEM> executionIntent;

  _LovQueryExecutionUnit({
    required this.xLovModel,
    required this.executionIntent,
  }) : super(
          executionUnitType: ExecutionUnitType.lovQuery,
          executionIntent: executionIntent,
        );

  @override
  XShelf get xShelf => xLovModel.xShelf;

  @override
  int get xModuleId => xLovModel.xModuleId;

  @override
  Shelf get shelf => xLovModel.lovModel.shelf;

  @override
  LovModel get owner => xLovModel.lovModel;

  @override
  String getObjectName() => xLovModel.lovModel.name;

  @override
  String toString() =>
      "${getClassName(this)}(${getClassName(xLovModel.lovModel)})";
}
