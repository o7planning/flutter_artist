part of '../flutter_artist.dart';

class ShelfStructure {
  final String? description;
  final Map<String, DataFilter> dataFilters;
  final List<Block> blocks;
  final List<Scalar> scalars;

  ShelfStructure({
    this.description,
    required this.dataFilters,
    required this.blocks,
    this.scalars = const [],
  });
}
