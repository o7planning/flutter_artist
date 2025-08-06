part of '../core.dart';

typedef ShelfCreator<S> = S Function();

class _Storage extends _Core {
  final List<Shelf> _rencentShelves = [];

  final Map<String, ShelfCreator> __shelfCreatorMap = {};
  final Map<String, Shelf> _shelfMap = {};

  Map<String, Shelf?> get shelfMap {
    Map<String, Shelf?> m = __shelfCreatorMap
        .map((k, v) => MapEntry<String, Shelf?>(k, null))
      ..addAll(_shelfMap);
    return m;
  }

  List<String> get shelfNames => [..._shelfMap.keys];

  late final _StorageEventHandler ev = _StorageEventHandler(this);

  late final _StorageExecutor executor = _StorageExecutor(this);

  // ***************************************************************************
  // ***************************************************************************

  _Storage();

  // ***************************************************************************
  // ***************************************************************************

  Shelf? findShelfByName(String shelfName) {
    return _shelfMap[shelfName];
  }

  List<Shelf> getAllShelves() {
    return [..._shelfMap.values];
  }

  // ***************************************************************************
  // ***************************************************************************

  void _logout() {
    _shelfMap.clear();
  }

  // ***************************************************************************
  // ***************************************************************************

  ///
  /// Very Dangerous!!! Only call on startup.
  ///
  void __clear() {
    _rencentShelves.clear();
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
    print("FLUTTER ARTIST DEBUG >>>>>>>>>>>>>>> create Shelf: $shelfName");

    ShelfCreator? creator = __shelfCreatorMap[shelfName];
    if (creator == null) {
      throw DebugPrint.printFatalError(
          " ERROR: '$shelfName' not found. You need to call:\n "
          " FlutterArtist.storage.registerShelf(()=> $shelfName())");
    }
    shelf = creator() as F;
    _shelfMap[shelfName] = shelf;
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
    return _rencentShelves.isEmpty ? null : _rencentShelves.first;
  }
}
