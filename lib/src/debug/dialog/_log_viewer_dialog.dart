import 'package:flutter/material.dart';
import 'package:flutter_artist_commons_ui/flutter_artist_commons_ui.dart'
    as dialogs;
import 'package:flutter_artist_commons_ui/flutter_artist_commons_ui.dart';
import 'package:flutter_artist_core/flutter_artist_core.dart';
import 'package:flutter_artist_styles/flutter_artist_styles.dart';

import '../../core/_core_/core.dart';
import '../../core/enums/_tip_document.dart';
import '../../core/icon/icon_constants.dart';
import '../../core/logger/_logger.dart';
import '../../core/widgets/_custom_app_container.dart';
import '../section/_error_info_viewer.dart';
import '../section/_warn_info_viewer.dart';
import '_tip_document_viewer_dialog.dart';

class LogViewerDialog extends StatefulWidget {
  final String title;
  final Logger logger;
  final int? logEntryId;

  const LogViewerDialog({
    this.title = 'Log Viewer',
    required this.logger,
    this.logEntryId,
    super.key,
  });

  @override
  State<StatefulWidget> createState() {
    return _LogViewerDialogState();
  }

  static Future<void> open({
    required BuildContext context,
    required Logger logger,
    int? logEntryId,
  }) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return LogViewerDialog(
          logger: logger,
          logEntryId: logEntryId,
        );
      },
    );
  }
}

class _LogViewerDialogState extends State<LogViewerDialog> {
  LogEntry? _logEntry;

  @override
  void initState() {
    super.initState();
    if (widget.logEntryId != null) {
      _logEntry = widget.logger.findLogEntry(logEntryId: widget.logEntryId!);
    } else {
      _logEntry = widget.logger.lastEntry;
    }
  }

  @override
  void dispose() {
    super.dispose();
    widget.logger.setViewed();
  }

  @override
  Widget build(BuildContext context) {
    final ILoggedInUser? loggedInUser = FlutterArtist.loggedInUser;
    return dialogs.FaDialog(
      iconData: FaIconConstants.logViewerIconData,
      titleText: widget.title,
      contentPadding: const EdgeInsets.all(8),
      preferredContentWidth: 760,
      preferredContentHeight: 380,
      content: _buildContent(),
      onHelpPressed: loggedInUser == null || !loggedInUser.isSystemUser
          ? null
          : () {
              TipDocumentViewerDialog.show(
                context: context,
                tipDocument: TipDocument.logViewer,
              );
            },
    );
  }

  Widget _buildSummaryInfo() {
    final double fontSize = 11;
    final double iconSize = 14;
    final TipDocument? tipDocument = _logEntry?.tipDocument as TipDocument?;

    return CustomAppContainer.customBackground(
      backgroundColor: context.faColors.bar.standard,
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: Row(
        children: [
          Tooltip(
            message: "Tip & Document",
            child: SimpleSmallIconButton(
              iconData: FaIconConstants.tipDocument,
              iconSize: iconSize,
              iconColor: tipDocument == null || !tipDocument.enabled
                  ? null
                  : context.faColors.action.ink.primary,
              onPressed: tipDocument == null || !tipDocument.enabled
                  ? null
                  : () {
                      TipDocumentViewerDialog.show(
                        context: context,
                        tipDocument: tipDocument,
                      );
                    },
            ),
          ),
          const Spacer(),
          _buildStatItem("Recent: ", widget.logger.recentErrorCount,
              widget.logger.recentWarningCount, fontSize, iconSize),
          const SizedBox(width: 16),
          _buildStatItem("Total: ", widget.logger.totalErrorCount,
              widget.logger.totalWarningCount, fontSize, iconSize),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, int errors, int warnings, double fontSize,
      double iconSize) {
    return Row(
      children: [
        Text(label,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: fontSize,
                color: context.faColors.ink.label)),
        const SizedBox(width: 4),
        Icon(FaIconConstants.dataStateErrorIconData,
            size: iconSize, color: context.faColors.ink.danger),
        const SizedBox(width: 2),
        Text(errors.toString(),
            style: TextStyle(
                fontSize: fontSize,
                fontFamily: 'Courier',
                color: context.faColors.ink.danger)),
        const SizedBox(width: 8),
        Icon(FaIconConstants.dataStateWarningIconData,
            size: iconSize, color: context.faColors.ink.warning),
        const SizedBox(width: 2),
        Text(warnings.toString(),
            style: TextStyle(
                fontSize: fontSize,
                fontFamily: 'Courier',
                color: context.faColors.ink.warning)),
      ],
    );
  }

  Widget _buildLogEntryButtons() {
    return Container(
      width: double.maxFinite,
      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
      decoration: BoxDecoration(color: context.faColors.bar.standard),
      child: Wrap(
        spacing: 4,
        runSpacing: 4,
        children: widget.logger.logEntries.map((logEntry) {
          final bool isSelected = _logEntry == logEntry;
          final bool isError = logEntry.logEntryType == LogEntryType.error;

          final Color themeColor = isError
              ? context.faColors.ink.danger
              : context.faColors.ink.warning;

          return InkWell(
            onTap: () => setState(() => _logEntry = logEntry),
            borderRadius: BorderRadius.circular(4),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: isSelected
                    ? (isError
                            ? context.faColors.action.fill.danger
                            : context.faColors.action.fill.warning)
                        .withValues(alpha: 0.3)
                    : themeColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                  color: isSelected
                      ? themeColor
                      : themeColor.withValues(alpha: 0.3),
                  width: 0.5,
                ),
              ),
              child: Text(
                logEntry.id.toString(),
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: themeColor,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildContent() {
    if (_logEntry == null) return const SizedBox();

    Widget view;
    switch (_logEntry!.logEntryType) {
      case LogEntryType.error:
        view = ErrorInfoView(errorInfo: _logEntry!.errorInfo!);
      case LogEntryType.warning:
        view = WarningInfoView(warningInfo: _logEntry!.warningInfo!);
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLogEntryButtons(),
        const SizedBox(height: 8),
        _buildSummaryInfo(),
        const SizedBox(height: 8),
        Expanded(
          child: Align(
            alignment: Alignment.topLeft,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: view,
            ),
          ),
        ),
      ],
    );
  }
}
