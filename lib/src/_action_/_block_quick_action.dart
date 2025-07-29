part of '../../flutter_artist.dart';

abstract class BlockQuickAction<DATA extends Object> extends BaseAction {
  final BlockQuickActionConfig config;

  const BlockQuickAction({
    required super.needToConfirm,
    required super.actionInfo,
    required this.config,
  });

  Future<ApiResult<void>> callApi();
}

class BlockQuickActionConfig {
  final AfterBlockQuickAction afterQuickAction;
  final List<Type> affectedItemTypes;

  const BlockQuickActionConfig({
    this.affectedItemTypes = const [],
    required this.afterQuickAction,
  });
}

// abstract class SimpleQuickAction extends BlockQuickAction {
//   final dynamic data;
//
//   const SimpleQuickAction({
//     required this.data,
//     required super.needToConfirm,
//     required super.actionInfo,
//     required super.affectedItemTypes,
//   });
// }
