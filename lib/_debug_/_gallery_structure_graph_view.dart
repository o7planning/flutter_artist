part of '../flutter_artist.dart';

class _GalleryStructureGraphView extends StatefulWidget {
  final _GalleryStructureGraphController controller;
  final Function(Frame frame) onSelectFrameToShowGraph;
  final Function(Frame frame) onSelectFrameToShowTreeView;

  const _GalleryStructureGraphView({
    required this.controller,
    required this.onSelectFrameToShowGraph,
    required this.onSelectFrameToShowTreeView,
  });

  @override
  State<_GalleryStructureGraphView> createState() =>
      _GalleryStructureGraphViewState();
}

class _GalleryStructureGraphViewState
    extends State<_GalleryStructureGraphView> {
  final Set<NliType> nliTypes = {
    NliType.independent,
    NliType.listener,
    NliType.notifier,
  };

  String? selectedFluName;

  final BuchheimWalkerConfiguration config =
      GalerryBuchheimWalkerConfiguration();

  final EdgeInsets boundaryMargin = const EdgeInsets.only(left: 20, right: 20);

  @override
  void initState() {
    super.initState();
    widget.controller._setSelectedFrame = (Frame frame) {
      setState(() {
        selectedFluName = FlutterArtist._getFrameName(frame.runtimeType);
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
      if (item.frameName == selectedFluName) {
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
    final String rootNodeId = rootItem.frameName;
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
                "No Flu",
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
          tooltip: 'Show/Hide Listener Flu(s)',
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
          tooltip: 'Show/Hide Notifier Flu(s)',
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
          iconData: _changeSourceIconData,
        ),
        const SizedBox(width: 10),
        _FloatingButton(
          selected: nliTypes.contains(NliType.independent),
          tooltip: 'Show/Hide Independent Flu(s)',
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
      frameName: "Global Flu",
    );
    Map<String, Frame?> frameMap = FlutterArtist.frameMap;
    Map<String, Frame?> frameListenerMap = FlutterArtist._getListenerFrames();
    Map<String, Frame?> frameNotifierMap = FlutterArtist._getNotifierFrames();
    Map<String, Frame?> frameIndependentMap =
        FlutterArtist._getIndependentFrames();

    for (String frameName in frameMap.keys) {
      _GraphGItem item = _GraphGItem(
        isRoot: false,
        isNotifier: frameNotifierMap.containsKey(frameName),
        isListener: frameListenerMap.containsKey(frameName),
        frameName: frameName,
        frame: frameMap[frameName],
      );
      if (nliTypes.contains(NliType.notifier) &&
          frameNotifierMap.containsKey(frameName)) {
        root.children.add(item);
      } else if (nliTypes.contains(NliType.listener) &&
          frameListenerMap.containsKey(frameName)) {
        root.children.add(item);
      } else if (nliTypes.contains(NliType.independent) &&
          frameIndependentMap.containsKey(frameName)) {
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
      String childNodeId = childGraphItem.frameName;
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
      return _GraphItemSimpleFrameBox(
        isRoot: item.isRoot,
        isSelected: item.frameName == selectedFluName,
        isListener: item.isListener,
        isNotifier: item.isNotifier,
        frameName: item.frameName,
        frame: item.frame,
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
    Frame? frame = item.frame;
    frame ??= FlutterArtist._createFrame(item.frameName);
    widget.onSelectFrameToShowGraph(frame);
  }

  void _onSelectFluToShowTreeView(_GraphGItem item) {
    setState(() {
      selectedFluName = item.frameName;
      Frame? frame = item.frame;
      frame ??= FlutterArtist._createFrame(item.frameName);
      widget.onSelectFrameToShowTreeView(frame);
    });
  }

  @override
  void dispose() {
    super.dispose();
  }
}
