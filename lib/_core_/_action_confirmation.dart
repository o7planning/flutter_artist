part of '../flutter_artist.dart';

typedef CustomConfirmation<A extends QuickActionData> = Future<bool> Function(
  A action,
);

@Deprecated("Khong su dung nua")
enum ActionConfirmationType {
  delete,
  custom;
}

@Deprecated("Khong su dung nua")
class ActionConfirmation {
  final ActionConfirmationType type;
  final String message;
  final String? details;

  ActionConfirmation({
    required this.type,
    this.message = "Are you sure you want to perform this action?",
    this.details,
  });
}
