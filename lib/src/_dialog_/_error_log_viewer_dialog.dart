part of '../../flutter_artist.dart';

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
}

class _ErrorLogViewerDialogState extends State<ErrorLogViewerDialog> {
  ErrorInfo? _errorInfo;
  bool showErrorDetail0 = true;
  bool showErrorDetail1 = true;

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
    return _CustomAppContainer(
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

  Widget _buildErrorDetails() {
    bool hasErrorDetails = _errorInfo != null &&
        _errorInfo!.errorDetails != null &&
        _errorInfo!.errorDetails!.isNotEmpty;
    bool hasStackTrace = _errorInfo != null && _errorInfo!.stackTrace != null;
    //
    if (hasErrorDetails && hasStackTrace) {
      showErrorDetail1 = showErrorDetail0;
    } else if (hasErrorDetails) {
      showErrorDetail1 = true;
    } else if (hasStackTrace) {
      showErrorDetail1 = false;
    }
    //
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_errorInfo != null)
          ListTile(
            dense: true,
            visualDensity: const VisualDensity(
              vertical: -3,
              horizontal: -3,
            ),
            contentPadding: EdgeInsets.all(0),
            horizontalTitleGap: 5,
            minVerticalPadding: 5,
            minLeadingWidth: 24,
            minTileHeight: 0,
            titleAlignment: ListTileTitleAlignment.top,
            leading: Icon(
              _dataStateErrorIconData,
              size: 18,
              color: Colors.red,
            ),
            title: Text(
              _errorInfo!.errorMessage,
              maxLines: 3,
              style: const TextStyle(
                fontSize: 13,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        if (hasErrorDetails || hasStackTrace)
          Expanded(
            child: Stack(
              children: [
                if (hasErrorDetails && showErrorDetail1)
                  _CustomAppContainer(
                    width: double.maxFinite,
                    height: double.maxFinite,
                    child: ListView(
                      children: _errorInfo!.errorDetails!
                          .map((errorDetail) => _buildErrorDetail(errorDetail))
                          .toList(),
                    ),
                  ),
                if (hasStackTrace && !showErrorDetail1)
                  _CustomAppContainer(
                    width: double.maxFinite,
                    height: double.maxFinite,
                    child: SingleChildScrollView(
                      child: Text(
                        _errorInfo!.stackTrace.toString(),
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                  ),
                if (hasStackTrace && hasErrorDetails)
                  Positioned(
                    top: 5,
                    right: 5,
                    child: AdvancedSwitch(
                      initialValue: showErrorDetail1,
                      activeColor: Colors.indigo,
                      inactiveColor: Colors.grey,
                      activeChild: const Text('Error Details'),
                      inactiveChild: const Text('Stack Trace'),
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      width: 130.0,
                      height: 20.0,
                      enabled: true,
                      onChanged: (dynamic checked) {
                        showErrorDetail0 = checked ?? false;
                        showErrorDetail1 = checked ?? false;
                        setState(() {});
                      },
                    ),
                  ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildErrorDetail(String errorDetail) {
    return Material(
      child: ListTile(
        dense: true,
        visualDensity: const VisualDensity(
          vertical: -3,
          horizontal: -3,
        ),
        contentPadding: const EdgeInsets.all(0),
        horizontalTitleGap: 5,
        minVerticalPadding: 5,
        minLeadingWidth: 28,
        minTileHeight: 0,
        leading: const Padding(
          padding: EdgeInsets.only(left: 10),
          child: Icon(
            _listItemBulletIconData,
            color: Colors.black,
            size: 16,
          ),
        ),
        title: Text(
          errorDetail,
          style: const TextStyle(fontSize: 12),
        ),
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
            child: _buildErrorDetails(),
          ),
        ],
      ),
    );
  }
}

Future<void> _showErrorLogViewerDialog({
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
