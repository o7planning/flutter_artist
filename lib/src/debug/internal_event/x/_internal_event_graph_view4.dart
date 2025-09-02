// Copyright (c) 2023- All flutter_graph_view authors. All rights reserved.
//
// This source code is licensed under Apache 2.0 License.

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_graph_view/flutter_graph_view.dart' hide Block;

import '../../../core/_core_/core.dart';

class InternalEventGraphView4 extends StatelessWidget {
  final Shelf shelf;
  const InternalEventGraphView4({
    super.key,
    required this.shelf,
  });

  @override
  Widget build(BuildContext context) {
    var vertexes = <Map>{};
    var r = Random();
    for (Block block in shelf.blocks) {
      vertexes.add(
        {
          'id':  block.name ,
          'tag': block.name ,
          'tags': [
             block.name ,
          ],
        },
      );
    }
    var edges = <Map>{};
    for (Block block in shelf.leafBlocks) {
      var b = block;
      while (true) {
        Block? p = b.parent;
        if (p != null) {
          edges.add({
            'srcId':  p.name ,
            'dstId':   b.name ,
            'edgeName': 'edge-${p.name}-@-${b.name}',
            'ranking': DateTime.now().millisecond,
          });
          edges.add({
            'srcId':  p.name ,
            'dstId':   b.name ,
            'edgeName': 'edge-${p.name}-@-${b.name}',
            'ranking': DateTime.now().millisecond,
          });
          b = p;
        } else {
          break;
        }
      }
    }

    var data = {
      'vertexes': vertexes,
      'edges': edges,
    };
    return FlutterGraphWidget(
      data: data,
      algorithm: RandomAlgorithm(
        decorators: [
          CoulombDecorator(),
          // HookeBorderDecorator(),
          HookeDecorator(),
          CoulombCenterDecorator(),
          HookeCenterDecorator(),
          ForceDecorator(),
          ForceMotionDecorator(),
          TimeCounterDecorator(),
        ],
      ),
      convertor: MapConvertor(),
      options: Options()
        ..enableHit = false
        ..panelDelay = const Duration(milliseconds: 500)
        ..graphStyle = (GraphStyle()
          // tagColor is prior to tagColorByIndex. use vertex.tags to get color
          ..tagColor = {'tag8': Colors.orangeAccent.shade200}
          ..tagColorByIndex = [
            Colors.red.shade200,
            Colors.orange.shade200,
            Colors.yellow.shade200,
            Colors.green.shade200,
            Colors.blue.shade200,
            Colors.blueAccent.shade200,
            Colors.purple.shade200,
            Colors.pink.shade200,
            Colors.blueGrey.shade200,
            Colors.deepOrange.shade200,
          ])
        ..useLegend = true // default true
        ..edgePanelBuilder = edgePanelBuilder
        ..vertexPanelBuilder = vertexPanelBuilder
        ..edgeShape = EdgeLineShape() // default is EdgeLineShape.
        ..vertexShape = VertexCircleShape(), // default is VertexCircleShape.
    );
  }

  Widget edgePanelBuilder(Edge edge, Viewfinder viewfinder) {
    var c = viewfinder.localToGlobal(edge.position);

    return Stack(
      children: [
        Positioned(
          left: c.x + 5,
          top: c.y,
          child: SizedBox(
            width: 200,
            child: ColoredBox(
              color: Colors.grey.shade900.withAlpha(200),
              child: ListTile(
                title: Text(
                    '${edge.edgeName} @${edge.ranking}\nDelay controlled by \noptions.panelDelay\ndefault to 300ms'),
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget vertexPanelBuilder(hoverVertex, Viewfinder viewfinder) {
    var c = viewfinder.localToGlobal(hoverVertex.cpn!.position);
    return Stack(
      children: [
        Positioned(
          left: c.x + hoverVertex.radius + 15,
          top: c.y - 20,
          child: SizedBox(
            width: 160,
            child: ColoredBox(
              color: Colors.grey.shade900.withAlpha(200),
              child: ListTile(
                title: Text(
                  'Id: ${hoverVertex.id}',
                ),
                subtitle: Text(
                    'Tag: ${hoverVertex.data['tag']}\nDegree: ${hoverVertex.degree} ${hoverVertex.prevVertex?.id}'),
              ),
            ),
          ),
        )
      ],
    );
  }
}
