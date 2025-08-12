part of '../core.dart';

@_InternalEventReactAnnotation()
class EffectedShelfMembers {
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
  EffectedShelfMembers();

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
      Block? reQryBlock = __reQueryBlockMAP[listenerBlkName];
      Block? refreshCurrBlock = __refreshCurrItmBlockMAP[listenerBlkName];
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

  List<_FormModelOpt> _getForceReLoadFormModelOpts() {
    return [];
  }
}
