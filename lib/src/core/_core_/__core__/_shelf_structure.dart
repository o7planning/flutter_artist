part of '../core.dart';

/// Structural blueprint defining the shelf-level filters, blocks, scalars,
/// LOV models, and configuration instantiated when mounting a [Shelf].
class ShelfStructure {
  final ShelfConfig _config;
  final String? description;

  /// Named shelf-level [FilterModel] instances referenced by [Block]s and [Scalar]s
  /// via `filterModelName`.
  ///
  /// Note: [LovModel] instances own their [FilterModel] directly and are not
  /// registered in this map.
  final Map<String, FilterModel> filterModels;

  final List<Block> blocks;
  final List<Scalar> scalars;
  final List<LovModel> lovModels;

  ShelfConfig get config => _config;

  ShelfStructure({
    ShelfConfig config = const ShelfConfig(),
    this.description,
    this.filterModels = const {},
    this.blocks = const [],
    this.scalars = const [],
    this.lovModels = const [],
  }) : _config = config;
}
