import 'package:flutter/material.dart';

import '../../core/_core_/core.dart';
import '../__root_debug_view.dart';
import '_debug_block_state_view.dart';
import '_debug_scalar_state_view.dart';
import 'options/_debug_block_options.dart';
import 'options/_debug_form_options.dart';
import 'options/_debug_pagination_options.dart';
import 'options/_debug_scalar_options.dart';

class DebugShelfStateView extends StatelessWidget {
  final RootDebugController controller;
  final Shelf shelf;

  final bool showTitle;

  const DebugShelfStateView({
    super.key,
    required this.controller,
    required this.shelf,
    this.showTitle = true,
  });

  @override
  Widget build(BuildContext context) {
    List<Block> allBlocks = shelf.blocks;
    List<Scalar> allScalars = shelf.scalars;

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return SingleChildScrollView(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Container(
              padding: EdgeInsets.all(5),
              width: constraints.constrainWidth(),
              child: _buildMainContent(
                allBlocks: allBlocks,
                allScalars: allScalars,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildMainContent({
    required List<Block> allBlocks,
    required List<Scalar> allScalars,
  }) {
    final double minColumnWidth = 240;
    final int columnCount = allBlocks.length + allScalars.length;
    if (columnCount == 0) {
      return SizedBox();
    }
    //
    if (columnCount == 1) {
      if (allBlocks.isNotEmpty) {
        return _buildBlockDebugStateView(
          block: allBlocks[0],
          vertical: false,
          fixedWidth: minColumnWidth,
        );
      } else {
        return _buildScalarDebugStateView(
          scalar: allScalars[0],
          vertical: false,
          fixedWidth: minColumnWidth,
        );
      }
    }
    // > 1
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: [
        ...allBlocks.map(
          (block) => _buildBlockDebugStateView(
            block: block,
            vertical: true,
            fixedWidth: minColumnWidth,
          ),
        ),
        ...allScalars.map(
          (scalar) => _buildScalarDebugStateView(
            scalar: scalar,
            vertical: true,
            fixedWidth: minColumnWidth,
          ),
        ),
      ].expand((w) => [w, SizedBox(width: 5)]).toList()
        ..removeLast(),
    );
  }

  Widget _buildBlockDebugStateView({
    required Block block,
    required bool vertical,
    required double fixedWidth,
  }) {
    final Widget w = DebugBlockStateView(
      block: block,
      vertical: vertical,
      debugBlockOptions: DebugBlockOptions(),
      debugFormOptions: DebugFormOptions(),
      debugPaginationOptions: DebugPaginationOptions(),
    );
    return SizedBox(
      width: fixedWidth,
      child: w,
    );
  }

  Widget _buildScalarDebugStateView({
    required Scalar scalar,
    required double fixedWidth,
    required bool vertical,
  }) {
    final Widget w = DebugScalarStateView(
      scalar: scalar,
      vertical: vertical,
      debugScalarOptions: DebugScalarOptions(),
    );
    return SizedBox(
      width: fixedWidth,
      child: w,
    );
  }
}
