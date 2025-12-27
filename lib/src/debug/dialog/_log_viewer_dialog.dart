import 'package:flutter/material.dart';
import 'package:flutter_artist/flutter_artist.dart';
import 'package:flutter_artist/src/core/icon/icon_constants.dart';
import 'package:flutter_artist/src/debug/dialog/_tip_document_viewer_dialog.dart';
import 'package:flutter_artist_commons_ui/flutter_artist_commons_ui.dart'
    as dialogs;
import 'package:flutter_artist_commons_ui/flutter_artist_commons_ui.dart';
import 'package:flutter_artist_core/flutter_artist_core.dart';
import 'package:flutter_artist_core/src/_enum/_log_entry_type.dart';

import '../../core/enums/_tip_document.dart';
import '../../core/logger/_logger.dart';
import '../../core/widgets/_custom_app_container.dart';
import '../section/_error_info_viewer.dart';
import '../section/_warn_info_viewer.dart';

class LogViewerDialog extends StatefulWidget {
  final String title;
  final Logger logger;

  const LogViewerDialog({
    this.title = 'Log Viewer',
    required this.logger,
    super.key,
  });

  @override
  State<StatefulWidget> createState() {
    return _LogViewerDialogState();
  }

  static Future<void> showLogViewerDialog({
    required BuildContext context,
    required Logger logger,
  }) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return LogViewerDialog(
          logger: logger,
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
    _logEntry = widget.logger.lastEntry;
  }

  @override
  void dispose() {
    super.dispose();
    widget.logger.setViewed();
  }

  @override
  Widget build(BuildContext context) {
    final ILoggedInUser? loggedInUser = FlutterArtist.loggedInUser;

    Size preferredSize = calculatePreferredDialogSize(
      context,
      preferredWidth: 640,
      preferredHeight: 380,
    );

    dialogs.FaAlertDialog alert = dialogs.FaAlertDialog(
      icon: Icon(
        FaIconConstants.logViewerIconData,
        size: 20,
        color: Colors.indigo,
      ),
      titleText: widget.title,
      contentPadding: EdgeInsets.all(8),
      content: _buildContent(preferredSize.width, preferredSize.height),
      onHelpPressed: loggedInUser == null || !loggedInUser.isSystemUser
          ? null
          : () {
              TipDocumentViewerDialog.showTipDocumentDialog(
                context: context,
                tipDocument: TipDocument.logViewer,
              );
            },
    );
    return alert;
  }

  Widget _buildSummaryInfo() {
    final double fontSize = 12;
    final double iconSize = 14;
    final TipDocument? tipDocument = _logEntry?.tipDocument as TipDocument?;

    return Card(
      margin: EdgeInsets.all(0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(4),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 2, horizontal: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Tooltip(
              message: "Tip & Document",
              child: SimpleSmallIconButton(
                iconData: FaIconConstants.tipDocument,
                iconSize: iconSize,
                iconColor: tipDocument == null || !tipDocument.enabled
                    ? null
                    : Colors.deepOrange,
                onPressed: tipDocument == null || !tipDocument.enabled
                    ? null
                    : () {
                        TipDocumentViewerDialog.showTipDocumentDialog(
                          context: context,
                          tipDocument: tipDocument,
                        );
                      },
              ),
            ),
            Spacer(),
            Text(
              "Recent: ",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: fontSize,
              ),
            ),
            Icon(
              FaIconConstants.dataStateErrorIconData,
              size: iconSize,
              color: LogEntryType.error.bgColor,
            ),
            SizedBox(width: 5),
            Text(
              widget.logger.recentErrorCount.toString(),
              style: TextStyle(fontSize: fontSize),
            ),
            SizedBox(width: 5),
            Icon(
              FaIconConstants.dataStateWarningIconData,
              size: iconSize,
              color: LogEntryType.warning.bgColor,
            ),
            SizedBox(width: 5),
            Text(
              widget.logger.recentWarningCount.toString(),
              style: TextStyle(fontSize: fontSize),
            ),
            SizedBox(width: 10),
            Text(
              "Total: ",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: fontSize,
              ),
            ),
            Icon(
              FaIconConstants.dataStateErrorIconData,
              size: iconSize,
              color: LogEntryType.error.bgColor,
            ),
            SizedBox(width: 5),
            Text(
              widget.logger.totalErrorCount.toString(),
              style: TextStyle(fontSize: fontSize),
            ),
            SizedBox(width: 5),
            Icon(
              FaIconConstants.dataStateWarningIconData,
              size: iconSize,
              color: LogEntryType.warning.bgColor,
            ),
            SizedBox(width: 5),
            Text(
              widget.logger.totalWarningCount.toString(),
              style: TextStyle(fontSize: fontSize),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogEntryButtons() {
    return CustomAppContainer(
      width: double.maxFinite,
      padding: EdgeInsets.symmetric(vertical: 3, horizontal: 5),
      child: Wrap(
        spacing: 5,
        children: widget.logger.logEntries
            .map(
              (logEntry) => TextButton(
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.all(8),
                  minimumSize: Size.zero,
                  backgroundColor: logEntry.logEntryType.bgColor,
                  side: BorderSide(
                    color: _logEntry == logEntry
                        ? Colors.blue
                        : logEntry.logEntryType.bgColor,
                    width: 1.0,
                  ),
                ),
                onPressed: () {
                  _logEntry = logEntry;
                  setState(() {});
                },
                child: Text(
                  logEntry.id.toString(),
                  style: TextStyle(color: logEntry.logEntryType.textColor),
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _buildContent(double width, double height) {
    if (_logEntry == null) {
      return SizedBox();
    }
    Widget view;
    switch (_logEntry!.logEntryType) {
      case LogEntryType.error:
        view = ErrorInfoView(
          errorInfo: _logEntry!.errorInfo!,
          width: width,
          height: height,
        );
      case LogEntryType.warning:
        view = WarningInfoView(
          warningInfo: _logEntry!.warningInfo!,
          width: width,
          height: height,
        );
    }
    return SizedBox(
      width: width,
      height: height,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLogEntryButtons(),
          SizedBox(height: 5),
          _buildSummaryInfo(),
          SizedBox(height: 5),
          Expanded(child: view),
        ],
      ),
    );
  }
}
