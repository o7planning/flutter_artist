part of '../flutter_artist.dart';

abstract class QuickUpdateItemAction<
    ITEM extends Object, //
    ITEM_DETAIL extends Object> extends BaseAction {
  const QuickUpdateItemAction({
    required super.needToConfirm,
    required super.actionInfo,
  });

  Future<ApiResult<ITEM_DETAIL>> callApiQuickUpdateItem({required ITEM item});

  ///
  /// Example:
  /// ```dart
  /// CustomConfirmation? createCustomConfirmation({required Employee item}) {
  ///   return (BuildContext context) async {
  ///      bool confirm = await showDeleteEmpConfirmationDialog();
  ///      return confirm;
  ///   };
  /// }
  /// ```
  ///
  CustomConfirmation? createCustomConfirmation({required ITEM item});

  Future<bool> _defaultConfirmation(BuildContext context) async {
    return await dialogs.showConfirmDialog(
      context: context,
      message: 'Are you sure you want to perform this action?',
      details: actionInfo ?? "",
    );
  }
}
