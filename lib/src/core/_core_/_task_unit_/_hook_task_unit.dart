part of '../core.dart';

@_TaskUnitClassAnnotation()
@_HookAnnotation()
class _HookTaskUnit extends _STaskUnit {
  XHook xHook;

  _HookTaskUnit({
    required this.xHook,
  }) : super(taskType: TaskType.hook);

  @override
  XShelf get xShelf => xHook.xShelf;

  @override
  int get xShelfId => xHook.xShelfId;

  @override
  Shelf get shelf => xHook.hook.shelf;

  @override
  Hook get owner => xHook.hook;

  @override
  String getObjectName() {
    return xHook.hook.name;
  }

  @override
  String toString() {
    return "${getClassName(this)}(${getClassName(xHook.hook)})";
  }
}
