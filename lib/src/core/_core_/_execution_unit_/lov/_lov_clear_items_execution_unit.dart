part of '../../core.dart';

@_ExecutionUnitClassAnnotation()
class _LovClearItemsExecutionUnit<
    ID extends Comparable, //
    ITEM extends Identifiable<ID>> extends _ShelfMemberExecutionUnit {
  final XLovModel<ID, ITEM> xLovModel;

  @override
  final LovClearItemsIntent<ID, ITEM> executionIntent;

  _LovClearItemsExecutionUnit({
    required this.xLovModel,
    required this.executionIntent,
  }) : super(
          executionUnitType: ExecutionUnitType.lovClear,
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
}
