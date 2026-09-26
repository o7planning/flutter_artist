import 'package:flutter/material.dart';

import '../../core/_core_/core.dart';
import '../../core/widgets/_table_container.dart';
import 'options/_debug_block_options.dart';
import 'options/_debug_filter_options.dart';
import 'options/_debug_form_options.dart';
import 'options/_debug_pagination_options.dart';
import 'widgets/block_debug_box.dart';
import 'widgets/filter_debug_box.dart';
import 'widgets/form_debug_box.dart';
import 'widgets/pagination_debug_box.dart';

abstract class DebugBaseStateView extends StatelessWidget {
  const DebugBaseStateView({super.key});

  Widget buildWithColumn(List<Widget> children) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children.length <= 1
          ? children
          : (children
              .expand(
                (w) => [w, SizedBox(height: 5)],
              )
              .toList()
            ..removeLast()),
    );
  }

  Widget buildWithTableContainer(List<Widget> children) {
    return TableContainer(
      flexes: children.map((child) => 1.0).toList(),
      padding: EdgeInsets.zero,
      widgets: children,
    );
  }

  Widget buildWithColumnAndTableContainer(List<Widget> children) {
    assert(children.length == 3);
    //
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TableContainer(
          flexes: [1, 1],
          padding: EdgeInsets.zero,
          widgets: [children[0], children[1]],
        ),
        SizedBox(height: 5),
        children[2],
      ],
    );
  }
}
