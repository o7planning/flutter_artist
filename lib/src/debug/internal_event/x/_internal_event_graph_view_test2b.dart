import 'dart:math';

import 'package:flutter/material.dart';
import 'package:graphview/GraphView.dart';

class InternalEventGraphViewTest2b extends StatefulWidget {
  @override
  State<InternalEventGraphViewTest2b> createState() =>
      _InternalEventGraphViewTest2bState();
}

class _InternalEventGraphViewTest2bState
    extends State<InternalEventGraphViewTest2b> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Wrap(
              children: [
                Container(
                  width: 100,
                  child: TextFormField(
                    initialValue: builder.nodeSeparation.toString(),
                    decoration: InputDecoration(labelText: 'Node Separation'),
                    onChanged: (text) {
                      builder.nodeSeparation = int.tryParse(text) ?? 100;
                      this.setState(() {});
                    },
                  ),
                ),
                Container(
                  width: 100,
                  child: TextFormField(
                    initialValue: builder.levelSeparation.toString(),
                    decoration: InputDecoration(labelText: 'Level Separation'),
                    onChanged: (text) {
                      builder.levelSeparation = int.tryParse(text) ?? 100;
                      this.setState(() {});
                    },
                  ),
                ),
                Container(
                  width: 100,
                  child: TextFormField(
                    initialValue: builder.orientation.toString(),
                    decoration: InputDecoration(labelText: 'Orientation'),
                    onChanged: (text) {
                      builder.orientation = int.tryParse(text) ?? 100;
                      this.setState(() {});
                    },
                  ),
                ),
                Container(
                  width: 100,
                  child: Column(
                    children: [
                      Text('Alignment'),
                      DropdownButton<CoordinateAssignment>(
                        value: builder.coordinateAssignment,
                        items: CoordinateAssignment.values
                            .map((coordinateAssignment) {
                          return DropdownMenuItem<CoordinateAssignment>(
                            value: coordinateAssignment,
                            child: Text(coordinateAssignment.name),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            builder.coordinateAssignment = value!;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    final node12 = Node.Id(r.nextInt(100));
                    var edge =
                        graph.getNodeAtPosition(r.nextInt(graph.nodeCount()));
                    print(edge);
                    graph.addEdge(edge, node12);
                    setState(() {});
                  },
                  child: Text('Add'),
                )
              ],
            ),
            Expanded(
              child: InteractiveViewer(
                  constrained: false,
                  boundaryMargin: EdgeInsets.all(100),
                  minScale: 0.0001,
                  maxScale: 10.6,
                  child: GraphView(
                    graph: graph,
                    algorithm: SugiyamaAlgorithm(builder),
                    paint: Paint()
                      ..color = Colors.green
                      ..strokeWidth = 1
                      ..style = PaintingStyle.stroke,
                    builder: (Node node) {
                      // I can decide what widget should be shown here based on the id
                      var a = node.key!.value as int?;
                      return rectangleWidget(a);
                    },
                  )),
            ),
          ],
        ));
  }

  Random r = Random();

  Widget rectangleWidget(int? a) {
    return Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          boxShadow: [
            BoxShadow(color: Colors.blue[100]!, spreadRadius: 1),
          ],
        ),
        child: Text('Node ${a}'));
  }

  final Graph graph = Graph();

  SugiyamaConfiguration builder = SugiyamaConfiguration()
    ..bendPointShape = CurvedBendPointShape(curveLength: 20)
    ..coordinateAssignment = CoordinateAssignment.DownRight;

  @override
  void initState() {
    super.initState();
    final node0 = Node.Id(0);

    final node1 = Node.Id(1);
    final node2 = Node.Id(2);
    final node3 = Node.Id(3);
    final node4 = Node.Id(4);
    final node5 = Node.Id(5);
    final node6 = Node.Id(6);

    graph.addNode(node0);

    Edge edge1 = graph.addEdge(node1, node3,
        paint: Paint()
          ..color = Colors.red
          ..strokeWidth = 3);

    graph.addEdge(node1, node3,
        paint: Paint()
          ..color = Colors.black
          ..strokeWidth = 4);

    graph.addEdge(node1, node4);
    graph.addEdge(node1, node3);
    graph.addEdge(node3, node1,
        paint: Paint()
          ..color = Colors.red
          ..strokeJoin = StrokeJoin.miter);
    graph.addEdge(node2, node3);
    graph.addEdge(node3, node4);
    graph.addEdge(node4, node3);

    graph.addEdge(node3, node5);
    graph.addEdge(node4, node6);

    builder
      ..nodeSeparation = (100)
      ..levelSeparation = (30)
      ..orientation = SugiyamaConfiguration.ORIENTATION_TOP_BOTTOM;
  }
}
