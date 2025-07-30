part of '../../_fa_core.dart';

abstract class Activity extends _XBase {
  late final Shelf shelf;

  final String name;
  final ActivityConfig config;

  final Map<_RefreshableWidgetState, bool> _activityFragmentWidgetStates = {};
  final Map<_RefreshableWidgetState, bool> _activityControlWidgetStates = {};

  Activity({
    required this.name,
    ActivityConfig config = const ActivityConfig(),
  }) : config = config.copy();

  // ***************************************************************************
  // ***************************************************************************

  void updateFragmentWidgets() {
    for (_RefreshableWidgetState state in _activityFragmentWidgetStates.keys) {
      if (state.mounted) {
        state.refreshState();
      }
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  bool hasMountedUIComponent() {
    return _activityFragmentWidgetStates.isNotEmpty ||
        _activityControlWidgetStates.isNotEmpty;
  }

  // ***************************************************************************
  // ***************************************************************************

  bool _hasActiveActivityFragmentWidgetState() {
    for (State widgetState in _activityFragmentWidgetStates.keys) {
      if (widgetState.mounted) {
        bool isShowing = _activityFragmentWidgetStates[widgetState] ?? false;
        if (isShowing) {
          return true;
        }
      }
    }
    return false;
  }

  // ***************************************************************************
  // ***************************************************************************

  void _addActivityFragmentWidgetState({
    required _RefreshableWidgetState widgetState,
    required bool isShowing,
  }) {
    bool activeOLD = hasActiveUIComponent();
    _activityFragmentWidgetStates[widgetState] = isShowing;
    bool activeCURRENT = hasActiveUIComponent();
    //
    if (isShowing) {
      FlutterArtist.storage._addRecentShelf(shelf);
    }
    //
    if (!activeOLD && activeCURRENT) {
      // Fire event:
      shelf._startLoadDataForLazyUIComponentsIfNeed();
    } else if (activeOLD && !activeCURRENT) {
      _fireActivityHidden();
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  void _removeActivityFragmentWidgetState({required State widgetState}) {
    bool activeOLD = hasActiveUIComponent();
    _activityFragmentWidgetStates.remove(widgetState);
    bool activeCURRENT = hasActiveUIComponent();
    //
    if (activeOLD && !activeCURRENT) {
      _fireActivityHidden();
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  void _fireActivityHidden() {
    FlutterArtist.codeFlowLogger._addEvent(
      ownerClassInstance: this,
      event: "Activity '${getClassName(this)}' just hides all UI Components!",
      isLibCode: true,
    );
    switch (config.hiddenBehavior) {
      case ActivityHiddenBehavior.none:
        break;
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  bool hasActiveUIComponent() {
    return _hasActiveActivityFragmentWidgetState() ||
        _hasActiveControlWidgetState();
  }

  // ***************************************************************************
  // ***************************************************************************

  bool _hasActiveControlWidgetState() {
    for (State widgetState in _activityControlWidgetStates.keys) {
      if (widgetState.mounted) {
        bool isShowing = _activityControlWidgetStates[widgetState] ?? false;
        if (isShowing) {
          return true;
        }
      }
    }
    return false;
  }
}
