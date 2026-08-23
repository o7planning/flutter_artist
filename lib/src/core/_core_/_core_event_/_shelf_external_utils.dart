part of '../core.dart';

@_ShelfExternalAnnotation()
class _ShelfExternalUtils {
  final Shelf shelf;

  _ShelfExternalUtils(this.shelf);

  // Test Cases: [99a]
  /// Calculates which local members are affected by the broadcasted external data types.
  /// All comments are in English for global users to read.
  EffectedShelfMembers calculateEffectedShelfMembersByEvents(
    List<Type> affectedDataTypes,
  ) {
    EffectedShelfMembers ret = EffectedShelfMembers.ofNothing();

    // Evaluate Block reactions to external events
    for (Block block in shelf.blocks) {
      for (var reaction in block.effectiveConfig.reactions) {
        if (affectedDataTypes.contains(reaction.dataType)) {
          if (reaction.target == BlockReactionTarget.block) {
            ret._addRequeryBlock(block);
          } else if (reaction.target == BlockReactionTarget.currentItem) {
            ret._addRefreshCurrItmBlock(block);
          }
        }
      }
    }

    // Evaluate Scalar reactions to external events
    for (Scalar scalar in shelf.scalars) {
      for (var reaction in scalar.effectiveConfig.reactions) {
        if (affectedDataTypes.contains(reaction.dataType)) {
          if (reaction.target == ScalarReactionTarget.scalar) {
            ret._addRequeryScalar(scalar);
          }
        }
      }
    }

    return ret;
  }
}
