import 'package:flutter/material.dart';
import 'package:flutter_artist/src/debug/state_view/widgets/_route_stack_debug_box.dart';
import 'package:flutter_artist_router/flutter_artist_router.dart';

import '../../core/_core_/core.dart';
import '../../core/widgets/_table_container.dart';
import 'options/_debug_block_options.dart';
import 'options/_debug_filter_options.dart';
import 'options/_debug_form_options.dart';
import 'options/_debug_pagination_options.dart';
import 'widgets/_block_debug_box.dart';
import 'widgets/_filter_debug_box.dart';
import 'widgets/_form_debug_box.dart';
import 'widgets/_pagination_debug_box.dart';

class DebugRouteStackStateView extends StatelessWidget {
  final bool showTitle;

  const DebugRouteStackStateView({
    super.key,
    this.showTitle = true,
  });

  @override
  Widget build(BuildContext context) {
    return StorageSectionViewBuilder(
      ownerClassInstance: this,
      description: null,
      build: () {
        final theme = Theme.of(context);
        final colorScheme = theme.colorScheme;
        List<RouteKey> stack = context.faRouter.stack;
        //
        return Container(
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: colorScheme.primary.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(4),
            border: Border.all(
              color: theme.dividerColor.withValues(alpha: 0.2),
              width: 0.5,
            ),
          ),
          child: RouteStackDebugBox(stack: stack),
        );
      },
    );
  }
}
