import 'package:flutter/material.dart';
import 'package:flutter_artist_commons_ui/flutter_artist_commons_ui.dart'
as dialogs;
import 'package:flutter_artist_commons_ui/flutter_artist_commons_ui.dart';
import 'package:flutter_artist_core/flutter_artist_core.dart';

import '../../core/error_logger/_error_logger.dart';
import '../../core/widgets/_custom_app_container.dart';
import '../section/_error_info_viewer.dart';

class ErrorLogViewerDialog extends StatefulWidget {
  final String title;
  final ErrorLogger errorLogger;

  const ErrorLogViewerDialog({
    this.title = 'Error Log Viewer',
    required this.errorLogger,
    super.key,
  });

  @override
  State<StatefulWidget> createState() {
    return _ErrorLogViewerDialogState();
  }

  static Future<void> showErrorLogViewerDialog({
    required BuildContext context,
    required ErrorLogger errorLogger,
  }) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return ErrorLogViewerDialog(
          errorLogger: errorLogger,
        );
      },
    );
  }
}

class _ErrorLogViewerDialogState extends State<ErrorLogViewerDialog> {
  ErrorInfo? _errorInfo;

  @override
  void initState() {
    super.initState();
    _errorInfo = widget.errorLogger.lastError;
  }

  @override
  Widget build(BuildContext context) {
    Size preferredSize = calculatePreferredDialogSize(
      context,
      preferredWidth: 620,
      preferredHeight: 400,
    );

    dialogs.FaAlertDialog alert = dialogs.FaAlertDialog(
      titleText: widget.title,
      contentPadding: EdgeInsets.all(8),
      content: _buildContent(preferredSize.width, preferredSize.height),
    );
    return alert;
  }

  Widget _buildErrorButtons() {
    return CustomAppContainer(
      width: double.maxFinite,
      child: Wrap(
        spacing: 5,
        children: widget.errorLogger.errorInfos
            .map(
              (errorInfo) => TextButton(
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.all(10),
                  minimumSize: Size.zero,
                  backgroundColor: _errorInfo == errorInfo
                      ? Colors.blueGrey.withAlpha(80)
                      : Colors.blueGrey.withAlpha(30),
                ),
                onPressed: () {
                  _errorInfo = errorInfo;
                  setState(() {});
                },
                child: Text(errorInfo.id.toString()),
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _buildContent(double width, double height) {
    return SizedBox(
      width: width,
      height: height,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildErrorButtons(),
          Expanded(
            child: _errorInfo == null
                ? SizedBox()
                : ErrorInfoView(
                    errorInfo: _errorInfo!,
                    width: width,
                    height: height,
                  ),
          ),
        ],
      ),
    );
  }
}
