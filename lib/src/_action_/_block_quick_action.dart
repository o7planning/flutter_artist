part of '../../flutter_artist.dart';

abstract class BlockQuickAction  extends BaseAction {
  late final BlockQuickActionConfig config;

  BlockQuickAction({
    required super.needToConfirm,
    required super.actionInfo,
  }) {
    config = initConfig();
  }

  BlockQuickActionConfig initConfig();

  Future<ApiResult<void>> callApi();
}

class BlockQuickActionConfig {
  final AfterBlockQuickAction afterQuickAction;
  final List<Type> affectedItemTypes;

  const BlockQuickActionConfig({
    required  this.affectedItemTypes  ,
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
