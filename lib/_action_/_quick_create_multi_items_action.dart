part of '../flutter_artist.dart';

abstract class QuickCreateMultiItemsAction<ITEM extends Object>
    extends BaseAction {
  const QuickCreateMultiItemsAction({
    required super.needToConfirm,
    required super.actionInfo,
  });

  Future<ApiResult<PageData<ITEM>>> callApiQuickCreateMultiItems();
}
