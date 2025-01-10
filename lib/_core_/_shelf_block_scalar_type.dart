part of '../flutter_artist.dart';

class ShelfBlockScalarType extends Equatable {
  final Type shelfType;
  final Type? blockType;
  final Type? scalarType;

  final String? blockClassDefinition;
  final String? scalarClassDefinition;

  bool get isBlock => blockType != null;

  bool get isScalar => scalarType != null;

  const ShelfBlockScalarType.block({
    required this.shelfType,
    required this.blockType,
    required this.blockClassDefinition,
  })  : scalarType = null,
        scalarClassDefinition = null;

  const ShelfBlockScalarType.scalar({
    required this.shelfType,
    required this.scalarType,
    required this.scalarClassDefinition,
  })  : blockType = null,
        blockClassDefinition = null;

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
