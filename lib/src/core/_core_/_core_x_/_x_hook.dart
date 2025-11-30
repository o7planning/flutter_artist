part of '../core.dart';

class XHook {
  final XShelf xShelf;

  int get xShelfId => xShelf.xShelfId;

  final Hook hook;

  // ***************************************************************************
  // ***************************************************************************

  ///
  /// IMPORTANT: To create new XHook, use 'hook._createXHook' method
  /// to have the same Generics Parameters with the hook.
  ///
  XHook._({
    required this.hook,
    required this.xShelf,
  });
}
