part of '../flutter_artist.dart';

abstract class BaseAction {
  final bool needToConfirm;
  final String? actionInfo;

  const BaseAction({
    required this.needToConfirm,
    required this.actionInfo,
  });

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
  CustomConfirmation? createCustomConfirmation();

  Future<bool> _defaultConfirmation(BuildContext context) async {
    return await dialogs.showConfirmDialog(
      context: context,
      message: 'Are you sure you want to perform this action?',
      details: actionInfo ?? "",
    );
  }
}
