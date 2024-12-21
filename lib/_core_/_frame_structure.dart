part of '../flutter_artist.dart';

class FrameStructure {
  final String? description;
  final Map<String, BlockFilter> blockFilters;
  final List<Block> blocks;

  FrameStructure({
    this.description,
    required this.blockFilters,
    required this.blocks,
  });
}
