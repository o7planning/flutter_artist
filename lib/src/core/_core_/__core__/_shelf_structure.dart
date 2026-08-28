part of '../core.dart';

class ShelfStructure {
  final ShelfConfig _config;
  final String? description;
  final Map<String, FilterModel> filterModels;
  final List<Block> blocks;
  final List<Scalar> scalars;

  ShelfStructure({
    ShelfConfig config = const ShelfConfig(),
    this.description,
    required this.filterModels,
    required this.blocks,
    this.scalars = const [],
  }) : _config = config;
}
