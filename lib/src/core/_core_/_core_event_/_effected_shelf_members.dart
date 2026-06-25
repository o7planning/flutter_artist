part of '../core.dart';

@_InternalEventReactAnnotation()
class EffectedShelfMembers {
  final Block? eventBlock;
  final Scalar? eventScalar;

  final Map<String, Block> _requeryBlockMAP = {};
  final Map<String, Scalar> _requeryScalarMAP = {};
  final Map<String, Block> _refreshCurrItmBlockMAP = {};

  ///
  /// BlockConfig:
  /// ```dart
  /// config: BlockConfig (
  ///   executeScalarLevelReactionToEvts: [
  ///      Evt.ofBlock("block1"),
  ///      Evt.ofBlock("block2"),
  ///      Evt.ofScalar("scalar1"),
  ///   ],
  ///   executeItemLevelReactionToEvts: [
  ///      Evt.ofBlock"block1"),
  ///      Evt.ofBlock"block2"),
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
    return _requeryBlockMAP.isNotEmpty ||
        _requeryScalarMAP.isNotEmpty ||
        _refreshCurrItmBlockMAP.isNotEmpty;
  }

  // ***************************************************************************

  void _addRequeryScalar(Scalar scalar) {
    _requeryScalarMAP[scalar.name] = scalar;
  }

  void _addRequeryBlock(Block block) {
    _requeryBlockMAP[block.name] = block;
  }

  void _addRefreshCurrItmBlock(Block block) {
    _refreshCurrItmBlockMAP[block.name] = block;
  }

  // ***************************************************************************
  // ***************************************************************************

  _EffBlock? _getSelfEffectedBlockInfo({
    required Block forEventBlock,
    required BlockViewportSyncStrategy? viewportSyncStrategy,
  }) {
    bool requery = false;
    bool refreshCurrItem = false;
    if (_requeryBlockMAP.containsKey(forEventBlock.name)) {
      requery = true;
    }
    if (_refreshCurrItmBlockMAP.containsKey(forEventBlock.name)) {
      refreshCurrItem = true;
    }
    return (!requery && !refreshCurrItem)
        ? null
        : _EffBlock(
            block: forEventBlock,
            refreshCurrItem: refreshCurrItem,
            requery: requery,
            viewportSyncStrategy: viewportSyncStrategy,
          );
  }

  // ***************************************************************************
  // ***************************************************************************

  _EffScalar? _getSelfEffectedScalarInfo({
    required Scalar forEventScalar,
  }) {
    bool requery = false;
    if (_requeryScalarMAP.containsKey(forEventScalar.name)) {
      requery = true;
    }
    return !requery
        ? null
        : _EffScalar(
            scalar: forEventScalar,
            requery: requery,
          );
  }

  // ***************************************************************************

  bool __inList(List<Block> blocks, Block block) {
    for (Block blk in blocks) {
      if (blk.name == block.name) {
        return true;
      }
    }
    return false;
  }

  // ***************************************************************************

  bool _hasEffectedMemberOutsideLineageOfBlock({
    required Block eventBlock,
  }) {
    if (_requeryScalarMAP.isNotEmpty) {
      return true;
    }
    final List<Block> lineageBlocks = eventBlock.lineageBlocks;
    for (Block block in _requeryBlockMAP.values) {
      if (!__inList(lineageBlocks, block)) {
        return true;
      }
    }
    for (Block block in _refreshCurrItmBlockMAP.values) {
      if (!__inList(lineageBlocks, block)) {
        return true;
      }
    }
    return false;
  }

  // ***************************************************************************

  ///
  /// Find the Top Block effected by Event.
  ///
  _EffBlock? _getTopEffectedAncestor({
    required Block forEventBlock,
    required BlockViewportSyncStrategy? viewportSyncStrategy,
  }) {
    Block? parentBlk = forEventBlock.parent;
    if (parentBlk == null) {
      return null;
    }
    Block? block;
    bool requery = false;
    bool refreshCurrItem = false;
    if (_requeryBlockMAP.containsKey(parentBlk.name)) {
      block = parentBlk;
      requery = true;
    }
    if (_refreshCurrItmBlockMAP.containsKey(parentBlk.name)) {
      block = parentBlk;
      refreshCurrItem = true;
    }
    _EffBlock? effBlock = block == null || (!requery && !refreshCurrItem)
        ? null
        : _EffBlock(
            block: block,
            refreshCurrItem: refreshCurrItem,
            requery: requery,
            viewportSyncStrategy: viewportSyncStrategy,
          );
    return _getTopEffectedAncestor(
          forEventBlock: parentBlk,
          viewportSyncStrategy: viewportSyncStrategy,
        ) ??
        effBlock;
  }

  // ***************************************************************************
  // ***************************************************************************

  bool hasEffectedAncestor({
    required Block forEventBlock,
    required bool requery,
    required bool refreshCurrItem,
  }) {
    Block? parentBlk = forEventBlock.parent;
    if (parentBlk == null) {
      return false;
    }
    if (requery && _requeryBlockMAP.containsKey(parentBlk.name)) {
      return true;
    }
    if (refreshCurrItem &&
        _refreshCurrItmBlockMAP.containsKey(parentBlk.name)) {
      return true;
    }
    return hasEffectedAncestor(
      forEventBlock: parentBlk,
      requery: requery,
      refreshCurrItem: refreshCurrItem,
    );
  }

  String getDebugInfoHtml() {
    String s = "\n - @requeryScalars: <b>${_requeryScalarMAP.keys}</b>."
        "\n - @requeryBlocks: <b>${_requeryBlockMAP.keys}</b>."
        "\n - @refreshCurrItmBlocks: <b>${_refreshCurrItmBlockMAP.keys}</b>.";
    return s;
  }

  // ***************************************************************************
  // ***************************************************************************

  void printInfo() {
    print("@@requeryScalar: ${_requeryScalarMAP.keys}");
    print("@@requeryBlock: ${_requeryBlockMAP.keys}");
    print("@@refreshCurrItmBlock: ${_refreshCurrItmBlockMAP.keys}");
  }
}
