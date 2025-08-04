part of '../core.dart';

class InternalListeners {
  final Map<EvtType, Set<Block>> blockQueryListenerMap = {};
  final Map<EvtType, Set<Scalar>> scalarQueryListenerMap = {};
  final Map<EvtType, Set<Block>> blockRefreshCurrListenerMap = {};

  ///
  /// BlockConfig:
  /// ```dart
  /// config: BlockConfig (
  ///   reQueryByInternalShelfEvents: [
  ///      Evt.blockC("block1"),
  ///      Evt.blockCUD("block2"),
  ///   ],
  ///   refreshCurrItemByInternalShelfEvents: [
  ///      Evt.blockC("block1"),
  ///      Evt.blockCUD("block2"),
  ///   ]
  /// ),
  /// ```
  ///
  InternalListeners() {
    blockQueryListenerMap[EvtType.creation] = <Block>{};
    blockQueryListenerMap[EvtType.update] = <Block>{};
    blockQueryListenerMap[EvtType.deletion] = <Block>{};
    //
    scalarQueryListenerMap[EvtType.update] = <Scalar>{};
    //
    blockRefreshCurrListenerMap[EvtType.creation] = <Block>{};
    blockRefreshCurrListenerMap[EvtType.update] = <Block>{};
    blockRefreshCurrListenerMap[EvtType.deletion] = <Block>{};
  }

  bool hasListenerForEventType(EvtType eventType) {
    Set<Block> blockQuerySet = blockQueryListenerMap[eventType]!;
    Set<Scalar> scalarQuerySet = scalarQueryListenerMap[eventType]!;
    Set<Block> blockRefreshCurrSet = blockRefreshCurrListenerMap[eventType]!;
    return blockQuerySet.isNotEmpty ||
        scalarQuerySet.isNotEmpty ||
        blockRefreshCurrSet.isNotEmpty;
  }

  Set<Block> getBlockQueryListenersForEventType(EvtType eventType) {
    return blockQueryListenerMap[eventType]!;
  }

  Set<Block> getBlockRefreshCurrListenerForEventType(EvtType eventType) {
    return blockRefreshCurrListenerMap[eventType]!;
  }

  Set<Scalar> getScalarQueryListenersForEventType(EvtType eventType) {
    return scalarQueryListenerMap[eventType]!;
  }

  List<_ScalarOpt> getForceQueryScalarOpts(EvtType eventType) {
    Set<Scalar> scalars = getScalarQueryListenersForEventType(eventType);
    List<_ScalarOpt> ret = [];

    for (Scalar s in scalars) {
      ret.add(_ScalarOpt(scalar: s));
    }
    return ret;
  }

  List<_BlockOpt> getForceQueryBlockOpts(EvtType eventType) {
    Set<Block> blocks = getBlockQueryListenersForEventType(eventType);
    List<_BlockOpt> ret = [];

    for (Block b in blocks) {
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

  List<_FormModelOpt> getForceQueryFormModelOpts(EvtType eventType) {
    return [];
  }
}
