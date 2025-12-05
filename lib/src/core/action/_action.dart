import 'package:flutter/material.dart';
import 'package:flutter_artist_commons_ui/flutter_artist_commons_ui.dart'
as dialogs;

import '../typedef/custom_confirmation.dart';

abstract class Action {
  final bool needToConfirm;
  final String? actionInfo;

  const Action({
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

  Future<bool> defaultConfirmation(BuildContext context) async {
    return await dialogs.showConfirmDialog(
      context: context,
      message: 'Are you sure you want to perform this action?',
      details: actionInfo ?? "",
    );
  }
}
