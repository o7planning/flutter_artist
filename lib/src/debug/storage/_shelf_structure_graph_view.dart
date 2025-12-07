import 'package:flutter/material.dart';
import 'package:flutter_artist_commons_ui/flutter_artist_commons_ui.dart';
import 'package:graphview/GraphView.dart';

import '../../core/_core_/core.dart';
import '../../core/utils/_tooltip_utils.dart';
import '../../core/widgets/_custom_app_container.dart';
import '_graph_debug_utils.dart';
import '_graph_item_block_or_scalar_box.dart';
import '_graph_item_shelf_box.dart';
import '_shelf_structure_view_config.dart';
import 'widgets/_graph_item.dart';

class ShelfStructureGraphView extends StatefulWidget {
  final Function() onPressedBack;
  final Shelf shelf;

  const ShelfStructureGraphView({
    required this.shelf,
    required this.onPressedBack,
    super.key,
  });

  @override
  State<ShelfStructureGraphView> createState() =>
      _ShelfStructureGraphViewState();
}

class _ShelfStructureGraphViewState extends State<ShelfStructureGraphView> {
  final Graph graph = Graph()..isTree = false;
  BuchheimWalkerConfiguration configuration =
      CustomBuchheimWalkerConfiguration();
  late Map<String, GraphItem> graphItemMap;

  String? _highlighFilterModelName;

  static const double paddingVertical = 60;
  static const double paddingHorizontal = 640;

  static const double itemWidth = 280;
  static const double? itemHeight = null; // 160;

  late GraphItem rootItem;

  bool _showClassParameters = false;

  @override
  void initState() {
    super.initState();
    //
    rootItem = GraphDebugUtils.toRootDebugGraphItem(widget.shelf);
    graphItemMap = <String, GraphItem>{};
    final String rootNodeId = rootItem.name;
    //
    graphItemMap[rootNodeId] = rootItem;
    //
    Map<String, Node> nodeMap = {};
    //

    final rootNode = Node.Id(rootNodeId);
    nodeMap[rootNodeId] = rootNode;
    //
    _addToMapCascade(
      currentNode: rootNode,
      childItems: rootItem.children,
      graphItemMap: graphItemMap,
      nodeMap: nodeMap,
    );
  }

  void _addToMapCascade({
    required Node currentNode,
    required List<GraphItem> childItems,
    required Map<String, GraphItem> graphItemMap,
    required Map<String, Node> nodeMap,
  }) {
    for (var childGraphItem in childItems) {
      String childNodeId = childGraphItem.name;
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
          currentNode: childNode,
          childItems: childGraphItem.children,
          graphItemMap: graphItemMap,
          nodeMap: nodeMap,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _buildGraphLayer(context),
        Positioned(
          top: 5,
          right: 5,
          child: _buildFloatingButtonLayer(context),
        ),
      ],
    );
  }

  Widget _buildFloatingButtonLayer(BuildContext context) {
    return TooltipUtils.buildTooltip(
      child: SimpleSmallIconButton(
        onPressed: () {
          _showClassParameters = !_showClassParameters;
          setState(() {});
        },
        iconData: Icons.more_outlined,
      ),
      message: 'Show/Hide Class Parameters Definition',
    );
  }

  Widget _buildGraphLayer(BuildContext context) {
    return SizedBox(
      height: 600,
      child: CustomAppContainer.transparent(
        child: InteractiveViewer(
          constrained: false,
          boundaryMargin: const EdgeInsets.symmetric(
            horizontal: paddingHorizontal,
            vertical: paddingVertical,
          ),
          minScale: 1,
          maxScale: 1,
          child: GraphView(
            graph: graph,
            algorithm: BuchheimWalkerAlgorithm(
              configuration,
              TreeEdgeRenderer(configuration),
            ),
            paint: Paint()
              ..color = Colors.green
              ..strokeWidth = 1
              ..style = PaintingStyle.stroke,
            builder: (Node node) {
              var a = node.key!.value as String?;
              return rectangleWidget(a);
            },
          ),
        ),
      ),
    );
  }

  Widget rectangleWidget(String? id) {
    GraphItem item = graphItemMap[id!]!;
    return InkWell(
      onTap: () {
        // print('clicked');
      },
      child: item.shelf != null
          ? GraphItemShelfBox(
              shelf: item.shelf!,
              gotoStorage: widget.onPressedBack,
            )
          : GraphItemBlockOrScalarBox(
              key: Key("Blk-${item.blockOrScalar!.name}"),
              blockOrScalar: item.blockOrScalar!,
              highlightFilterModelName: _highlighFilterModelName,
              showClassParameters: _showClassParameters,
              refreshGraph: (String? filterName) {
                _highlighFilterModelName = filterName;
                setState(() {});
              },
            ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
