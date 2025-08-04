part of '../core.dart';

class InternalListeners {
  final Set<Block> blockQueryListeners = {};
  final Set<Scalar> scalarQueryListeners = {};
  final Set<Block> blockRefreshCurrListeners = {};

  ///
  /// BlockConfig:
  /// ```dart
  /// config: BlockConfig (
  ///   reQueryByInternalShelfEvents: [
  ///      "block1",
  ///      "block2",
  ///   ],
  ///   refreshCurrItemByInternalShelfEvents: [
  ///      "block1",
  ///      "block2",
  ///   ]
  /// ),
  /// ```
  ///
  InternalListeners();

  bool hasListeners() {
    return blockQueryListeners.isNotEmpty ||
        scalarQueryListeners.isNotEmpty ||
        blockRefreshCurrListeners.isNotEmpty;
  }

  List<_ScalarOpt> getForceQueryScalarOpts() {
    List<_ScalarOpt> ret = [];

    for (Scalar s in scalarQueryListeners) {
      ret.add(_ScalarOpt(scalar: s));
    }
    return ret;
  }

  List<_BlockOpt> getForceQueryBlockOpts() {
    List<_BlockOpt> ret = [];

    for (Block b in blockQueryListeners) {
      ret.add(
        _BlockOpt(
          block: b,
          forceQuery: true,
          forceReloadItem: false,
          queryType: QueryType.realQuery,
          pageable: null,
          listBehavior: ListBehavior.replace,
          suggestedSelection: null,
          postQueryBehavior: null,
        ),
      );
    }
    return ret;
  }

  List<_FormModelOpt> getForceQueryFormModelOpts() {
    return [];
  }
}
