part of '../flutter_artist.dart';

abstract class QuickChildBlockItemsAction<
    ITEM extends Object, //
    ITEM_DETAIL extends Object> extends BaseAction {
  const QuickChildBlockItemsAction({
    required super.needToConfirm,
    required super.actionInfo,
  });

  Future<ApiResult<ITEM_DETAIL>> callApiChildBlockItems();

  Future<bool> _defaultConfirmation(BuildContext context) async {
    return await dialogs.showConfirmDialog(
      context: context,
      message: 'Are you sure you want to perform this action?',
      details: actionInfo ?? "",
    );
  }
}
