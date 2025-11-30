part of '../core.dart';

class _HookUIComponents extends _UIComponents {
  final Hook hook;

  // Piece: Fragment.
  final Map<_RefreshableWidgetState, XState> __hookPieceWidgetStates = {};

  // ***************************************************************************
  // ***************************************************************************

  _HookUIComponents({required this.hook});

  // ***************************************************************************
  // ***************************************************************************

  void updateHookPieceWidgets({bool force = false}) {
    for (_RefreshableWidgetState widgetState in __hookPieceWidgetStates.keys) {
      if (widgetState.mounted) {
        widgetState.refreshState(force: force);
      }
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  @override
  bool hasMountedUIComponent() {
    return __hookPieceWidgetStates.isNotEmpty;
  }

  // ***************************************************************************
  // ***************************************************************************

  bool hasActiveUIComponentHookRepresentative({
    bool alsoCheckChildren = false,
  }) {
    String? componentName = _findActiveUIComponentWithRepresentativeType(
      representativeType: RepresentativeType.hookRepresentative,
      alsoCheckChildren: alsoCheckChildren,
    );
    return componentName != null;
  }

  bool hasActiveUIComponent({bool alsoCheckChildren = false}) {
    String? componentName = findActiveUIComponent(
      alsoCheckChildren: alsoCheckChildren,
    );
    return componentName != null;
  }

  String? findActiveUIComponent({bool alsoCheckChildren = false}) {
    return _findActiveUIComponentWithRepresentativeType(
      representativeType: null,
      alsoCheckChildren: alsoCheckChildren,
    );
  }

  String? findActiveUIComponentHookRepresentative({
    bool alsoCheckChildren = false,
  }) {
    return _findActiveUIComponentWithRepresentativeType(
      representativeType: RepresentativeType.hookRepresentative,
      alsoCheckChildren: alsoCheckChildren,
    );
  }

  String? _findActiveUIComponentWithRepresentativeType({
    required RepresentativeType? representativeType,
    bool alsoCheckChildren = false,
  }) {
    bool has = false;
    //
    // Hook Piece:
    //
    String? componentName = findActiveHookPieceWithRepresentativeType(
      representativeType: representativeType,
      alsoCheckChildren: false,
    );
    if (componentName != null) {
      return componentName;
    }
    return null;
  }

  // ***************************************************************************
  // ***************************************************************************

  bool hasActiveHookPiece({required bool alsoCheckChildren}) {
    String? componentName = findActiveHookPiece(
      alsoCheckChildren: alsoCheckChildren,
    );
    return componentName != null;
  }

  String? findActiveHookPiece({required bool alsoCheckChildren}) {
    return findActiveHookPieceWithRepresentativeType(
      representativeType: null,
      alsoCheckChildren: alsoCheckChildren,
    );
  }

  String? findActiveHookPieceWithRepresentativeType({
    required RepresentativeType? representativeType,
    required bool alsoCheckChildren,
  }) {
    var map = {...__hookPieceWidgetStates};
    for (_RefreshableWidgetState widgetState in map.keys) {
      if (!widgetState.mounted) {
        continue;
      }
      bool visible = map[widgetState]?.isShowing ?? false;
      if (!visible) {
        continue;
      }
      bool ok = widgetState.isRepresentativeType(representativeType);
      if (ok) {
        return getClassNameWithoutGenerics(widgetState.widget);
      }
    }
    return null;
  }

  // ***************************************************************************
  // ***************************************************************************

  void updateAllUIComponents({
    bool force = true,
  }) {
    updateHookPieceWidgets(force: force);
  }

  // ***************************************************************************
  // ***************************************************************************

  Map<_RefreshableWidgetState, XState> _findMountedPieceWidgetStates({
    required bool activeOnly,
  }) {
    return ___findMountedWidgetStates(
      widgetStates: __hookPieceWidgetStates,
      activeOnly: activeOnly,
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  void _addHookPieceWidgetState({
    required _RefreshableWidgetState widgetState,
    required bool isShowing,
  }) {
    bool hasXHookRepOLD = hasActiveUIComponentHookRepresentative(
      alsoCheckChildren: true,
    );
    __hookPieceWidgetStates.update(
      widgetState,
      (xState) => xState.._setShowing(isShowing),
      ifAbsent: () => XState().._setShowing(isShowing),
    );
    bool hasXHookRepCURRENT = hasActiveUIComponentHookRepresentative(
      alsoCheckChildren: true,
    );
    //
    if (isShowing) {
      FlutterArtist.storage._addRecentShelf(hook.shelf);
    }
    //
    if (!hasXHookRepOLD && hasXHookRepCURRENT) {
      // Fire event:
      // hook.shelf._startLoadDataForLazyUIComponentsIfNeed();
      // LOGIC: #0000
      FlutterArtist.storage._naturalQueryQueue.addShelf(hook.shelf);
    } else if (hasXHookRepOLD && !hasXHookRepCURRENT) {
      hook._fireHookHidden();
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  void _removeHookPieceWidgetState({required State widgetState}) {
    bool activeOLD = hasActiveUIComponent();
    __hookPieceWidgetStates.remove(widgetState);
    bool activeCURRENT = hasActiveUIComponent();
    //
    if (activeOLD && !activeCURRENT) {
      hook._fireHookHidden();
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  Map<_RefreshableWidgetState, XState> _findMountedWidgetStates({
    required bool withHookPiece,
    required bool activeOnly,
  }) {
    Map<_RefreshableWidgetState, XState> ret = {};
    //
    if (withHookPiece) {
      ret.addAll(
        _findMountedPieceWidgetStates(activeOnly: activeOnly),
      );
    }
    //
    return ret;
  }

  // ***************************************************************************
  // ***************************************************************************

  @DebugMethodAnnotation()
  Map<IRefreshableWidgetState, XState> debugFindMountedWidgetStates({
    required bool withHookPiece,
    required bool activeOnly,
  }) {
    return _findMountedWidgetStates(
      withHookPiece: withHookPiece,
      activeOnly: activeOnly,
    );
  }
}
