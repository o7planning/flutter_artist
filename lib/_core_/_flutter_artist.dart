part of '../flutter_artist.dart';

typedef FrameCreator<S> = S Function();

final FlutterArtist = _FlutterArtist();

const _isOverlayMode = false;

class _FlutterArtist {
  _FlutterArtistData? _globalFluData;
  final Map<String, FrameCreator> __frameCreatorMap = {};
  final Map<String, Frame> __frameMap = {};

  int notificationFetchPeriodInSeconds = 60;
  final _FlutterArtistChangeManager _changeManager =
      _FlutterArtistChangeManager();
  FlutterArtistAdapter? __adapter;

  final _LoggedInUserManager _loggedInUserManager = _LoggedInUserManager();
  LoggedInUserAdapter? __fluLoggedInUserAdapter;
  AppNotificationAdapter? __fluNotificationAdapter;

  Function(BuildContext context)? _showRestDebugDialog;

  late final ErrorLogger errorLogger = ErrorLogger(
    maxDisplayErrorCount: 20,
  );

  late final _BaseNotificationEngine __fluNotificationEngine;
  late final CodeFlowLogger codeFlowLogger = CodeFlowLogger();

  final List<Frame> _rencentFrames = [];

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
    __frameMap.clear();
    _rencentFrames.clear();
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

  AppNotificationAdapter? get notificationAdapter {
    return __fluNotificationAdapter;
  }

  LoggedInUserAdapter? get loggedInUserAdapter {
    return __fluLoggedInUserAdapter;
  }

