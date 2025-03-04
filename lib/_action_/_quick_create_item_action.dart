part of '../flutter_artist.dart';

abstract class QuickCreateItemAction<ITEM_DETAIL extends Object>
    extends BaseAction {
  const QuickCreateItemAction({
    required super.needToConfirm,
    required super.actionInfo,
  });

  Future<ApiResultOLD<ITEM_DETAIL>> callApiQuickCreateItem();

  Future<bool> _defaultConfirmation(BuildContext context) async {
    return await dialogs.showConfirmDialog(
      context: context,
      message: 'Are you sure you want to perform this action?',
      details: actionInfo ?? "",
    );
  }
}
