part of '../flutter_artist.dart';

class ShelfBlockType extends Equatable {
  Type shelfType;
  Type blockType;

  ShelfBlockType({
    required this.shelfType,
    required this.blockType,
  });

  @override
  List<Object?> get props => [shelfType, blockType];

  @override
  String toString() {
    return "ShelfBlockType[$shelfType >> $blockType]";
  }
}
