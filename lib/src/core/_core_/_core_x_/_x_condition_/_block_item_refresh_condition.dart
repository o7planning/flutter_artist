part of '../../core.dart';

class _BlockItemRefreshCon extends Equatable {
  final Object itemId;

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
