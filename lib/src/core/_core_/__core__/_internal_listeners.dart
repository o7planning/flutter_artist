part of '../core.dart';

@_InternalEventReactAnnotation()
class InternalListeners {
  final Map<String, Block> __blockReQueryListenerMAP = {};
  final Map<String, Scalar> __scalarReQueryListenerMAP = {};
  final Map<String, Block> __blockRefreshCurrListenerMAP = {};

  ///
  /// BlockConfig:
  /// ```dart
  /// config: BlockConfig (
  ///   reQueryByInternalShelfEvents: [
  ///      Evt.insideBlock("block1"),
  ///      Evt.insideBlock("block2"),
  ///      Evt.insideScalar("scalar1"),
  ///   ],
  ///   refreshCurrItemByInternalShelfEvents: [
  ///      Evt.insideBlock"block1"),
  ///      Evt.insideBlock"block2"),
  ///   ]
  /// ),
  /// ```
  ///
  InternalListeners();

  bool hasListeners() {
    return __blockReQueryListenerMAP.isNotEmpty ||
        __scalarReQueryListenerMAP.isNotEmpty ||
        __blockRefreshCurrListenerMAP.isNotEmpty;
  }

  // ***************************************************************************

  void _addScalarQueryListener(Scalar scalar) {
    __scalarReQueryListenerMAP[scalar.name] = scalar;
  }

  void _addBlockQueryListener(Block block) {
    __blockReQueryListenerMAP[block.name] = block;
  }

  void _addBlockRefreshCurrListener(Block block) {
    __blockRefreshCurrListenerMAP[block.name] = block;
  }

  // ***************************************************************************

  List<_ScalarOpt> _getForceQueryScalarOpts() {
    List<_ScalarOpt> ret = [];

    for (Scalar s in __scalarReQueryListenerMAP.values) {
      ret.add(_ScalarOpt(scalar: s));
    }
    return ret;
  }

  List<_BlockOpt> _getForceQueryBlockOpts() {
    List<_BlockOpt> ret = [];
    Set<String> listenerBlockNames = {}
      ..addAll(__blockReQueryListenerMAP.keys)
      ..addAll(__blockRefreshCurrListenerMAP.keys);

    for (String listenerBlkName in listenerBlockNames) {
      Block? reQryBlock = __blockReQueryListenerMAP[listenerBlkName];
      Block? refreshCurrBlock = __blockRefreshCurrListenerMAP[listenerBlkName];
      ret.add(
        _BlockOpt(
          block: (reQryBlock ?? refreshCurrBlock)!,
          forceQuery: reQryBlock != null,
          forceReloadItem: refreshCurrBlock != null,
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

  List<_FormModelOpt> _getForceQueryFormModelOpts() {
    return [];
  }
}
