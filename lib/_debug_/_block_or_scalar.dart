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

  const _BlockOrScalar.block(this.block) : scalar = null;

  const _BlockOrScalar.scalar(this.scalar) : block = null;

  @override
  List<Object?> get props => [block?.name, scalar?.name];
}
