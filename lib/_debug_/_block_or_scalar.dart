part of '../flutter_artist.dart';

class _BlockOrScalar extends Equatable {
  final Block? block;
  final Scalar? scalar;

  Shelf get shelf {
    if (block != null) {
      return block!.shelf;
    } else {
      return scalar!.shelf;
    }
  }

  bool get isBlock => block != null;

  bool get isScalar => scalar != null;

  List<Type> get listenItemTypes {
    if (block != null) {
      return block!.listenItemTypes;
    } else {
      return scalar!.listenItemTypes;
    }
  }

  List<String> get listenItemTypesAsStrings {
    if (block != null) {
      return block!.listenItemTypes.map((type) => type.toString()).toList();
    } else {
      return scalar!.listenItemTypes.map((type) => type.toString()).toList();
    }
  }

  const _BlockOrScalar.block(this.block) : scalar = null;

  const _BlockOrScalar.scalar(this.scalar) : block = null;

  @override
  List<Object?> get props => [block?.name, scalar?.name];
}
