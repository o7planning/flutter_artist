part of '__action.dart';

abstract class BlockBackendAction<ID extends Comparable> extends Action {
  late final BlockBackendActionConfig _config;

  BlockBackendActionConfig get config => _config;

  BlockBackendAction({
    required super.needToConfirm,
    required super.actionInfo,
  }) {
    _config = defineActionConfig();
  }

  BlockBackendActionConfig defineActionConfig();

  Future<ApiResult<ListData<ID>?>> performBackendOperation({
    required Object? parentBlockItem,
  });

  ID? suggestNewCurrentItemId({required List<ID> itemIds}) {
    return null;
  }

  /// Evaluates whether this backend action is allowed to execute
  /// according to application business rules.
  ///
  /// Receives [parentBlockItem] from the immediate parent block (if any).
  /// Override this method to enforce custom permission or state constraints.
  @OverridableMethodAnnotation()
  bool isAllowed({
    required Object? parentBlockItem,
  }) {
    return true;
  }
}

/// Configuration class specifically tailored for [BlockBackendAction].
///
/// It allows developers to specify isolated viewport synchronization strategies
/// for both query modes independently, resolving the conflict caused by the
/// inverted priority hierarchies of full versus pageable queries.
class BlockBackendActionConfig {
  /// The specific strategy that this Action intends to request when the target Block
  /// is operating under [BlockNativeQueryMode.fullQuery].
  ///
  /// If null, the system resolves to the Block's configured floor boundary:
  /// `minStrategyOnFullQueryMode`.
  final BlockViewportSyncStrategy? syncStrategyOnFullQueryMode;

  /// The specific strategy that this Action intends to request when the target Block
  /// is operating under [BlockNativeQueryMode.pageableQuery].
  ///
  /// If null, the system resolves to the Block's configured floor boundary:
  /// `minStrategyOnPageableQueryMode`.
  final BlockViewportSyncStrategy? syncStrategyOnPageableQueryMode;

  /// Global infrastructure events to broadcast upon successful operation completion.
  final List<Type>? broadcastEvents;

  const BlockBackendActionConfig({
    this.syncStrategyOnFullQueryMode,
    this.syncStrategyOnPageableQueryMode,
    this.broadcastEvents,
  });
}
