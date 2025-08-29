import 'package:flutter_artist_core/flutter_artist_core.dart';

import '../enums/after_silent_action.dart';
import '_quick_action.dart';

///
/// Do something and then re-query the Scalar.
/// For example: Call an API to create or update an item and then re-query the Scalar.
///
// TODO: Hoàn thành logic.
abstract class ScalarDoSthAndReQueryAction extends QuickAction {
  late final ScalarDoSthAndReQueryActionConfig config;

  ScalarDoSthAndReQueryAction({
    required super.needToConfirm,
    required super.actionInfo,
  }) {
    config = initConfig();
  }

  ScalarDoSthAndReQueryActionConfig initConfig();

  Future<ApiResult<void>> callApiDoSomething();
}

class ScalarDoSthAndReQueryActionConfig {
  final AfterScalarSilentAction afterQuickAction;
  final List<Type> affectedItemTypes;

  const ScalarDoSthAndReQueryActionConfig({
    required this.affectedItemTypes,
    required this.afterQuickAction,
  });
}
