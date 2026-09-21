part of '../core.dart';

/// Structural blueprint defining the filters, blocks, scalars, and configuration
/// instantiated when mounting a [Shelf].
class ShelfStructure {
  final ShelfConfig _config;
  final String? description;
  final Map<String, FilterModel> filterModels;
  final List<Block> blocks;
  final List<Scalar> scalars;

  ShelfConfig get config => _config;

  ShelfStructure({
    ShelfConfig config = const ShelfConfig(),
    this.description,
    required this.filterModels,
    required this.blocks,
    this.scalars = const [],
  }) : _config = config;
}
