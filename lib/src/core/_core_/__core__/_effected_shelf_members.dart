part of '../core.dart';

@_InternalEventReactAnnotation()
class EffectedShelfMembers {
  final ShelfReactionType shelfReactionType;

  final Map<String, Block> __reQueryBlockMAP = {};
  final Map<String, Scalar> __reQueryScalarMAP = {};
  final Map<String, Block> __refreshCurrItmBlockMAP = {};

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
  EffectedShelfMembers({required this.shelfReactionType});

  bool hasMember() {
    return __reQueryBlockMAP.isNotEmpty ||
        __reQueryScalarMAP.isNotEmpty ||
        __refreshCurrItmBlockMAP.isNotEmpty;
  }

  // ***************************************************************************

  void _addReQueryScalar(Scalar scalar) {
    __reQueryScalarMAP[scalar.name] = scalar;
  }

  void _addReQueryBlock(Block block) {
    __reQueryBlockMAP[block.name] = block;
  }

  void _addRefreshCurrItmBlock(Block block) {
    __refreshCurrItmBlockMAP[block.name] = block;
  }

  // ***************************************************************************

  List<_ScalarOpt> _getForceReQueryScalarOpts() {
    List<_ScalarOpt> ret = [];

    for (Scalar s in __reQueryScalarMAP.values) {
      ret.add(_ScalarOpt(scalar: s));
    }
    return ret;
  }

  List<_BlockOpt> _getForceReQueryBlockOpts() {
    List<_BlockOpt> ret = [];
    Set<String> listenerBlockNames = {}
      ..addAll(__reQueryBlockMAP.keys)
      ..addAll(__refreshCurrItmBlockMAP.keys);

    for (String listenerBlkName in listenerBlockNames) {
      final Block? reQryBlock = __reQueryBlockMAP[listenerBlkName];
      final Block? refreshCurrBlock = __refreshCurrItmBlockMAP[listenerBlkName];
      bool blockVisible = false;
      QryHint forceQuery = QryHint.none;
      bool forceReloadItem = false;
      if (reQryBlock != null) {
        blockVisible =
            reQryBlock.ui.hasActiveBlockFragmentWidget(alsoCheckChildren: true);
        switch (shelfReactionType) {
          case ShelfReactionType.natural:
            forceQuery = blockVisible ? QryHint.force : QryHint.none;
          case ShelfReactionType.internal:
            forceQuery = blockVisible ? QryHint.force : QryHint.markAsPending;
          case ShelfReactionType.external:
            forceQuery = blockVisible ? QryHint.force : QryHint.markAsPending;
        }
      }
      if (refreshCurrBlock != null) {
        blockVisible = refreshCurrBlock.ui
            .hasActiveBlockFragmentWidget(alsoCheckChildren: true);
        forceReloadItem = true;
      }
      final blockOpt = _BlockOpt(
        block: (reQryBlock ?? refreshCurrBlock)!,
        forceQuery: forceQuery,
        forceReloadItem: forceReloadItem,
        queryType: QueryType.realQuery,
        pageable: null,
        listBehavior: ListBehavior.replace,
        suggestedSelection: null,
        postQueryBehavior: null,
      );
      ret.add(blockOpt);
    }
    return ret;
  }

  List<_FormModelOpt> _getForceReLoadFormModelOpts() {
    return [];
  }
}
