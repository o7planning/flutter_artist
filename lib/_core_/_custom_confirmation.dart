part of '../flutter_artist.dart';

typedef CustomConfirmation<A> = Future<bool> Function(BuildContext context);

typedef DefaultConfirmation = Future<bool> Function(BuildContext context);
