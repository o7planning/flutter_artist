part of '../../flutter_artist.dart';

class ShelfStructure {
  final ShelfHiddenBehavior hiddenBehavior;
  final String? description;
  final Map<String, FilterModel> filterModels;
  final List<Block> blocks;
  final List<Scalar> scalars;
  final List<Activity> activities;

  ShelfStructure({
    this.hiddenBehavior = ShelfHiddenBehavior.none,
    this.description,
    required this.filterModels,
    required this.blocks,
    this.scalars = const [],
    this.activities = const [],
  });
}
