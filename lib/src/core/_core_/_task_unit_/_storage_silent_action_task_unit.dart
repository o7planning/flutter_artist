part of '../core.dart';

@_TaskUnitClassAnnotation()
@_StorageSilentActionAnnotation()
class _StorageSilentActionTaskUnit extends _TaskUnit {
  final StorageSilentAction action;
  final StorageSilentActionResult taskResult = StorageSilentActionResult();

  _StorageSilentActionTaskUnit({
    required this.action,
  });

  @override
  Object get owner => FlutterArtist.storage;
}
