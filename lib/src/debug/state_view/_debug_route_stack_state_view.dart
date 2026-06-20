import 'package:flutter/material.dart';
import 'package:flutter_artist_router/flutter_artist_router.dart';

import '../../core/_core_/core.dart';
import 'widgets/_route_stack_debug_box.dart';

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
