part of '../flutter_artist.dart';

abstract class NonBlock<D extends Object, S extends FilterSnapshot>
    extends BaseBlk {
  late final NonBlockData<D, S> data = NonBlockData<D, S>(this);

  final NonBlockHiddenBehavior hiddenBehavior;

  final Map<_WidgetState, bool> _nonBlockFragmentWidgetStateListeners = {};

  NonBlock({
    required this.hiddenBehavior,
  });

  Future<bool> query() async {
    // TODO: Take Snapshot
    S? filterSnapshot = null;
    ApiResult<D> result;
    try {
      StorageX.codeFlowLogger._addMethodCall(
        isLibCode: false,
        route: null,
        object: this,
        methodName: "callApiQuery",
        parameters: {},
      );
      //
      result = await callApiQuery(filterSnapshot: filterSnapshot);
    } catch (e, stackTrace) {
      _handleError(
        className: getClassName(this),
        methodName: "callApiQuery",
        error: e,
        stackTrace: stackTrace,
        showSnackbar: true,
      );
      //
      return false;
    }
    //
    if (result.errorMessage != null) {
      _handleRestError(
        methodName: "callApiQuery",
        message: result.errorMessage!,
        errorDetails: result.errorDetails,
        showSnackbar: true,
      );
      return false;
    }

    // TODO: Xu ly cac tinh huong loi???
    data._updateFrom(
      filterSnapshot: filterSnapshot,
      data: result.data,
      dataState: DataState.ready,
    );

    return true;
  }

  Future<ApiResult<D>> callApiQuery({
    required S? filterSnapshot,
  });

  bool hasActiveNonBlockFragmentWidget() {
    _removeUnmountedWidgetStates(_nonBlockFragmentWidgetStateListeners);

    var map = {..._nonBlockFragmentWidgetStateListeners};
    for (State widgetState in map.keys) {
      if (widgetState.mounted) {
        bool isShowing = map[widgetState] ?? false;
        if (isShowing) {
          return true;
        }
      }
    }
    return false;
  }

  bool hasActiveUiComponent() {
    return hasActiveNonBlockFragmentWidget();
  }

  void _addWidgetStateListener({
    required _WidgetState widgetState,
    required bool isShowing,
  }) {
    bool activeOLD = hasActiveUiComponent();
    _nonBlockFragmentWidgetStateListeners[widgetState] = isShowing;
    bool activeCURRENT = hasActiveUiComponent();
    //
    if (isShowing) {
      StorageX._addRecentShelf(shelf);
    }
    //
    if (!activeOLD && activeCURRENT) {
      // Fire event:
      shelf._startNewLazyQueryTransactionIfNeed();
    } else if (activeOLD && !activeCURRENT) {
      _fireNonBlockHidden();
    }
  }

  void _removeWidgetStateListener({required State widgetState}) {
    bool activeOLD = hasActiveUiComponent();
    _nonBlockFragmentWidgetStateListeners.remove(widgetState);
    bool activeCURRENT = hasActiveUiComponent();
    //
    if (activeOLD && !activeCURRENT) {
      StorageX._checkToRemoveShelf(shelf);
      _fireNonBlockHidden();
    }
  }

  void _fireNonBlockHidden() {
    StorageX.codeFlowLogger._addEvent(
      object: this,
      event: "NonBlock '${getClassName(this)}' just hides all UI Components!",
      isLibCode: true,
    );
    if (hiddenBehavior == NonBlockHiddenBehavior.clear) {
      Future.delayed(
        const Duration(seconds: 0),
        () {
          // TODO: ???????????????
          // this.emptyQuery();
        },
      );
    }
  }
}
