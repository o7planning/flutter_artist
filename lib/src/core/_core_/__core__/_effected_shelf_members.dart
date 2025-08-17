part of '../core.dart';

@_InternalEventReactAnnotation()
class EffectedShelfMembers {
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
  EffectedShelfMembers();

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
}
