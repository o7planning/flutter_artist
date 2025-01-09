part of '../flutter_artist.dart';

class _StorageStructureGraphView extends StatefulWidget {
  final _StorageStructureGraphController controller;
  final Function(Shelf shelf) onSelectShelfToShowGraph;
  final Function(Shelf shelf) onSelectShelfToShowTreeView;

  const _StorageStructureGraphView({
    required this.controller,
    required this.onSelectShelfToShowGraph,
    required this.onSelectShelfToShowTreeView,
  });

  @override
  State<_StorageStructureGraphView> createState() =>
      _StorageStructureGraphViewState();
}

class _StorageStructureGraphViewState
    extends State<_StorageStructureGraphView> {
  final Set<NliType> nliTypes = {
    NliType.independent,
    NliType.listener,
    NliType.notifier,
  };

  String? selectedShelfName;

  final BuchheimWalkerConfiguration config =
      _GalerryBuchheimWalkerConfiguration();

  final EdgeInsets boundaryMargin = const EdgeInsets.only(left: 20, right: 20);

  @override
  void initState() {
    super.initState();
    widget.controller._setSelectedShelf = (Shelf shelf) {
      setState(() {
        selectedShelfName = FlutterArtist.storage._getShelfName(
          shelf.runtimeType,
        );
      });
    };
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _buildMain(),
        Positioned(
          top: 10,
          right: 10,
          child: _buildTopRightButtons(),
        ),
      ],
    );
  }

  void selectedDefaultFlu(_GraphGItem rootItem) {
    bool found = false;
    for (_GraphGItem item in rootItem.children) {
      if (item.shelfName == selectedShelfName) {
        found = true;
        break;
      }
    }
    if (!found) {
      _GraphGItem? item =
          rootItem.children.isEmpty ? null : rootItem.children[0];
      if (item != null) {
        _onSelectFluToShowTreeView(item);
      }
    }
  }

  Widget _buildMain() {
    final Graph graph = Graph()..isTree = false;
    _GraphGItem rootItem = _createRootItemAndChildren();
    Map<String, _GraphGItem> graphItemMap = <String, _GraphGItem>{};
    final String rootNodeId = rootItem.shelfName;
    //
    graphItemMap[rootNodeId] = rootItem;
    //
    Map<String, Node> nodeMap = {};
    //

    final rootNode = Node.Id(rootNodeId);
    nodeMap[rootNodeId] = rootNode;
    //
    _addToMapCascade(
      graph: graph,
      currentNode: rootNode,
      childItems: rootItem.children,
      graphItemMap: graphItemMap,
      nodeMap: nodeMap,
    );
    //
    WidgetsBinding.instance.addPostFrameCallback((_) {
      selectedDefaultFlu(rootItem);
    });
    //
    return rootItem.children.isEmpty
        ? const SizedBox(
            child: Center(
              child: Text(
                "No Shelf",
                style: TextStyle(
                  fontSize: 13,
                ),
              ),
            ),
          )
        : _CustomAppContainer.transparent(
            child: InteractiveViewer(
              panAxis: PanAxis.horizontal,
              constrained: false,
              boundaryMargin: boundaryMargin,
              minScale: 1,
              maxScale: 1,
              child: GraphView(
                graph: graph,
                algorithm: BuchheimWalkerAlgorithm(
                  config,
                  TreeEdgeRenderer(config),
                ),
                paint: Paint()
                  ..color = Colors.green
                  ..strokeWidth = 1
                  ..style = PaintingStyle.stroke,
                builder: (Node node) {
                  var id = node.key!.value as String?;
                  _GraphGItem item = graphItemMap[id!]!;
                  return rectangleWidget(item);
                },
              ),
            ),
          );
  }

  Widget _buildTopRightButtons() {
    return Row(
      children: [
        _FloatingButton(
          selected: nliTypes.contains(NliType.listener),
          tooltip: 'Show/Hide Listener Shelves',
          onPressed: () {
            var type = NliType.listener;
            setState(() {
              if (nliTypes.contains(type)) {
                nliTypes.remove(type);
              } else {
                nliTypes.add(type);
              }
            });
          },
          iconData: _listenerIconData,
        ),
        const SizedBox(width: 10),
        _FloatingButton(
          selected: nliTypes.contains(NliType.notifier),
          tooltip: 'Show/Hide Notifier Shelves',
          onPressed: () {
            var type = NliType.notifier;
            setState(() {
              if (nliTypes.contains(type)) {
                nliTypes.remove(type);
              } else {
                nliTypes.add(type);
              }
            });
          },
          iconData: _eventSourceIconData,
        ),
        const SizedBox(width: 10),
        _FloatingButton(
          selected: nliTypes.contains(NliType.independent),
          tooltip: 'Show/Hide Independent Shelves',
          onPressed: () {
            var type = NliType.independent;
            setState(() {
              if (nliTypes.contains(type)) {
                nliTypes.remove(type);
              } else {
                nliTypes.add(type);
              }
            });
          },
          iconData: _independentIconData,
        ),
      ],
    );
  }

  _GraphGItem _createRootItemAndChildren() {
    _GraphGItem root = _GraphGItem(
      isRoot: true,
      isNotifier: false,
      isListener: false,
      shelfName: "Global Flu",
    );
    Map<String, Shelf?> shelfMap = FlutterArtist.storage.shelfMap;
    Map<String, Shelf?> shelfListenerMap =
        FlutterArtist.storage._getListenerShelves();
    Map<String, Shelf?> shelfNotifierMap =
        FlutterArtist.storage._getEventShelves();
    Map<String, Shelf?> shelfIndependentMap =
        FlutterArtist.storage._getIndependentShelves();

    for (String shelfName in shelfMap.keys) {
      _GraphGItem item = _GraphGItem(
        isRoot: false,
        isNotifier: shelfNotifierMap.containsKey(shelfName),
        isListener: shelfListenerMap.containsKey(shelfName),
        shelfName: shelfName,
        shelf: shelfMap[shelfName],
      );
      if (nliTypes.contains(NliType.notifier) &&
          shelfNotifierMap.containsKey(shelfName)) {
        root.children.add(item);
      } else if (nliTypes.contains(NliType.listener) &&
          shelfListenerMap.containsKey(shelfName)) {
        root.children.add(item);
      } else if (nliTypes.contains(NliType.independent) &&
          shelfIndependentMap.containsKey(shelfName)) {
        root.children.add(item);
      }
    }
    return root;
  }

  void _addToMapCascade({
    required Graph graph,
    required Node currentNode,
    required List<_GraphGItem> childItems,
    required Map<String, _GraphGItem> graphItemMap,
    required Map<String, Node> nodeMap,
  }) {
    for (var childGraphItem in childItems) {
      String childNodeId = childGraphItem.shelfName;
      graphItemMap[childNodeId] = childGraphItem;
      Node childNode = Node.Id(childNodeId);
      nodeMap[childNodeId] = childNode;

      graph.addEdge(
        currentNode,
        childNode,
        paint: Paint()..color = Colors.black87,
      );

      if (childGraphItem.children.isNotEmpty) {
        _addToMapCascade(
          graph: graph,
          currentNode: childNode,
          childItems: childGraphItem.children,
          graphItemMap: graphItemMap,
          nodeMap: nodeMap,
        );
      }
    }
  }

  Widget rectangleWidget(_GraphGItem item) {
    if (item.isRoot) {
      return const SizedBox(width: 10, height: 10);
    } else {
      return _GraphItemSimpleShelfBox(
        isRoot: item.isRoot,
        isSelected: item.shelfName == selectedShelfName,
        isListener: item.isListener,
        isEventSource: item.isNotifier,
        shelfName: item.shelfName,
        shelf: item.shelf,
        onSelectFluToShowGraph: item.isRoot
            ? null
            : () {
                _onSelectFluToShowGraph(item);
              },
        onSelectFluToShowTreeView: () {
          _onSelectFluToShowTreeView(item);
        },
      );
    }
  }

  void _onSelectFluToShowGraph(_GraphGItem item) {
    Shelf? shelf = item.shelf;
    shelf ??= FlutterArtist.storage._createShelf(item.shelfName);
    widget.onSelectShelfToShowGraph(shelf);
  }

  void _onSelectFluToShowTreeView(_GraphGItem item) {
    setState(() {
      selectedShelfName = item.shelfName;
      Shelf? shelf = item.shelf;
      shelf ??= FlutterArtist.storage._createShelf(item.shelfName);
      widget.onSelectShelfToShowTreeView(shelf);
    });
  }

  @override
  void dispose() {
    super.dispose();
  }
}
