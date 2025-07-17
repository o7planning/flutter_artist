part of '../../flutter_artist.dart';

enum BlockItemRefreshState implements ECodeDetail {
  busy(
    eCode: ECode.busy,
    message: "Cannot refresh the current item.",
    details: ["The executor is busy."],
  ),

  noTargetItemToRefresh(
    eCode: ECode.noTarget,
    message: "The Refresh Ignored",
    details: ["No target item to refresh"],
  );

  @override
  final ECode eCode;

  @override
  final String message;

  @override
  final List<String>? details;

  const BlockItemRefreshState({
    required this.eCode,
    required this.message,
    required this.details,
  });
}
