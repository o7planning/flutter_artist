part of '../core.dart';

abstract class AutoStocker<ID extends Object,
    ITEM_DETAIL extends Identifiable<ID>> {
  Type getItemIdType() {
    return ID;
  }

  Type getItemType() {
    return ITEM_DETAIL;
  }

  Future<ApiResult<ITEM_DETAIL>> loadById({
    required ID id,
    required ITEM_DETAIL? oldItem,
  });

  Future<ApiResult<void>> deleteById({required ID id});
}