  FluLoggedInUser? get loggedInUser {
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
  Future<void> setOrUpdateLoggedInUser(FluLoggedInUser loggedInUser) async {
    await _loggedInUserManager.setOrUpdateLoggedInUser(loggedInUser);
  }

  Future<void> config({
    required FlutterArtistAdapter flutterArtistAdapter,
    required AppNotificationAdapter? notificationAdapter,
    required LoggedInUserAdapter? loggedInUserAdapter,
    required Function(BuildContext context)? showRestDebugDialog,
    int notificationFetchPeriodInSeconds = 60,
  }) async {
    if (__adapter != null) {
      throw "FlutterArtistAdapter already registered!";
    }
    __adapter = flutterArtistAdapter;
    //
    __fluLoggedInUserAdapter = loggedInUserAdapter;
    await _loggedInUserManager._initFromLocal();
    //
    _showRestDebugDialog = showRestDebugDialog;
    //
    __fluNotificationAdapter = notificationAdapter;
    //
    this.notificationFetchPeriodInSeconds = notificationFetchPeriodInSeconds;
    //
    // FluNotificationAdapter ready, start Notification
    //
    __fluNotificationEngine = _BaseNotificationEngine();
    __fluNotificationEngine.start();
  }

  Map<String, Frame?> get frameMap {
    Map<String, Frame?> m = __frameCreatorMap
        .map((k, v) => MapEntry<String, Frame?>(k, null))
      ..addAll(__frameMap);
    return m;
  }

  String _getFrameName(Type type) {
    return type.toString();
  }

  void registerFrame<F extends Frame>(FrameCreator<F> builder) {
    final String key = _getFrameName(F);
    FrameCreator? mng = __frameCreatorMap[key];
    if (mng == null) {
      __frameCreatorMap[key] = builder;
    }
  }

  F _createFrame<F extends Frame>(String frameName) {
    F? frame = __frameMap[frameName] as F?;
    if (frame != null) {
      return frame;
    }
    print("FLUTTER ARTIST DEBUG >>>>>>>>>>>>>>> create Frame: $frameName");

    FrameCreator? creator = __frameCreatorMap[frameName];
    if (creator == null) {
      throw "\n**********************************************************************************************************"
          "\n '${F.toString()}' not found. You need to call FlutterArtist.lazyPut(()=> $frameName())"
          "\n**********************************************************************************************************";
    }
    frame = creator() as F;
    __frameMap[frameName] = frame;
    _changeManager._registerFrame(frameName, frame);
    return frame;
  }

  void _loadAll() {
    for (String frameName in __frameCreatorMap.keys) {
      _createFrame(frameName);
    }
  }

  Frame? _findFrame(Type frameType) {
    final String key = _getFrameName(frameType);
    Frame? frame = __frameMap[key];
    frame ??= _createFrame(key);
    return frame;
  }

  F findFrame<F extends Frame>() {
    final String key = _getFrameName(F);
    Frame? frame = __frameMap[key];
    frame ??= _createFrame(key);
    return frame as F;
  }

  F? findOrNullFlu<F extends Frame>() {
    final String key = _getFrameName(F);
    F? frame = __frameMap[key] as F?;
    return frame;
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
    Frame? frame = _recentFrame();
    return frame != null;
  }

  Future<void> showUiComponentsDialog() async {
    Frame? frame = _recentFrame();
    if (frame == null) {
      return;
    }
    await frame.showActiveUiComponentsDialog();
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
    await _showGalleryRoomDialog(context: context, frame: null);
  }

  Future<void> showFlowLogDialog() async {
    BuildContext context = adapter.getCurrentContext();
    await _showFlowLogViewerDialog(context: context);
  }

  Future<void> showFrameStructure() async {
    Frame? frame = _recentFrame();
    if (frame == null) {
      return;
    }
    await frame.showFrameStructureDialog();
  }

  bool canShowFrameStructure() {
    Frame? frame = _recentFrame();
    return frame != null;
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

  void _notifyNotification(BaseNotificationSummary notificationSummary) {
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

  void _addRecentFrame(Frame frame) {
    if (_rencentFrames.isEmpty) {
      _rencentFrames.add(frame);
    } else {
      if (_rencentFrames.first == frame) {
        return;
      } else {
        int idx = _rencentFrames.indexOf(frame);
        if (idx == -1) {
          _rencentFrames.insert(0, frame);
        } else {
          var temp = _rencentFrames[0];
          _rencentFrames[0] = _rencentFrames[idx];
          _rencentFrames[idx] = temp;
        }
      }
    }
  }

  void _checkToRemoveFrame(Frame frame) {
    // TODO.
  }

  Frame? _recentFrame() {
    return _rencentFrames.isEmpty ? null : _rencentFrames.first;
  }

  // ===========================================================================
  // ===========================================================================

  // @Callable
  Map<String, Frame> _getIndependentFrames() {
    Map<String, Frame> notifierMap = _getNotifierFrames();
    Map<String, Frame> listenerMap = _getListenerFrames();
    Map<String, Frame> map = {}..addAll(__frameMap);
    map.removeWhere((frameName, frame) =>
        notifierMap.keys.contains(frameName) ||
        listenerMap.keys.contains(frameName));
    return map;
  }

  // ===========================================================================
  // ===========================================================================

  // @Callable
  Map<String, Frame> _getNotifierFrames() {
    Map<String, Frame> foundFrameMap = {};
    //
    for (Frame frame in __frameMap.values) {
      __findNotifierFrames(
        listenerFrame: frame,
        foundFrameMap: foundFrameMap,
      );
    }
    return foundFrameMap;
  }

  // Private Method. Only for use in this class.
  void __findNotifierFrames({
    required Frame listenerFrame,
    required Map<String, Frame> foundFrameMap,
  }) {
    for (Block rootListenerBlock in listenerFrame.rootBlocks) {
      __findNotifierFrameCascade(
        listenerBlock: rootListenerBlock,
        foundFrameMap: foundFrameMap,
      );
    }
  }

  // Private Method. Only for use in this class.
  void __findNotifierFrameCascade({
    required Block listenerBlock,
    required Map<String, Frame> foundFrameMap,
  }) {
    for (SourceOfChange notifier in listenerBlock.listenForChangesFrom ?? []) {
      Type notifierFluType = notifier.frameType;
      String frameName = _getFrameName(notifierFluType);
      Frame? notifierFlu = __frameMap[frameName];
      if (notifierFlu != null) {
        foundFrameMap[frameName] = notifierFlu;
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
  Map<String, Frame> _getListenerFrames() {
    Map<String, Frame> foundFrameMap = {};
    //
    for (String frameName in __frameMap.keys) {
      Frame frame = __frameMap[frameName]!;

      for (Block rootBlock in frame.rootBlocks) {
        bool found = __foundListenerFrameCascade(block: rootBlock);
        if (found) {
          foundFrameMap[frameName] = frame;
          break;
        }
      }
    }
    return foundFrameMap;
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
  List<FrameBlockType> _getNotifierBlocks({
    required Block listenerBlock,
  }) {
    List<FrameBlockType> foundFluBlockTypes = [];
    for (SourceOfChange notifier in listenerBlock.listenForChangesFrom ?? []) {
      foundFluBlockTypes.add(
        FrameBlockType(
          frameType: notifier.frameType,
          blockType: notifier.blockType,
        ),
      );
    }
    return foundFluBlockTypes;
  }

  // ===========================================================================
  // ===========================================================================

  // Callable.
  List<FrameBlockType> _getListenerBlocks({required Block notifierBlock}) {
    List<FrameBlockType> foundFluBlockTypes = [];

    for (String frameName in __frameMap.keys) {
      Frame? frame = __frameMap[frameName];
      if (frame == null) {
        continue;
      }
      for (Block rootBlock in frame.rootBlocks) {
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
    required List<FrameBlockType> foundFluBlockTypes,
  }) {
    for (SourceOfChange notifier in blockToCheck.listenForChangesFrom ?? []) {
      if (notifier.frameType == notifierBlock.frame.runtimeType &&
          notifier.blockType == notifierBlock.runtimeType) {
        foundFluBlockTypes.add(
          FrameBlockType(
            frameType: blockToCheck.frame.runtimeType,
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
