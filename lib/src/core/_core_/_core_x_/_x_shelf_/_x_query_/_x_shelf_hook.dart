part of '../../../core.dart';

class _XShelfHook extends XShelf {
  _XShelfHook({
    required Hook hook,
  }) : super(
          xShelfType: XShelfType.hook,
          shelf: hook.shelf,
        ) {
    //
  }
}
