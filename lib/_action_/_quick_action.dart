part of '../flutter_artist.dart';

abstract class QuickAction<DATA extends Object> extends BaseAction {
  final List<Type> affectedItemTypes;

  const QuickAction({
    required super.needToConfirm,
    required super.actionInfo,
    required this.affectedItemTypes,
  });

  Future<ApiResultOLD<DATA>?> callApi();

  // TODO: Add document.
  Future<void> doAfterCallApi({
    required bool success,
    required DATA? apiData,
  });

  ///
  /// Example:
  /// ```dart
  /// CustomConfirmation? createCustomConfirmation() {
  ///   return (BuildContext context) async {
  ///      bool confirm = await showMyConfirmationDialog();
  ///      return confirm;
  ///   };
  /// }
  /// ```
  ///
  CustomConfirmation? createCustomConfirmation();

  Future<bool> _defaultConfirmation(BuildContext context) async {
    return await dialogs.showConfirmDialog(
      context: context,
      message: 'Are you sure you want to perform this action?',
      details: actionInfo ?? "",
    );
  }
}

abstract class SimpleQuickAction extends QuickAction {
  final dynamic data;

  const SimpleQuickAction({
    required this.data,
    required super.needToConfirm,
    required super.actionInfo,
    required super.affectedItemTypes,
  });
}
