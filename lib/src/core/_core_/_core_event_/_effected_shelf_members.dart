part of '../core.dart';

@_InternalEventReactAnnotation()
class EffectedShelfMembers {
  final Block? eventBlock;
  final Scalar? eventScalar;

  final Map<String, Block> _reQueryBlockMAP = {};
  final Map<String, Scalar> _reQueryScalarMAP = {};
  final Map<String, Block> _refreshCurrItmBlockMAP = {};

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
  EffectedShelfMembers.ofBlock({required Block this.eventBlock})
      : eventScalar = null;

  EffectedShelfMembers.ofScalar({required Scalar this.eventScalar})
      : eventBlock = null;

  EffectedShelfMembers.ofNothing()
      : eventBlock = null,
        eventScalar = null;

  bool hasMember() {
    return _reQueryBlockMAP.isNotEmpty ||
        _reQueryScalarMAP.isNotEmpty ||
        _refreshCurrItmBlockMAP.isNotEmpty;
  }

  // ***************************************************************************

  void _addReQueryScalar(Scalar scalar) {
    _reQueryScalarMAP[scalar.name] = scalar;
  }

  void _addReQueryBlock(Block block) {
    _reQueryBlockMAP[block.name] = block;
  }

  void _addRefreshCurrItmBlock(Block block) {
    _refreshCurrItmBlockMAP[block.name] = block;
  }

  // ***************************************************************************
  // ***************************************************************************

  _EffBlock? getSelfEffectedBlockInfo({
    required Block forEventBlock,
  }) {
    bool reQuery = false;
    bool refreshCurrItem = false;
    if (_reQueryBlockMAP.containsKey(forEventBlock.name)) {
      reQuery = true;
    }
    if (_refreshCurrItmBlockMAP.containsKey(forEventBlock.name)) {
      refreshCurrItem = true;
    }
    return (!reQuery && !refreshCurrItem)
        ? null
        : _EffBlock(
            block: forEventBlock,
            reQuery: reQuery,
            refreshCurrItem: refreshCurrItem,
          );
  }

  // ***************************************************************************
  // ***************************************************************************

  _EffScalar? getSelfEffectedScalarInfo({
    required Scalar forEventScalar,
  }) {
    bool reQuery = false;
    if (_reQueryScalarMAP.containsKey(forEventScalar.name)) {
      reQuery = true;
    }
    return !reQuery
        ? null
        : _EffScalar(
            scalar: forEventScalar,
            reQuery: reQuery,
          );
  }

  // ***************************************************************************

  ///
  /// Find the Top Block effected by Event.
  ///
  _EffBlock? getTopEffectedAncestor({
    required Block forEventBlock,
  }) {
    Block? parentBlk = forEventBlock!.parent;
    if (parentBlk == null) {
      return null;
    }
    Block? block;
    bool reQuery = false;
    bool refreshCurrItem = false;
    if (_reQueryBlockMAP.containsKey(parentBlk.name)) {
      block = parentBlk;
      reQuery = true;
    }
    if (_refreshCurrItmBlockMAP.containsKey(parentBlk.name)) {
      block = parentBlk;
      refreshCurrItem = true;
    }
    _EffBlock? effBlock = block == null || (!reQuery && !refreshCurrItem)
        ? null
        : _EffBlock(
            block: block,
            reQuery: reQuery,
            refreshCurrItem: refreshCurrItem,
          );
    return getTopEffectedAncestor(forEventBlock: parentBlk) ?? effBlock;
  }

  // ***************************************************************************
  // ***************************************************************************

  bool hasEffectedAncestor({
    required Block forEventBlock,
    required bool reQuery,
    required bool refreshCurrItem,
  }) {
    Block? parentBlk = forEventBlock!.parent;
    if (parentBlk == null) {
      return false;
    }
    if (reQuery && _reQueryBlockMAP.containsKey(parentBlk.name)) {
      return true;
    }
    if (refreshCurrItem &&
        _refreshCurrItmBlockMAP.containsKey(parentBlk.name)) {
      return true;
    }
    return hasEffectedAncestor(
      forEventBlock: parentBlk,
      reQuery: reQuery,
      refreshCurrItem: refreshCurrItem,
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  void printInfo() {
    print("@@reQueryScalar: ${_reQueryScalarMAP.keys}");
    print("@@reQueryBlock: ${_reQueryBlockMAP.keys}");
    print("@@refreshCurrItmBlock: ${_refreshCurrItmBlockMAP.keys}");
  }
}
