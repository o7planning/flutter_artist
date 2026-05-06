import 'package:flutter/material.dart';
import 'package:flutter_artist_commons_ui/flutter_artist_commons_ui.dart';

import '../../core/_core_/core.dart';
import '../../core/enums/_trace_step_type.dart';
import '../../core/icon/icon_constants.dart';
import '../../core/widgets/_html_selectable_rich_text.dart';
import '../dialog/_error_viewer_dialog.dart';
import '../dialog/_extra_info_viewer_dialog.dart';
import '../dialog/_tip_document_viewer_dialog.dart';

class TraceStepBox extends StatelessWidget {
  final TraceStep traceStep;

  const TraceStepBox({
    required this.traceStep,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (traceStep.traceStepType == TraceStepType.separator) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Divider(
          color: colorScheme.primary.withValues(alpha: 0.2),
          thickness: 1,
          indent: 20,
          endIndent: 20,
        ),
      );
    }

    return Container(
      width: double.maxFinite,
      margin: const EdgeInsets.symmetric(vertical: 2),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: theme.dividerColor.withValues(alpha: 0.05),
          width: 0.5,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HtmlSelectableRichText(
              "${traceStep.shortDesc}${traceStep.getParametersAsHtmlString()}"
              "${traceStep.getActionableAsHtmlString()}${traceStep.getNoteAsHtmlString()}",
              icon: Icon(
                traceStep.traceStepType.getIconData(),
                color: traceStep.showIconAndLabel
                    ? traceStep.traceStepType
                        .getIconColor(context) // Đã dùng Semantic Color
                    : Colors.transparent,
                size: 16,
              ),
              label: traceStep.lineId,
              labelStyle: TextStyle(
                fontSize: 12,
                fontFamily: 'Courier',
                fontWeight: FontWeight.bold,
                color: traceStep.showIconAndLabel
                    ? colorScheme.primary
                    : Colors.transparent,
              ),
              tagStyles: {
                'b': const TextStyle(fontWeight: FontWeight.bold),
                'i': const TextStyle(fontStyle: FontStyle.italic),
                'code': TextStyle(
                  fontFamily: 'Courier',
                  backgroundColor:
                      colorScheme.onSurface.withValues(alpha: 0.05),
                ),
              },
              style: TextStyle(
                fontSize: 12,
                color: colorScheme.onSurface.withValues(alpha: 0.9),
              ),
            ),
            if (traceStep.needControlBar()) const SizedBox(height: 6),
            if (traceStep.needControlBar()) _buildControlBar(context),
          ],
        ),
      ),
    );
  }

  Widget _buildControlBar(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Wrap(
      spacing: 4,
      children: [
        _buildActionIcon(
          context,
          message: "Error Info",
          icon: Icons.error_outline_rounded,
          color: traceStep.errorInfo == null ? null : colorScheme.error,
          onPressed: traceStep.errorInfo == null
              ? null
              : () => _showErrorDialog(context),
        ),
        _buildActionIcon(
          context,
          message: "Extra Info",
          icon: Icons.playlist_add_check_circle_outlined,
          color: traceStep.hasExtraInfos() ? colorScheme.primary : null,
          onPressed: traceStep.hasExtraInfos()
              ? () => _showExtraInfoDialog(context)
              : null,
        ),
        _buildActionIcon(
          context,
          message: "Tip & Document",
          icon: FaIconConstants.tipDocument,
          color: traceStep.tipDocument == null ? null : colorScheme.tertiary,
          onPressed:
              traceStep.tipDocument == null || !traceStep.tipDocument!.enabled
                  ? null
                  : () => _showTipDocumentDialog(context),
        ),
      ],
    );
  }

  Widget _buildActionIcon(
    BuildContext context, {
    required String message,
    required IconData icon,
    Color? color,
    VoidCallback? onPressed,
  }) {
    return Tooltip(
      message: message,
      child: SimpleSmallIconButton(
        iconData: icon,
        iconColor: color,
        iconSize: 16,
        onPressed: onPressed,
      ),
    );
  }

  void _showExtraInfoDialog(BuildContext context) {
    ExtraInfoViewerDialog.open(
      context: context,
      title: "Extra Info",
      extraInfos: traceStep.extraInfos ?? [],
    );
  }

  void _showErrorDialog(BuildContext context) {
    if (traceStep.errorInfo != null) {
      ErrorViewerDialog.open(
        context: context,
        title: "Error Viewer",
        errorInfo: traceStep.errorInfo!,
      );
    }
  }

  void _showTipDocumentDialog(BuildContext context) {
    if (traceStep.tipDocument != null) {
      TipDocumentViewerDialog.show(
        context: context,
        tipDocument: traceStep.tipDocument!,
      );
    }
  }
}
