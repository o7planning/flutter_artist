import 'package:flutter/material.dart';
import 'package:flutter_artist_commons_ui/flutter_artist_commons_ui.dart';
import 'package:flutter_artist_core/flutter_artist_core.dart';

import '../../core/_core_/core.dart';
import '../dialog/_error_viewer_dialog.dart';

class ExecutionTraceBox extends StatelessWidget {
  final ExecutionTrace executionTrace;
  final bool selected;
  final Function() onTap;

  const ExecutionTraceBox({
    required this.executionTrace,
    required this.selected,
    required this.onTap,
    required super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: selected
              ? theme.colorScheme.primary
              : theme.dividerColor.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      color: selected
          ? theme.colorScheme.primaryContainer.withValues(alpha: 0.4)
          : theme.colorScheme.surface.withValues(alpha: 0.1),
      child: _buildMainContent(context),
    );
  }

  Widget _buildMainContent(BuildContext context) {
    final theme = Theme.of(context);
    return ListTile(
      horizontalTitleGap: 8,
      dense: true,
      visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
      contentPadding: const EdgeInsets.fromLTRB(8, 0, 4, 0),
      leading: _buildLeading(context),
      trailing: Text(
        executionTrace.id.toString(),
        style: TextStyle(
          color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
          fontSize: 10,
          fontFamily: 'Courier',
          fontWeight: FontWeight.bold,
        ),
      ),
      title: _buildTitle(context),
      subtitle: _buildSubTitle(context),
      onTap: onTap,
    );
  }

  Widget _buildLeading(BuildContext context) {
    bool error = executionTrace.hasError();
    final theme = Theme.of(context);
    return Tooltip(
      message: executionTrace.executionTraceType.getTooltipText(),
      child: Icon(
        executionTrace.executionTraceType.getIconData(),
        color: executionTrace.executionTraceType.getIconColor(context, error),
        size: 20,
      ),
    );
  }

  TextStyle _titleStyle() {
    return TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.normal,
      color: Colors.black,
      overflow: TextOverflow.ellipsis,
    );
  }

  TextStyle _subtitleStyle() {
    return TextStyle(
      fontSize: 11,
      fontWeight: FontWeight.normal,
      overflow: TextOverflow.ellipsis,
    );
  }

  // Widget _buildTitle(BuildContext context) {
  //   ErrorInfo? errorInfo = executionTrace.getErrorInfo();
  //   bool hasEvent = executionTrace.hasEvent();
  //   return IconLabelText(
  //     text: executionTrace.getTitle(),
  //     style: _titleStyle(),
  //     suffixIcon: hasEvent
  //         ? Tooltip(
  //             message: "There was an event broadcast here.",
  //             child: Icon(
  //               Icons.electric_bolt_outlined,
  //               color: Colors.deepOrangeAccent,
  //               size: 14,
  //             ),
  //           )
  //         : null,
  //     suffixIcon2: errorInfo != null
  //         ? SimpleSmallIconButton(
  //             iconData: Icons.error_outline,
  //             iconColor: Colors.red,
  //             iconSize: 14,
  //             onPressed: () {
  //               _showErrorDialog(context, errorInfo);
  //             },
  //           )
  //         : null,
  //   );
  // }

  Widget _buildTitle(BuildContext context) {
    final theme = Theme.of(context);
    ErrorInfo? errorInfo = executionTrace.getErrorInfo();
    bool hasEvent = executionTrace.hasEvent();

    return IconLabelText(
      text: executionTrace.getTitle(),
      style: TextStyle(
        fontSize: 12,
        fontWeight: selected ? FontWeight.bold : FontWeight.normal,
        color: theme.colorScheme.onSurface,
        overflow: TextOverflow.ellipsis,
      ),
      suffixIcon: hasEvent
          ? Tooltip(
              message: "There was an event broadcast here.",
              child: Icon(
                Icons.electric_bolt_outlined,
                color: theme.colorScheme.tertiary,
                size: 14,
              ),
            )
          : null,
      endIcon: errorInfo != null
          ? SimpleSmallIconButton(
              iconData: Icons.error_outline,
              iconColor: theme.colorScheme.error,
              iconSize: 14,
              onPressed: () => _showErrorDialog(context, errorInfo),
            )
          : null,
    );
  }

  Widget _buildSubTitle(BuildContext context) {
    final theme = Theme.of(context);
    return Text(
      executionTrace.getSubtitle(),
      style: TextStyle(
        fontSize: 11,
        color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
        overflow: TextOverflow.ellipsis,
        fontFamily: 'Courier',
      ),
    );
  }

  void _showErrorDialog(BuildContext context, ErrorInfo errorInfo) {
    ErrorViewerDialog.open(
      context: context,
      title: "Error Viewer",
      errorInfo: errorInfo,
    );
  }
}
