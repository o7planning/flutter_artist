part of '../flutter_artist.dart';

abstract class QuickCreateMultiItemsAction<ITEM extends Object>
    extends BaseAction {
  const QuickCreateMultiItemsAction({
    required super.needToConfirm,
    required super.actionInfo,
  });

  Future<ApiResult<PageData<ITEM>>> callApiQuickCreateMultiItems();

  Future<bool> _defaultConfirmation(BuildContext context) async {
    return await dialogs.showConfirmDialog(
      context: context,
      message: 'Are you sure you want to perform this action?',
      details: actionInfo ?? "",
    );
  }
}
