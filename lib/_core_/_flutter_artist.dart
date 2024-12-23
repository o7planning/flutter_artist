part of '../flutter_artist.dart';

typedef FrameCreator<S> = S Function();

final FlutterArtist = _FlutterArtist();

const _isOverlayMode = false;

class _FlutterArtist {
  _FlutterArtistData? _globalFluData;
  final Map<String, FrameCreator> __shelfCreatorMap = {};
  final Map<String, Shelf> __shelfMap = {};

  int notificationFetchPeriodInSeconds = 60;
  final _FlutterArtistChangeManager _changeManager =
      _FlutterArtistChangeManager();
  FlutterArtistAdapter? __adapter;

  final _LoggedInUserManager _loggedInUserManager = _LoggedInUserManager();
  LoggedInUserAdapter? __loggedInUserAdapter;
  NotificationAdapter? __notificationAdapter;

  Function(BuildContext context)? _showRestDebugDialog;

  late final ErrorLogger errorLogger = ErrorLogger(
    maxDisplayErrorCount: 20,
  );

  late final _NotificationEngine __notificationEngine;
  late final CodeFlowLogger codeFlowLogger = CodeFlowLogger();

  final List<Shelf> _rencentShelves = [];

  final List<FluErrorListener> _errorListeners = [];
  final List<FluNotificationListener> _notificationListeners = [];
  int _totalErrorCount = 0;

  final List<Future<dynamic>> __futureTaskList = [];

  _FlutterArtistData? get globalFluData {
    return _globalFluData;
  }

  ///
  /// GetX sample code:
  /// ```dart
  /// GlobalFlu.logout(offAllAndGotoRoute: () {
  ///    Get.offAllNamed(LoginScreen.routeName);
  /// });
  /// ```
  ///
  Future<void> logout({required Function() offAllAndGotoRoute}) async {
    _totalErrorCount = 0;
    __shelfMap.clear();
    _rencentShelves.clear();
    await _loggedInUserManager._logout();
    offAllAndGotoRoute();
  }

  void fireSourceChanged({
    required Block sourceBlock,
    required String? itemIdString,
  }) {
    _changeManager._notifyChange(sourceBlock, itemIdString);
  }

  void registerGlobalFluData(_FlutterArtistData globalFluData) {
    if (_globalFluData != null) {
      throw "\n*************************************************************"
          "\n >>>>>> GlobalFluData already registered!"
          "\n*************************************************************";
    }
    _globalFluData = globalFluData;
  }

  FlutterArtistAdapter get adapter {
    if (__adapter == null) {
      throw "\n*************************************************************"
          "\n >>>>>> FluDatablocksAdapter is not registered!. "
          "\n >>>>>> You need to call GlobalFlu.config() in main.dart"
          "\n*************************************************************";
    }
    return __adapter!;
  }

  NotificationAdapter? get notificationAdapter {
    return __notificationAdapter;
  }

  LoggedInUserAdapter? get loggedInUserAdapter {
    return __loggedInUserAdapter;
  }

  ILoggedInUser? get loggedInUser {
    return _loggedInUserManager.loggedInUser;
  }

  ///
  /// Sets or updates the logged in User.
  ///
  /// This method will throw an error if the new user and the old user do not have the same username.
  ///
  /// ```dart
  /// if(oldLoggedInUser != null
  ///           && oldLoggedInUser!.userName != loggedInUser.userName) {
  ///    throw Exception("You need to log out before setting up a new user.");
  /// }
  /// ```
  ///
  Future<void> setOrUpdateLoggedInUser(ILoggedInUser loggedInUser) async {
    await _loggedInUserManager.setOrUpdateLoggedInUser(loggedInUser);
  }

