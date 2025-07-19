part of '../../../flutter_artist.dart';

enum BlockItemRefreshingPrecheck implements ECodeDetail {
  busy(
    eCode: ECode.busy,
    message: "Cannot refresh the current item.",
    details: ["The executor is busy."],
  ),
  noTarget(
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

  const BlockItemRefreshingPrecheck({
    required this.eCode,
    required this.message,
    required this.details,
  });
}
