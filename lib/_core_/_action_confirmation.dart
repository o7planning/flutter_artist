part of '../flutter_artist.dart';

enum ActionConfirmationType {
  delete,
  custom;
}

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
