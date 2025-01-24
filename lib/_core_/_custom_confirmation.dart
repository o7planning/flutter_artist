part of '../flutter_artist.dart';

typedef CustomConfirmation<A extends QuickActionData> = Future<bool> Function(
  A actionData,
);
