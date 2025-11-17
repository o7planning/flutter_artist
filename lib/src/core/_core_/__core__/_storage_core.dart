part of '../core.dart';

typedef ShelfCreator<S> = S Function();

abstract class _StorageCore extends _Core {
  final Map<String, ShelfCreator> __shelfCreatorMap = {};
  final Map<String, Shelf> _shelfMap = {};
  final List<Shelf> _recentShelves = [];

  bool __started = false;

  bool get started => __started;

  Map<String, Shelf?> get shelfMap {
    Map<String, Shelf?> m = __shelfCreatorMap
        .map((k, v) => MapEntry<String, Shelf?>(k, null))
      ..addAll(_shelfMap);
    return m;
  }

  List<String> get shelfNames => List.unmodifiable(_shelfMap.keys);

  // ***************************************************************************
  // ***************************************************************************

  _StorageCore();

  // ***************************************************************************
  // ***************************************************************************

  void _setStarted() {
    if (!__started) {
      __started = true;
      //
      DebugPrinter.printDebug(
        DebugCat.appStart,
        "\n<<<<<<<<<<<<<< APP HAS BEEN STARTED! >>>>>>>>>>>>>>>>>>>>>>>>>>>>\n",
      );
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
    if (__started) {
      // LOGIC: #0001
      throw DebugUtils.getFatalError(
        " ERROR: It is not possible to register a new Shelf after the application has been started.",
      );
    }
    final String shelfName = _getShelfName(F);
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
    if (!__started) {
      DebugPrinter.printDebug(
        DebugCat.appStart,
        "FLUTTER ARTIST DEBUG >>>>>>>>>>>>>>> Validating Shelf: $shelfName",
      );
    }

    ShelfCreator? creator = __shelfCreatorMap[shelfName];
    if (creator == null) {
      throw DebugUtils.getFatalError(
          " ERROR: '$shelfName' not found. You need to call:\n "
          " FlutterArtist.storage.registerShelf(()=> $shelfName())");
    }
    shelf = creator() as F;
    if (__started) {
      _shelfMap[shelfName] = shelf;
      //
      DebugPrinter.printDebug(
        DebugCat.shelfCreation,
        "FLUTTER ARTIST DEBUG >>>>>>>>>>>>>>> Create Shelf: $shelfName",
      );
    }
    //
    return shelf;
  }

  // ***************************************************************************
  // ***************************************************************************

  void _loadAll() {
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

  F? findOrNullShelf<F extends Shelf>() {
    final String shelfName = _getShelfName(F);
    F? shelf = _shelfMap[shelfName] as F?;
    return shelf;
  }

  // ***************************************************************************
  // ***************************************************************************

  ///
  /// Very Dangerous!!! Only call on startup.
  ///
  void __clear() {
    _recentShelves.clear();
    __shelfCreatorMap.clear();
    _shelfMap.clear();
  }

  // ***************************************************************************
  // ***************************************************************************

  void _resetForTestOnly() {
    _shelfMap.clear();
  }

  // TODO: Internal Use.
  @DebugMethodAnnotation()
  void debugLoadAll() {
    _loadAll();
  }

  // TODO: Internal Use.
  @DebugMethodAnnotation()
  F debugCreateShelf<F extends Shelf>(String shelfName) {
    return _createShelf(shelfName);
  }

  // ***************************************************************************
  // ***************************************************************************

  void _checkToRemoveShelf(Shelf shelf) {
    bool hasMountedUIComponent = shelf.ui.hasMountedUIComponent();
    if (!hasMountedUIComponent) {
      print(">>>>>>>>>>> Shelf: ${getClassName(shelf)} dispose all component");
      FlutterArtist.codeFlowLogger.addInfo(
        ownerClassInstance: this,
        info: "Shelf: ${getClassName(shelf)} dispose all UI components",
      );
      if (shelf.config.hiddenBehavior == ShelfHiddenBehavior.clear) {
        print(
            "  ---------> Remove ${getClassName(shelf)} from FlutterArtist Storage");
        _shelfMap.remove(shelf.name);
      } else {
        print("  ---------> Do Nothing");
      }
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  Shelf? _recentShelf() {
    return _recentShelves.isEmpty ? null : _recentShelves.first;
  }

  List<Shelf> getRecentShelves({required bool visibleOnly}) {
    List<Shelf> ret = [];
    for (Shelf shelf in _recentShelves) {
      if (shelf.disposed) {
        continue;
      }
      if (visibleOnly) {
        if (!shelf.ui.hasMountedUIComponent()) {
          continue;
        }
      }
      ret.add(shelf);
    }
    return ret;
  }

  // ***************************************************************************
  // ***************************************************************************

  void _addRecentShelf(Shelf shelf) {
    if (_recentShelves.isEmpty) {
      _recentShelves.add(shelf);
    } else {
      if (_recentShelves.first == shelf) {
        return;
      } else {
        int idx = _recentShelves.indexOf(shelf);
        if (idx == -1) {
          _recentShelves.insert(0, shelf);
        } else {
          var temp = _recentShelves[0];
          _recentShelves[0] = _recentShelves[idx];
          _recentShelves[idx] = temp;
        }
      }
    }
  }
}
