part of '../flutter_artist.dart';

class ShelfStructure {
  final String? description;
  final Map<String, BlockFilter> blockFilters;
  final List<Block> blocks;
  final List<Scalar> scalars;

  ShelfStructure({
    this.description,
    required this.blockFilters,
    required this.blocks,
    this.scalars = const [],
  });
}
