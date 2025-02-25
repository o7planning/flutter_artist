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
}
