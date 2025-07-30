import 'package:flutter/material.dart';
import 'package:graphview/GraphView.dart';

import '../../core/_core_/core.dart';
import '../../core/enums/_nli_type.dart';
import '../../core/icon/icon_constants.dart';
import '../../core/widgets/_custom_app_container.dart';
import '../../core/widgets/_floating_button.dart';
import '../constants/_debug_constants.dart';
import '_shelf_structure_view_config.dart';
import 'widgets/_graph_item.dart';
import 'widgets/_graph_item_simple_shelf_box.dart';

class StorageStructureGraphView extends StatefulWidget {
  final StorageStructureGraphController controller;
  final Function(Shelf shelf) onSelectShelfToShowGraph;
  final Function(Shelf shelf) onSelectShelfToShowTreeView;

  const StorageStructureGraphView({
    super.key,
    required this.controller,
    required this.onSelectShelfToShowGraph,
    required this.onSelectShelfToShowTreeView,
  });

  @override
  State<StorageStructureGraphView> createState() =>
      _StorageStructureGraphViewState();
}

class _StorageStructureGraphViewState extends State<StorageStructureGraphView> {
  final Set<NliType> nliTypes = {
    NliType.independent,
    NliType.listener,
    NliType.eventSource,
  };

  String? selectedShelfName;

  final BuchheimWalkerConfiguration config =
      GalerryBuchheimWalkerConfiguration();

  final EdgeInsets boundaryMargin = const EdgeInsets.only(left: 20, right: 20);

  @override
  void initState() {
    super.initState();
    widget.controller._setSelectedShelf = (Shelf shelf) {
      setState(() {
        selectedShelfName = FlutterArtist.storage.debugGetShelfName(
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

  void selectedDefaultFlu(GraphGItem rootItem) {
    bool found = false;
    for (GraphGItem item in rootItem.children) {
      if (item.shelfName == selectedShelfName) {
        found = true;
        break;
      }
    }
    if (!found) {
      GraphGItem? item =
          rootItem.children.isEmpty ? null : rootItem.children[0];
      if (item != null) {
        _onSelectFluToShowTreeView(item);
      }
    }
  }

  Widget _buildMain() {
    final Graph graph = Graph()..isTree = false;
    GraphGItem rootItem = _createRootItemAndChildren();
    Map<String, GraphGItem> graphItemMap = <String, GraphGItem>{};
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
        : CustomAppContainer.transparent(
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
                  GraphGItem item = graphItemMap[id!]!;
                  return rectangleWidget(item);
                },
              ),
            ),
          );
  }

  Widget _buildTopRightButtons() {
    return Row(
      children: [
        FloatingButton(
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
          iconData: FaIconConstants.listenerIconData,
          iconColor: DebugConstants.listenerIconColor,
        ),
        const SizedBox(width: 10),
        FloatingButton(
          selected: nliTypes.contains(NliType.eventSource),
          tooltip: 'Show/Hide Event Shelves',
          onPressed: () {
            var type = NliType.eventSource;
            setState(() {
              if (nliTypes.contains(type)) {
                nliTypes.remove(type);
              } else {
                nliTypes.add(type);
              }
            });
          },
          iconData: FaIconConstants.eventSourceIconData,
          iconColor: DebugConstants.eventSourceIconColor,
        ),
        const SizedBox(width: 10),
        FloatingButton(
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
          iconData: FaIconConstants.independentIconData,
          iconColor: DebugConstants.nonEventOrListenerIconColor,
        ),
      ],
    );
  }

  GraphGItem _createRootItemAndChildren() {
    GraphGItem root = GraphGItem(
      isRoot: true,
      isNotifier: false,
      isListener: false,
      shelfName: "Storage",
    );
    final bool external = true;
    //
    Map<String, Shelf?> shelfMap = FlutterArtist.storage.shelfMap;
    Map<String, Shelf?> shelfListenerMap =
        FlutterArtist.storage.debugGetListenerShelves();
    Map<String, Shelf?> shelfNotifierMap =
        FlutterArtist.storage.debugGetEventShelves(external: external);
    Map<String, Shelf?> shelfIndependentMap =
        FlutterArtist.storage.debugGetIndependentShelves(external: external);

    for (String shelfName in shelfMap.keys) {
      GraphGItem item = GraphGItem(
        isRoot: false,
        isNotifier: shelfNotifierMap.containsKey(shelfName),
        isListener: shelfListenerMap.containsKey(shelfName),
        shelfName: shelfName,
        shelf: shelfMap[shelfName],
      );
      if (nliTypes.contains(NliType.eventSource) &&
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
    required List<GraphGItem> childItems,
    required Map<String, GraphGItem> graphItemMap,
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

  Widget rectangleWidget(GraphGItem item) {
    if (item.isRoot) {
      return const SizedBox(width: 10, height: 10);
    } else {
      return GraphItemSimpleShelfBox(
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

  void _onSelectFluToShowGraph(GraphGItem item) {
    Shelf? shelf = item.shelf;
    shelf ??= FlutterArtist.storage.debugCreateShelf(item.shelfName);
    widget.onSelectShelfToShowGraph(shelf);
  }

  void _onSelectFluToShowTreeView(GraphGItem item) {
    setState(() {
      selectedShelfName = item.shelfName;
      Shelf? shelf = item.shelf;
      shelf ??= FlutterArtist.storage.debugCreateShelf(item.shelfName);
      widget.onSelectShelfToShowTreeView(shelf);
    });
  }

  @override
  void dispose() {
    super.dispose();
  }
}

class StorageStructureGraphController {
  Function(Shelf shelf)? _setSelectedShelf;

  void setSelectedShelf(Shelf shelf) {
    if (_setSelectedShelf != null) {
      _setSelectedShelf!(shelf);
    }
  }
}
