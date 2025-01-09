part of '../flutter_artist.dart';

class ShelfBlockScalarType extends Equatable {
  final Type shelfType;
  final Type? blockType;
  final Type? scalarType;

  bool get isBlock => blockType != null;

  bool get isScalar => scalarType != null;

  const ShelfBlockScalarType.block({
    required this.shelfType,
    required this.blockType,
  }) : scalarType = null;

  const ShelfBlockScalarType.scalar({
    required this.shelfType,
    required this.scalarType,
  }) : blockType = null;

  @override
  List<Object?> get props => [shelfType, blockType, scalarType];

  @override
  String toString() {
    if (blockType != null) {
      return "ShelfBlockType[$shelfType >> $blockType]";
    } else {
      return "ShelfBlockType[$shelfType >> $scalarType]";
    }
  }
}
