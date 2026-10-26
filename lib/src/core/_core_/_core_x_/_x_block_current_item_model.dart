part of '../core.dart';

class XBlockCurrentItemModel<
    ID extends Comparable, //
    ITEM extends Identifiable<ID>,
    ITEM_DETAIL extends Identifiable<ID>> {
  late final XBlock<
      ID, //
      ITEM,
      ITEM_DETAIL> xBlock;

  final XBlockFormModel? xBlockFormModel;

  XShelf get xShelf => xBlock.xShelf;

  int get xModuleId => xShelf.xModuleId;

  BlockExecutionIntent<
      ID, //
      ITEM,
      ITEM_DETAIL,
      dynamic,
      ExecutionUnitResult<dynamic>>? _stashedIntent;

  BlockExecutionIntent<
      ID, //
      ITEM,
      ITEM_DETAIL,
      dynamic,
      ExecutionUnitResult<dynamic>>? _executionIntent;

  BlockSetCurrentItemIntent<
      ID, //
      ITEM,
      ITEM_DETAIL>? _pendingSetCurrentItemIntent;

  final BlockCurrentItemModel<
      ID, //
      ITEM,
      ITEM_DETAIL,
      FilterInput,
      FilterCriteria,
      CreationPreset,
      FormInput> blockCurrentItemModel;

  XBlockCurrentItemModel({
    required this.blockCurrentItemModel,
    required this.xBlockFormModel,
  });

  // ***************************************************************************
  // ***************************************************************************

  NxtExecutionUnit _getNextExecutionUnit({required bool debug}) {
    NxtExecutionUnit next = __getNextExecutionUnit(debug: debug);
    if (next.yes) {
      return next;
    }
    if (xBlockFormModel != null) {
      next = xBlockFormModel!._getNextExecutionUnit(debug: debug);
      if (next.yes) {
        return next;
      }
    }
    return next;
  }

  // ***************************************************************************
  // ***************************************************************************

  // BlockCurrentItemModel only (Not find in FormModel).
  NxtExecutionUnit __getNextExecutionUnit({required bool debug}) {
    throw UnimplementedError();
  }
}