  Future<void> config({
    required FlutterArtistAdapter flutterArtistAdapter,
    required NotificationAdapter? notificationAdapter,
    required LoggedInUserAdapter? loggedInUserAdapter,
    required Function(BuildContext context)? showRestDebugDialog,
    int notificationFetchPeriodInSeconds = 60,
  }) async {
    if (__adapter != null) {
      throw "FlutterArtistAdapter already registered!";
    }
    __adapter = flutterArtistAdapter;
    //
    __loggedInUserAdapter = loggedInUserAdapter;
    await _loggedInUserManager._initFromLocal();
    //
    _showRestDebugDialog = showRestDebugDialog;
    //
    __notificationAdapter = notificationAdapter;
    //
    this.notificationFetchPeriodInSeconds = notificationFetchPeriodInSeconds;
    //
    // FluNotificationAdapter ready, start Notification
    //
    __notificationEngine = _NotificationEngine();
    __notificationEngine.start();
  }

  Map<String, Shelf?> get shelfMap {
    Map<String, Shelf?> m = __shelfCreatorMap
        .map((k, v) => MapEntry<String, Shelf?>(k, null))
      ..addAll(__shelfMap);
    return m;
  }

  String _getShelfName(Type type) {
    return type.toString();
  }

  void registerFrame<F extends Shelf>(FrameCreator<F> builder) {
    final String key = _getShelfName(F);
    FrameCreator? mng = __shelfCreatorMap[key];
    if (mng == null) {
      __shelfCreatorMap[key] = builder;
    }
  }

  F _createShelf<F extends Shelf>(String shelfName) {
    F? shelf = __shelfMap[shelfName] as F?;
    if (shelf != null) {
      return shelf;
    }
    print("FLUTTER ARTIST DEBUG >>>>>>>>>>>>>>> create Frame: $shelfName");

    FrameCreator? creator = __shelfCreatorMap[shelfName];
    if (creator == null) {
      throw "\n**********************************************************************************************************"
          "\n '${F.toString()}' not found. You need to call FlutterArtist.lazyPut(()=> $shelfName())"
          "\n**********************************************************************************************************";
    }
    shelf = creator() as F;
    __shelfMap[shelfName] = shelf;
    _changeManager._registerShelf(shelfName, shelf);
    return shelf;
  }

  void _loadAll() {
    for (String shelfName in __shelfCreatorMap.keys) {
      _createShelf(shelfName);
    }
  }

  Shelf? _findShelf(Type shelfType) {
    final String key = _getShelfName(shelfType);
    Shelf? shelf = __shelfMap[key];
    shelf ??= _createShelf(key);
    return shelf;
  }

  F findFrame<F extends Shelf>() {
    final String key = _getShelfName(F);
    Shelf? shelf = __shelfMap[key];
    shelf ??= _createShelf(key);
    return shelf as F;
  }

  F? findOrNullFlu<F extends Shelf>() {
    final String key = _getShelfName(F);
    F? shelf = __shelfMap[key] as F?;
    return shelf;
  }

  void addErrorListener(FluErrorListener listener) {
    if (!_errorListeners.contains(listener)) {
      _errorListeners.add(listener);
    }
  }

  void removeErrorListener(FluErrorListener listener) {
    _errorListeners.remove(listener);
  }

  void addNotificationListener(FluNotificationListener listener) {
    if (!_notificationListeners.contains(listener)) {
      _notificationListeners.add(listener);
    }
  }

  void removeNotificationListener(FluNotificationListener listener) {
    _notificationListeners.remove(listener);
  }

  bool _canShowUiComponentDialog() {
    Shelf? shelf = _recentShelf();
    return shelf != null;
  }

  Future<void> showUiComponentsDialog() async {
    Shelf? shelf = _recentShelf();
    if (shelf == null) {
      return;
    }
    await shelf.showActiveUiComponentsDialog();
  }

  Future<dynamic> executeTask({
    required Future<dynamic> Function() asyncFunction,
  }) {
    Future<dynamic> future = asyncFunction();
    __futureTaskList.add(future);
    future.whenComplete(() {
      if (_isOverlayMode) {
        Future.delayed(const Duration(milliseconds: 30), () {
          __futureTaskList.remove(future);
        });
      } else {
        __futureTaskList.remove(future);
      }
    });
    _showOverlayIfNeed();
    return future;
  }

