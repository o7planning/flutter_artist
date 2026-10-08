part of '../../core.dart';

class _StageViewSwitcherScope extends InheritedWidget {
  const _StageViewSwitcherScope({
    super.key,
    required super.child,
  });

  static _StageViewSwitcherScope? maybeOf(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<_StageViewSwitcherScope>();
  }

  @override
  bool updateShouldNotify(_StageViewSwitcherScope oldWidget) => false;
}

class _StageFormViewSwitcherScope extends InheritedWidget {
  const _StageFormViewSwitcherScope({
    super.key,
    required super.child,
  });

  static _StageFormViewSwitcherScope? maybeOf(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<_StageFormViewSwitcherScope>();
  }

  @override
  bool updateShouldNotify(_StageFormViewSwitcherScope oldWidget) => false;
}
