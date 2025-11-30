part of '../core.dart';

class _ActivityUIComponents extends _UIComponents {
  final Activity activity;

  // Piece: Fragment.
  final Map<_RefreshableWidgetState, XState> __activityPieceWidgetStates = {};

  // ***************************************************************************
  // ***************************************************************************

  _ActivityUIComponents({required this.activity});

  // ***************************************************************************
  // ***************************************************************************

  void updateActivityPieceWidgets({bool force = false}) {
    for (_RefreshableWidgetState widgetState
        in __activityPieceWidgetStates.keys) {
      if (widgetState.mounted) {
        widgetState.refreshState(force: force);
      }
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  @override
  bool hasMountedUIComponent() {
    return __activityPieceWidgetStates.isNotEmpty;
  }

  // ***************************************************************************
  // ***************************************************************************

  bool hasActiveUIComponentActivityRepresentative({
    bool alsoCheckChildren = false,
  }) {
    String? componentName = _findActiveUIComponentWithRepresentativeType(
      representativeType: RepresentativeType.activityRepresentative,
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

  String? findActiveUIComponentActivityRepresentative({
    bool alsoCheckChildren = false,
  }) {
    return _findActiveUIComponentWithRepresentativeType(
      representativeType: RepresentativeType.activityRepresentative,
      alsoCheckChildren: alsoCheckChildren,
    );
  }

  String? _findActiveUIComponentWithRepresentativeType({
    required RepresentativeType? representativeType,
    bool alsoCheckChildren = false,
  }) {
    bool has = false;
    //
    // Activity Piece:
    //
    String? componentName = findActiveActivityPieceWithRepresentativeType(
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

  bool hasActiveActivityPiece({required bool alsoCheckChildren}) {
    String? componentName = findActiveActivityPiece(
      alsoCheckChildren: alsoCheckChildren,
    );
    return componentName != null;
  }

  String? findActiveActivityPiece({required bool alsoCheckChildren}) {
    return findActiveActivityPieceWithRepresentativeType(
      representativeType: null,
      alsoCheckChildren: alsoCheckChildren,
    );
  }

  String? findActiveActivityPieceWithRepresentativeType({
    required RepresentativeType? representativeType,
    required bool alsoCheckChildren,
  }) {
    var map = {...__activityPieceWidgetStates};
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
    updateActivityPieceWidgets(force: force);
  }

  // ***************************************************************************
  // ***************************************************************************

  Map<_RefreshableWidgetState, XState> _findMountedPieceWidgetStates({
    required bool activeOnly,
  }) {
    return ___findMountedWidgetStates(
      widgetStates: __activityPieceWidgetStates,
      activeOnly: activeOnly,
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  void _addActivityPieceWidgetState({
    required _RefreshableWidgetState widgetState,
    required bool isShowing,
  }) {
    bool hasXActivityRepOLD = hasActiveUIComponentActivityRepresentative(
      alsoCheckChildren: true,
    );
    __activityPieceWidgetStates.update(
      widgetState,
      (xState) => xState.._setShowing(isShowing),
      ifAbsent: () => XState().._setShowing(isShowing),
    );
    bool hasXActivityRepCURRENT = hasActiveUIComponentActivityRepresentative(
      alsoCheckChildren: true,
    );
    //
    if (isShowing) {
      FlutterArtist.storage._addRecentActivity(activity);
    }
    //
    if (!hasXActivityRepOLD && hasXActivityRepCURRENT) {
      // Fire event:
      // activity.shelf._startLoadDataForLazyUIComponentsIfNeed();
      // LOGIC: #0000
      // FlutterArtist.storage._naturalQueryQueue.addShelf(activity.shelf);
    } else if (hasXActivityRepOLD && !hasXActivityRepCURRENT) {
      activity._fireActivityHidden();
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  void _removeActivityPieceWidgetState({required State widgetState}) {
    bool activeOLD = hasActiveUIComponent();
    __activityPieceWidgetStates.remove(widgetState);
    bool activeCURRENT = hasActiveUIComponent();
    //
    if (activeOLD && !activeCURRENT) {
      activity._fireActivityHidden();
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  Map<_RefreshableWidgetState, XState> _findMountedWidgetStates({
    required bool withActivityPiece,
    required bool activeOnly,
  }) {
    Map<_RefreshableWidgetState, XState> ret = {};
    //
    if (withActivityPiece) {
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
    required bool withActivityPiece,
    required bool activeOnly,
  }) {
    return _findMountedWidgetStates(
      withActivityPiece: withActivityPiece,
      activeOnly: activeOnly,
    );
  }
}