  void _showOverlayIfNeed() {
    if (isOverlaysOpen()) {
      return;
    }
    showOverlay(
      asyncFunction: () async {
        await Future.doWhile(
          () => Future.delayed(
            const Duration(milliseconds: 5),
          ).then(
            (_) {
              return __futureTaskList.isNotEmpty;
            },
          ),
        );
      },
    );
  }

  Future<void> showOverlay({
    required Future<dynamic> Function() asyncFunction,
  }) async {
    await adapter.showOverlay(
      opacity: _isOverlayMode ? 0.3 : 0.02,
      asyncFunction: asyncFunction,
    );
  }

  bool isOverlaysOpen() {
    return adapter.isOverlaysOpen();
  }

  Future<void> showGalleryRoomDialog() async {
    BuildContext context = adapter.getCurrentContext();
    await _showGalleryRoomDialog(context: context, shelf: null);
  }

  Future<void> showFlowLogDialog() async {
    BuildContext context = adapter.getCurrentContext();
    await _showFlowLogViewerDialog(context: context);
  }

  Future<void> showShelfStructure() async {
    Shelf? shelf = _recentShelf();
    if (shelf == null) {
      return;
    }
    await shelf.showShelfStructureDialog();
  }

  bool canShowShelfStructure() {
    Shelf? shelf = _recentShelf();
    return shelf != null;
  }

  Future<void> showRecentErrors() async {
    showErrorViewerDialog();
  }

  Future<void> showErrorViewerDialog() async {
    BuildContext context = adapter.getCurrentContext();
    await _showErrorViewerDialog(
      context: context,
      errorLogger: errorLogger,
    );
  }

  bool hasRecentErrors() {
    return errorLogger.errorCount != 0;
  }

  void _notifyError() {
    for (FluErrorListener listener in [..._errorListeners]) {
      if (listener is State) {
        State state = listener as State;
        if (!state.mounted) {
          _errorListeners.remove(listener);
          continue;
        }
      }
      listener.onError();
    }
  }

  void _notifyNotification(INotificationSummary notificationSummary) {
    for (FluNotificationListener listener in [..._notificationListeners]) {
      if (listener is State) {
        State state = listener as State;
        if (!state.mounted) {
          _errorListeners.remove(listener);
          continue;
        }
      }
      listener.handleNotification(notificationSummary);
    }
  }

  void _addRecentShelf(Shelf shelf) {
    if (_rencentShelves.isEmpty) {
      _rencentShelves.add(shelf);
    } else {
      if (_rencentShelves.first == shelf) {
        return;
      } else {
        int idx = _rencentShelves.indexOf(shelf);
        if (idx == -1) {
          _rencentShelves.insert(0, shelf);
        } else {
          var temp = _rencentShelves[0];
          _rencentShelves[0] = _rencentShelves[idx];
          _rencentShelves[idx] = temp;
        }
      }
    }
  }

  void _checkToRemoveFrame(Shelf shelf) {
    // TODO.
  }

  Shelf? _recentShelf() {
    return _rencentShelves.isEmpty ? null : _rencentShelves.first;
  }

  // ===========================================================================
  // ===========================================================================

  // @Callable
  Map<String, Shelf> _getIndependentShelves() {
    Map<String, Shelf> notifierMap = _getNotifierShelves();
    Map<String, Shelf> listenerMap = _getListenerShelves();
    Map<String, Shelf> map = {}..addAll(__shelfMap);
    map.removeWhere((shelfName, shelf) =>
        notifierMap.keys.contains(shelfName) ||
        listenerMap.keys.contains(shelfName));
    return map;
  }

  // ===========================================================================
  // ===========================================================================

  // @Callable
  Map<String, Shelf> _getNotifierShelves() {
    Map<String, Shelf> foundShelfMap = {};
    //
    for (Shelf shelf in __shelfMap.values) {
      __findNotifierShelves(
        listenerShelf: shelf,
        foundShelfMap: foundShelfMap,
      );
    }
    return foundShelfMap;
  }

  // Private Method. Only for use in this class.
  void __findNotifierShelves({
    required Shelf listenerShelf,
    required Map<String, Shelf> foundShelfMap,
  }) {
    for (Block rootListenerBlock in listenerShelf.rootBlocks) {
      __findNotifierFrameCascade(
        listenerBlock: rootListenerBlock,
        foundFrameMap: foundShelfMap,
      );
    }
  }

