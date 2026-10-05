import 'package:flutter/material.dart';
import 'package:graphview/GraphView.dart';

import '../../../core/_core_/core.dart';
import '../../../core/icon/icon_constants.dart';
import '../../../core/utils/__utils.dart';

import '../../../core/utils/__utils.dart';

import '../../../core/widgets/_custom_app_container.dart';
import '../../constants/_debug_constants.dart';
import '../_graph_configuration.dart';
import '_graph_item_prozess_box.dart';
import '_graph_item_task_box.dart';

/// A widget that visualizes the Activity execution structure using GraphView,
/// mapping Activities, Prozesses, and their corresponding child Stages.
class ActivityStructureGraphView extends StatefulWidget {
  /// Callback triggered when the back/storage button is pressed.
  final Function()? onPressedBack;

  /// The target Activity to inspect.
  final Activity activity;

  /// Creates an instance of [ActivityStructureGraphView].
  const ActivityStructureGraphView({
    required this.activity,
    required this.onPressedBack,
    super.key,
  });

  @override
  State<ActivityStructureGraphView> createState() =>
      _ActivityStructureGraphViewState();
}

class _ActivityStructureGraphViewState
    extends State<ActivityStructureGraphView> {
  /// Graph data structure for nodes and edges layout.
  final Graph _graph = Graph()..isTree = false;

  /// Tree layout configuration compatible with BuchheimWalker algorithm.
  final BuchheimWalkerConfiguration _configuration =
      CustomBuchheimWalkerConfiguration();

  static const double paddingVertical = 60;
  static const double paddingHorizontal = 640;

  @override
  void initState() {
    super.initState();
    _buildGraphNodes();
    _configureGraphLayout();
  }

  /// Sets up graph nodes and hierarchical edges based on the Activity structure.
  void _buildGraphNodes() {
    // Root node representing the Activity
    final activityNode = Node.Id(widget.activity);

    // Build connections from Activity to its Prozesses
    for (var prozess in widget.activity.prozesses) {
      final prozessNode = Node.Id(prozess);
      _graph.addEdge(
        activityNode,
        prozessNode,
        paint: Paint()..color = Colors.black87,
      );
    }

    // Build connections from Activity to its Tasks (fixes the crash when prozess is empty but task exists)
    for (var task in widget.activity.tasks) {
      final taskNode = Node.Id(task);
      _graph.addEdge(
        activityNode,
        taskNode,
        paint: Paint()..color = Colors.black87,
      );
    }
  }

  /// Configures algorithm layout parameters for the graph view.
  void _configureGraphLayout() {
    _configuration
      ..orientation = BuchheimWalkerConfiguration.ORIENTATION_TOP_BOTTOM
      ..siblingSeparation = 40
      ..levelSeparation = 40;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _buildGraphLayer(context),
      ],
    );
  }

  /// Builds the interactive graph layer holding the [GraphView].
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
            graph: _graph,
            algorithm: BuchheimWalkerAlgorithm(
              _configuration,
              TreeEdgeRenderer(_configuration),
            ),
            paint: Paint()
              ..color = Colors.green
              ..strokeWidth = 1
              ..style = PaintingStyle.stroke,
            builder: (Node node) {
              var entity = node.key!.value;
              return _rectangleWidget(entity);
            },
          ),
        ),
      ),
    );
  }

  /// Renders individual node widgets depending on their underlying data type.
  Widget _rectangleWidget(dynamic entity) {
    return InkWell(
      onTap: () {
        // Handle node selection if needed
      },
      child: entity is Activity
          ? _buildActivityBox(entity)
          : entity is Prozess
              ? GraphItemProzessBox(prozess: entity)
              : entity is Task
                  ? GraphItemTaskBox(task: entity)
                  : const SizedBox.shrink(),
    );
  }

  /// Builds the visual box representation for the root Activity node.
  Widget _buildActivityBox(Activity activity) {
    return TooltipUtils.buildTooltip(
      message: getClassName(activity),
      child: Container(
        width: 260,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: DebugConstants.rootGraphBoxBgColor(context),
          borderRadius: BorderRadius.circular(4),
          boxShadow: [
            DebugConstants.graphBoxShadow(context),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(
              FaIconConstants.activityIconData,
              size: 32,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: Text(
                  getClassName(activity),
                  style: TextStyle(
                    fontSize: DebugConstants.graphBoxFontSizeRootBox,
                    fontWeight: FontWeight.bold,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ),
            if (widget.onPressedBack != null)
              TextButton(
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 5,
                  ),
                  minimumSize: Size.zero,
                ),
                onPressed: widget.onPressedBack,
                child: const Icon(
                  FaIconConstants.uptoStorageIconData,
                  color: Colors.white,
                  size: 18,
                ),
              ),
          ],
        ),
      ),
    );
  }

  /// Builds the visual box representation for a Task node.
  Widget _buildTaskBox(Task task) {
    return TooltipUtils.buildTooltip(
      message: task.name,
      child: Container(
        width: 240,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: DebugConstants.activeGraphBoxBgColor(context),
          borderRadius: BorderRadius.circular(4),
          boxShadow: [
            DebugConstants.graphBoxShadow(context),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(
              FaIconConstants.taskIconData,
              size: 24,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                task.name,
                style: TextStyle(
                  fontSize: DebugConstants.graphBoxFontSizeChildBox,
                  fontWeight: FontWeight.bold,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds the visual box representation for a Prozess node,
  /// cleanly embedding its child Stages inside the container card.
  Widget _buildProzessBox(Prozess prozess) {
    return TooltipUtils.buildTooltip(
      message: prozess.name,
      child: Container(
        width: 240,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: DebugConstants.activeGraphBoxBgColor(context),
          borderRadius: BorderRadius.circular(4),
          boxShadow: [
            DebugConstants.graphBoxShadow(context),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Prozess Header row
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(
                  Icons.account_tree_outlined,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    prozess.name,
                    style: TextStyle(
                      fontSize: DebugConstants.graphBoxFontSizeChildBox,
                      fontWeight: FontWeight.bold,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ),
            const Divider(height: 10),

            // Displaying list of child Stages inside the Prozess node container
            if (prozess.stages.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Text(
                  "No stages available",
                  style: TextStyle(
                    fontSize: 11,
                    fontStyle: FontStyle.italic,
                    color: Colors.grey.shade600,
                  ),
                ),
              )
            else
              ...prozess.stages.map(
                (stage) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.subdirectory_arrow_right,
                        size: 12,
                        color: Colors.teal,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          stage.name,
                          style: TextStyle(
                            fontSize: 11.5,
                            color: DebugConstants.graphBoxTextColor(context),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
