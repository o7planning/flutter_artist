import 'package:flutter/material.dart';
import 'package:flutter_artist_router/flutter_artist_router.dart';

class FARouteDebugger extends StatelessWidget {
  final List<FaRouteData> routes;

  const FARouteDebugger({super.key, required this.routes});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Icon(Icons.terminal_rounded,
                  color: colorScheme.tertiary, size: 20),
              const SizedBox(width: 8),
              Text(
                "REGISTERED ROUTES (${routes.length})",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                  letterSpacing: 1.1,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView(
            key: const PageStorageKey('fa_route_debugger_list'),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            children: routes.map((routeData) {
              return Container(
                margin: const EdgeInsets.only(bottom: 6),
                decoration: BoxDecoration(
                  color: colorScheme.surface.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: theme.dividerColor.withValues(alpha: 0.05),
                    width: 0.5,
                  ),
                ),
                child: Theme(
                  data: theme.copyWith(dividerColor: Colors.transparent),
                  child: ExpansionTile(
                    key: PageStorageKey('Expansion-${routeData.key.id}'),
                    visualDensity: VisualDensity.compact,
                    leading: Icon(
                      Icons.alt_route_rounded,
                      color: colorScheme.primary,
                      size: 20,
                    ),
                    title: Text(
                      routeData.route.path,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Courier',
                        color: colorScheme.onSurface,
                      ),
                    ),
                    subtitle: Text(
                      "${routeData.route.guards.length} guards active",
                      style: TextStyle(
                        fontSize: 11,
                        color: colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                    children: [
                      _buildGuardDetails(context, routeData.route.guards),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildGuardDetails(BuildContext context, List<dynamic> guards) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(48, 0, 16, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Divider(color: theme.dividerColor.withValues(alpha: 0.1), height: 1),
          const SizedBox(height: 8),
          if (guards.isEmpty)
            Text(
              "No guards assigned",
              style: TextStyle(
                fontStyle: FontStyle.italic,
                fontSize: 12,
                color: theme.hintColor.withValues(alpha: 0.5),
              ),
            )
          else
            ...guards.map((guard) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Row(
                    children: [
                      Icon(
                        Icons.shield_outlined,
                        size: 14,
                        color: colorScheme.primary.withValues(alpha: 0.7),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        guard.runtimeType.toString(),
                        style: TextStyle(
                          fontSize: 12,
                          fontFamily: 'Courier',
                          color: colorScheme.secondary,
                        ),
                      ),
                    ],
                  ),
                )),
        ],
      ),
    );
  }
}