  // Private Method. Only for use in this class.
  void __findNotifierFrameCascade({
    required Block listenerBlock,
    required Map<String, Shelf> foundFrameMap,
  }) {
    for (SourceOfChange notifier in listenerBlock.listenForChangesFrom ?? []) {
      Type notifierShelfType = notifier.shelfType;
      String shelfName = _getShelfName(notifierShelfType);
      Shelf? notifierShelf = __shelfMap[shelfName];
      if (notifierShelf != null) {
        foundFrameMap[shelfName] = notifierShelf;
      }
    }
    for (Block childListenerBlock in listenerBlock.childBlocks) {
      __findNotifierFrameCascade(
        listenerBlock: childListenerBlock,
        foundFrameMap: foundFrameMap,
      );
    }
  }

  // ===========================================================================
  // ===========================================================================

  // @Callable
  Map<String, Shelf> _getListenerShelves() {
    Map<String, Shelf> foundShelfMap = {};
    //
    for (String shelfName in __shelfMap.keys) {
      Shelf shelf = __shelfMap[shelfName]!;

      for (Block rootBlock in shelf.rootBlocks) {
        bool found = __foundListenerFrameCascade(block: rootBlock);
        if (found) {
          foundShelfMap[shelfName] = shelf;
          break;
        }
      }
    }
    return foundShelfMap;
  }

  // Private Method. Only for use in this class.
  bool __foundListenerFrameCascade({required Block block}) {
    if (block.listenForChangesFrom != null &&
        block.listenForChangesFrom!.isNotEmpty) {
      return true;
    }
    for (Block childBlock in block.childBlocks) {
      bool found = __foundListenerFrameCascade(block: childBlock);
      if (found) {
        return true;
      }
    }
    return false;
  }

  // ===========================================================================
  // ===========================================================================

  // Callable.
  List<ShelfBlockType> _getNotifierBlocks({
    required Block listenerBlock,
  }) {
    List<ShelfBlockType> foundFluBlockTypes = [];
    for (SourceOfChange notifier in listenerBlock.listenForChangesFrom ?? []) {
      foundFluBlockTypes.add(
        ShelfBlockType(
          shelfType: notifier.shelfType,
          blockType: notifier.blockType,
        ),
      );
    }
    return foundFluBlockTypes;
  }

  // ===========================================================================
  // ===========================================================================

  // Callable.
  List<ShelfBlockType> _getListenerBlocks({required Block notifierBlock}) {
    List<ShelfBlockType> foundFluBlockTypes = [];

    for (String shelfName in __shelfMap.keys) {
      Shelf? shelf = __shelfMap[shelfName];
      if (shelf == null) {
        continue;
      }
      for (Block rootBlock in shelf.rootBlocks) {
        __findListenerBlocksCascade(
          notifierBlock: notifierBlock,
          blockToCheck: rootBlock,
          foundFluBlockTypes: foundFluBlockTypes,
        );
      }
    }
    return foundFluBlockTypes;
  }

  // Private Method. Only for use in this class.
  void __findListenerBlocksCascade({
    required Block notifierBlock,
    required Block blockToCheck,
    required List<ShelfBlockType> foundFluBlockTypes,
  }) {
    for (SourceOfChange notifier in blockToCheck.listenForChangesFrom ?? []) {
      if (notifier.shelfType == notifierBlock.shelf.runtimeType &&
          notifier.blockType == notifierBlock.runtimeType) {
        foundFluBlockTypes.add(
          ShelfBlockType(
            shelfType: blockToCheck.shelf.runtimeType,
            blockType: blockToCheck.runtimeType,
          ),
        );
        break;
      }
    }
    for (Block childBlock in blockToCheck.childBlocks) {
      __findListenerBlocksCascade(
        notifierBlock: notifierBlock,
        blockToCheck: childBlock,
        foundFluBlockTypes: foundFluBlockTypes,
      );
    }
  }
}
