part of '../flutter_artist.dart';

abstract class Zilch extends _XBase {
  late final Shelf shelf;

  final String name;

  final ZilchHiddenBehavior hiddenBehavior;

  final Map<_RefreshableWidgetState, bool> _zilchFragmentWidgetStates = {};
  final Map<_RefreshableWidgetState, bool> _zilchControlWidgetStates = {};

  Zilch({
    required this.name,
    this.hiddenBehavior = ZilchHiddenBehavior.none,
  });

  // ***************************************************************************
  // ***************************************************************************

  void updateFragmentWidgets() {
    for (_RefreshableWidgetState state in _zilchFragmentWidgetStates.keys) {
      if (state.mounted) {
        state.refreshState();
      }
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  bool hasMountedUIComponent() {
    return _zilchFragmentWidgetStates.isNotEmpty ||
        _zilchControlWidgetStates.isNotEmpty;
  }

  // ***************************************************************************
  // ***************************************************************************

  bool _hasActiveZilchFragmentWidgetState() {
    for (State widgetState in _zilchFragmentWidgetStates.keys) {
      if (widgetState.mounted) {
        bool isShowing = _zilchFragmentWidgetStates[widgetState] ?? false;
        if (isShowing) {
          return true;
        }
      }
    }
    return false;
  }

  // ***************************************************************************
  // ***************************************************************************

  void _addZilchFragmentWidgetState({
    required _RefreshableWidgetState widgetState,
    required bool isShowing,
  }) {
    bool activeOLD = hasActiveUIComponent();
    _zilchFragmentWidgetStates[widgetState] = isShowing;
    bool activeCURRENT = hasActiveUIComponent();
    //
    if (isShowing) {
      FlutterArtist.storage._addRecentShelf(shelf);
    }
    //
    if (!activeOLD && activeCURRENT) {
      // Fire event:
      shelf._startNewLazyQueryTransactionIfNeed();
    } else if (activeOLD && !activeCURRENT) {
      _fireZilchHidden();
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  void _removeZilchFragmentWidgetState({required State widgetState}) {
    bool activeOLD = hasActiveUIComponent();
    _zilchFragmentWidgetStates.remove(widgetState);
    bool activeCURRENT = hasActiveUIComponent();
    //
    if (activeOLD && !activeCURRENT) {
      _fireZilchHidden();
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  void _fireZilchHidden() {
    FlutterArtist.codeFlowLogger._addEvent(
      ownerClassInstance: this,
      event: "Zilch '${getClassName(this)}' just hides all UI Components!",
      isLibCode: true,
    );
    switch (hiddenBehavior) {
      case ZilchHiddenBehavior.none:
        break;
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  bool hasActiveUIComponent() {
    return _hasActiveZilchFragmentWidgetState() ||
        _hasActiveControlWidgetState();
  }

  // ***************************************************************************
  // ***************************************************************************

  bool _hasActiveControlWidgetState() {
    for (State widgetState in _zilchControlWidgetStates.keys) {
      if (widgetState.mounted) {
        bool isShowing = _zilchControlWidgetStates[widgetState] ?? false;
        if (isShowing) {
          return true;
        }
      }
    }
    return false;
  }
}
