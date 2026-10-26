part of '../core.dart';

class BlockCurrentItemModel<
    ID extends Comparable,
    ITEM extends Identifiable<ID>,
    ITEM_DETAIL extends Identifiable<ID>,
    FILTER_INPUT extends FilterInput, // EmptyFilterInput
    FILTER_CRITERIA extends FilterCriteria, // EmptyFilterCriteria
    CREATION_PRESET extends CreationPreset, // EmptyCreationPreset
    FORM_INPUT extends FormInput // EmptyFormInput
    > extends _Core {
  String get name => block.name;

  _BlockItem2Wrap<ID, ITEM, ITEM_DETAIL> __current = _BlockItem2Wrap.ofNull();

  _BlockItem2Wrap<ID, ITEM, ITEM_DETAIL> get current => __current;


  _BlockItemSyncSessionState<ID>? _blockItemSyncSessionState;

  _BlockItemSyncSessionState<ID>? get blockItemSyncSessionState =>
      _blockItemSyncSessionState;

  final Block<
      ID, //
      ITEM,
      ITEM_DETAIL,
      FILTER_INPUT,
      FILTER_CRITERIA,
      CREATION_PRESET,
      FORM_INPUT> block;

  final BlockFormModel<
      ID, //
      ITEM_DETAIL,
      CREATION_PRESET,
      FORM_INPUT,
      FormOutput,
      AdditionalFormRelatedData>? formModel;

  BlockCurrentItemModel({required this.block, required this.formModel}) {
    formModel?.blockCurrentItemModel = this;
  }

  XBlockCurrentItemModel _createXBlockCurrentItemModel({
    required XBlockFormModel<ID, ITEM_DETAIL>? xBlockFormModel,
  }) {
    return XBlockCurrentItemModel<
        ID, //
        ITEM,
        ITEM_DETAIL>(
      blockCurrentItemModel: this,
      xBlockFormModel: xBlockFormModel,
    );
  }


  // ***************************************************************************

  void _resetBlockItemSyncSessionState({
    required ExecutionTrace? executionTrace,
  }) {
    block.blockCurrentItemModel._blockItemSyncSessionState = null;
  }

}
