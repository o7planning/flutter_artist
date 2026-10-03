part of '../core.dart';

abstract class _StorageCore extends _Core {
  final Map<String, ShelfCreator> __shelfCreatorMap = {};

  final Map<String, Shelf> _shelfMap = {};

  List<String> get activeShelfNames => List.unmodifiable(_shelfMap.keys);

  List<Shelf> get activeShelves => List.unmodifiable(_shelfMap.values);

  // ***************************************************************************
  // ***************************************************************************

  _StorageCore();

  // ***************************************************************************
  // ***************************************************************************

  void collectGarbage() {
    final now = FlutterArtist.clock.now();
    //
    final keys = _shelfMap.keys.toList();
    for (final key in keys) {
      final shelf = _shelfMap[key];
      if (shelf == null) continue;
      final orphanedAt = shelf.orphanedAt;
      if (orphanedAt == null) continue;

      if (now.difference(orphanedAt).inMilliseconds >=
          FlutterArtist.appConfig.garbageCollectionInterval.inMilliseconds) {
        Shelf? shelf = _shelfMap.remove(key);
        if (shelf != null) {
          FlutterArtist._removeRecentModule(shelf);
        }
        print("Unmount $key");
      }
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  Shelf? findShelfByName(String shelfName) {
    return _shelfMap[shelfName];
  }

  List<Shelf> getAllShelves() {
    return List.unmodifiable(_shelfMap.values);
  }

  // ***************************************************************************
  // ***************************************************************************

  String _getShelfName(Type type) {
    return type.toString();
  }

  @DebugMethodAnnotation()
  String debugGetShelfName(Type type) {
    return _getShelfName(type);
  }

  // ***************************************************************************
  // ***************************************************************************

  void registerShelf<F extends Shelf>(ShelfCreator<F> builder) {
    if (FlutterArtist._navigatorStated) {
      // LOGIC: #0001
      throw DebugUtils.getFatalError(
        " - ERROR: It is not possible to register a new Shelf after the application has been started.",
      );
    }
    //
    final String shelfName = _getShelfName(F);
    FlutterArtist.debugRegister._addDebugRegisterShelf("<b>$shelfName</b>.");
    //
    ShelfCreator? creator = __shelfCreatorMap[shelfName];
    if (creator == null) {
      __shelfCreatorMap[shelfName] = builder;
    }
    _createShelf(shelfName);
  }

  // ***************************************************************************
  // ***************************************************************************

  F _createShelf<F extends Shelf>(String shelfName) {
    F? shelf = _shelfMap[shelfName] as F?;
    if (shelf != null) {
      return shelf;
    }
    if (!FlutterArtist._navigatorStated) {
      // Nothing.
    }

    ShelfCreator? creator = __shelfCreatorMap[shelfName];
    if (creator == null) {
      throw DebugUtils.getFatalError(
          " - ERROR: '$shelfName' not found. You need to call:\n "
          " FlutterArtist.storage.registerShelf(()=> $shelfName())");
    }
    shelf = creator() as F;
    if (FlutterArtist._navigatorStated) {
      _shelfMap[shelfName] = shelf;
    }
    //
    return shelf;
  }

  // ***************************************************************************
  // ***************************************************************************

  void __loadAllShelves() {
    for (String shelfName in __shelfCreatorMap.keys) {
      _createShelf(shelfName);
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  Shelf? _findShelf(Type shelfType) {
    final String shelfName = _getShelfName(shelfType);
    Shelf? shelf = _shelfMap[shelfName];
    shelf ??= _createShelf(shelfName);
    return shelf;
  }

  // TODO: Internal Use.
  @DebugMethodAnnotation()
  Shelf? debugFindShelf(Type shelfType) {
    return _findShelf(shelfType);
  }

  // ***************************************************************************
  // ***************************************************************************

  F findShelf<F extends Shelf>() {
    final String shelfName = _getShelfName(F);
    Shelf? shelf = _shelfMap[shelfName];
    shelf ??= _createShelf(shelfName);
    return shelf as F;
  }

  // ***************************************************************************
  // ***************************************************************************

  F? findShelfOrNull<F extends Shelf>() {
    final String shelfName = _getShelfName(F);
    F? shelf = _shelfMap[shelfName] as F?;
    return shelf;
  }

  // ***************************************************************************
  // ***************************************************************************

  void __clearShelves() {
    __shelfCreatorMap.clear();
    _shelfMap.clear();
  }

  // ***************************************************************************
  // ***************************************************************************

  void _resetForTestOnly() {
    _shelfMap.clear();
  }

  // ***************************************************************************
  // ***************************************************************************

  void _checkToRemoveShelf(Shelf shelf) {
    bool hasMountedUiComponent = shelf.ui.hasMountedViews();
    if (!hasMountedUiComponent) {
      switch (shelf.config.releasePolicy) {
        case ShelfReleasePolicy.retain:
          print(
              "[FLUTTER_ARTIST] ---------> RETAIN_IN_MEMORY: ${getClassName(shelf)}");
          return;
        case ShelfReleasePolicy.unmount:
          print(
              "[FLUTTER_ARTIST] ---------> MARK_TO_RELEASE_AND_PRUNE: ${getClassName(shelf)} - ${DateTime.now()}");
          shelf._markAsOrphaned(true);
          return;
      }
    } else {
      print(
          "[FLUTTER_ARTIST] ---------> SET ORPHANED FALSE: ${getClassName(shelf)} - ${DateTime.now()}");
      shelf._markAsOrphaned(false);
    }
  }
}
