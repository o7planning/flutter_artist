part of '../core.dart';

class _BlockItemRefreshCon<ID extends Comparable> extends Equatable {
  final ID itemId;

  const _BlockItemRefreshCon({
    required this.itemId,
  });

  @override
  List<Object?> get props => [itemId];

  @override
  String toString() {
    return "itemId: $itemId";
  }
}
