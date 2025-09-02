import 'package:flutter/material.dart';
import 'package:flutter_artist/flutter_artist.dart';

import '../__root_debug_view.dart';

class ShelfDebugStateView extends StatelessWidget {
  final RootDebugController controller;
  final Shelf shelf;

  final bool showTitle;

  const ShelfDebugStateView({
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
    final Widget w = BlockDebugStateView(
      block: block,
      vertical: vertical,
      blockDebugOptions: BlockDebugOptions(),
      formDebugOptions: FormDebugOptions(),
      paginationDebugOptions: PaginationDebugOptions(),
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
    final Widget w = ScalarDebugStateView(
      scalar: scalar,
      vertical: vertical,
      scalarDebugOptions: ScalarDebugOptions(),
    );
    return SizedBox(
      width: fixedWidth,
      child: w,
    );
  }
}
