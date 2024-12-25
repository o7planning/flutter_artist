part of '../flutter_artist.dart';

class ShelfStructure {
  final String? description;
  final Map<String, BlockFilter> blockFilters;
  final List<Block> blocks;
  final List<NonBlock> nonBlocks;

  ShelfStructure({
    this.description,
    required this.blockFilters,
    required this.blocks,
    this.nonBlocks = const [],
  });
}
