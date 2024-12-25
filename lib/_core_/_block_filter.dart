part of '../flutter_artist.dart';

abstract class BlockFilter<S extends FilterSnapshot> {
  late final String name;

  late final Shelf shelf;

  final List<Block> _blocks = [];

  List<Block> get blocks => [..._blocks];

  final List<NonBlock> _nonBlocks = [];

  List<NonBlock> get nonBlocks => [..._nonBlocks];

  S? _currentSnapshot;

  List<Restorable> get restorableCriteria;

  final Map<_WidgetState, bool> _widgetStateListeners = {};

  ///
  /// This method is always called whenever the [Block.queryXxx()] method is called.
  ///
  /// When calling this method from outside you can pass parameter [suggestedFilterData].
  /// This parameter will always be null if you call the [Block.queryXxx()] method.
  ///
  /// ```Dart
  /// Future<void> prepareData({SuggestedFilterData? suggestedFilterData}) {
  ///     ApiResult<dynamic>? r1 = await callYourApi1();
  ///     // Throws ApiError if r1.isError()
  ///     r1?.throwIfError();
  ///
  ///     ApiResult<dynamic>? r2 = await callYourApi2();
  ///     // Throws ApiError if r2.isError()
  ///     r2?.throwIfError();
  /// }
  /// ```
  ///
  Future<void> prepareData({
    SuggestedFilterData? suggestedFilterData,
  });

  String getFilterSnapshotTypeAsString() {
    return S.toString();
  }

  ///
  /// This method is called immediately after calling prepareData() method if there are no errors.
  ///
  S takeSnapshot();

  Future<bool> queryBlocks({
    SuggestedFilterData? suggestedFilterData,
  }) async {
    StorageX.codeFlowLogger._addMethodCall(
      isLibCode: true,
      object: this,
      methodName: "queryBlocks",
      parameters: {
        "suggestedFilterData": suggestedFilterData,
      },
      route: null,
    );
    //
    bool success = true;
    for (Block block in _blocks) {
      bool s = await block.query(suggestedFilterData: suggestedFilterData);
      if (!s) {
        success = s;
      }
    }
    return success;
  }

  bool hasActiveFilterFragmentWidget() {
    _removeUnmountedWidgetStates(_widgetStateListeners);

    for (State widgetState in _widgetStateListeners.keys) {
      bool isShowing = _widgetStateListeners[widgetState] ?? false;
      if (isShowing && widgetState.mounted) {
        return true;
      }
    }
    return false;
  }

  Map<_WidgetState, bool> _findMountedWidgetStates({
    required bool activeOnly,
  }) {
    _removeUnmountedWidgetStates(_widgetStateListeners);

    Map<_WidgetState, bool> ret = {};
    Map<_WidgetState, bool> m = {..._widgetStateListeners};
    for (_WidgetState key in m.keys) {
      if (key.mounted) {
        if (!activeOnly || m[key]!) {
          ret[key] = m[key]!;
        }
      }
    }
    return ret;
  }

  void _addWidgetStateListener({
    required _WidgetState widgetState,
    required bool isShowing,
  }) {
    _widgetStateListeners[widgetState] = isShowing;
    if (isShowing) {
      StorageX._addRecentShelf(shelf);
    }
  }

  void _removeWidgetStateListener({required State widgetState}) {
    _widgetStateListeners.remove(widgetState);
    StorageX._checkToRemoveShelf(shelf);
  }

  void updateWidgets() {
    _removeUnmountedWidgetStates(_widgetStateListeners);
    for (_WidgetState widgetState in [..._widgetStateListeners.keys]) {
      if (widgetState.mounted) {
        widgetState.refreshState();
      }
    }
  }

  void _restore() {
    for (Restorable bk in restorableCriteria) {
      bk.restore();
    }
  }

  void _applyNewState() {
    for (Restorable bk in restorableCriteria) {
      bk.applyNewState();
    }
  }

  void showErrorSnackbar({
    required String message,
    List<String>? errorDetails,
  }) {
    if (_blocks.isNotEmpty) {
      StorageX.adapter.showErrorSnackbar(
        message: message,
        errorDetails: errorDetails,
      );
    }
  }
}
