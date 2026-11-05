part of '../../core.dart';

class _StagesViewSwitcherScope extends InheritedWidget {
  const _StagesViewSwitcherScope({
    super.key,
    required super.child,
  });

  static _StagesViewSwitcherScope? maybeOf(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<_StagesViewSwitcherScope>();
  }

  @override
  bool updateShouldNotify(_StagesViewSwitcherScope oldWidget) => false;
}

class _StageFormViewSwitcherScope extends InheritedWidget {
  final ProzessScreenNavigationContext? screenNavigationContext;
  final bool circularFocusTraversal;

  const _StageFormViewSwitcherScope({
    super.key,
    required super.child,
    required this.screenNavigationContext,
    required this.circularFocusTraversal,
  });

  static _StageFormViewSwitcherScope? maybeOf(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<_StageFormViewSwitcherScope>();
  }

  @override
  bool updateShouldNotify(_StageFormViewSwitcherScope oldWidget) =>
      oldWidget.screenNavigationContext != screenNavigationContext ||
      oldWidget.circularFocusTraversal != circularFocusTraversal;
}
