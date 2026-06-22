part of '../core.dart';

abstract class _DrawerCtrl {
  final _Storage _storage;

  bool get isOpen;

  _DrawerCtrl(_Storage storage) : _storage = storage;
}

class _DrawerController extends _DrawerCtrl {
  _DrawerController(super.storage);

  @override
  bool get isOpen {
    final rootContext = FlutterArtistCore.context;

    ScaffoldState? activeScaffold;

    // Deep-traverse the active element layout tree downwards
    void findScaffold(Element el) {
      if (el is StatefulElement && el.state is ScaffoldState) {
        activeScaffold = el.state as ScaffoldState;
        // Target located, terminate this specific branch pass
        return;
      }
      // Recursive call pass down to children nodes
      el.visitChildren(findScaffold);
    }

    rootContext.visitChildElements((element) {
      findScaffold(element);
    });

    return activeScaffold?.isDrawerOpen ?? false;
  }
}

class _EndDrawerController extends _DrawerCtrl {
  _EndDrawerController(super.storage);

  @override
  bool get isOpen {
    final rootContext = FlutterArtistCore.context;

    ScaffoldState? activeScaffold;

    // Deep-traverse the active element layout tree downwards
    void findScaffold(Element el) {
      if (el is StatefulElement && el.state is ScaffoldState) {
        activeScaffold = el.state as ScaffoldState;
        return;
      }
      el.visitChildren(findScaffold);
    }

    rootContext.visitChildElements((element) {
      findScaffold(element);
    });

    return activeScaffold?.isEndDrawerOpen ?? false;
  }
}
