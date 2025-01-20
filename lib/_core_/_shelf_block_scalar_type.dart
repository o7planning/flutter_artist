part of '../flutter_artist.dart';

class ShelfBlockScalarType extends Equatable {
  final Type shelfType;
  final Type? blockType;
  final Type? scalarType;

  final String classDefinition;
  final String classParameterDefinition;

  String get className {
    if (blockType != null) {
      return blockType.toString();
    } else {
      return scalarType.toString();
    }
  }

  bool get isBlock => blockType != null;

  bool get isScalar => scalarType != null;

  const ShelfBlockScalarType.block({
    required this.shelfType,
    required this.blockType,
    required this.classDefinition,
    required this.classParameterDefinition,
  }) : scalarType = null;

  const ShelfBlockScalarType.scalar({
    required this.shelfType,
    required this.scalarType,
    required this.classDefinition,
    required this.classParameterDefinition,
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
