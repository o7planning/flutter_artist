part of '../../flutter_artist.dart';

abstract class QuickCreateMultiItemsAction<
    ID extends Object, //
    ITEM extends Object,
    ITEM_DETAIL extends Object,
    FILTER_CRITERIA extends FilterCriteria> extends BaseAction {
  const QuickCreateMultiItemsAction({
    required super.needToConfirm,
    required super.actionInfo,
  });

  Future<ApiResult<PageData<ITEM>>> callApiQuickCreateMultiItems({
    required Object? parentBlockItem,
    required FILTER_CRITERIA filterCriteria,
  });
}
