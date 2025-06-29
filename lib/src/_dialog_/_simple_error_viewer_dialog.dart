part of '../../flutter_artist.dart';

class SimpleErrorViewerDialog extends StatelessWidget {
  final String title;
  final Object error;

  const SimpleErrorViewerDialog({
    required this.title,
    required this.error,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    dialogs.FaAlertDialog alert = dialogs.FaAlertDialog(
      titleText: title,
      contentPadding: EdgeInsets.all(8),
      content: _buildContent(context),
    );
    return alert;
  }

  Widget _buildContent(BuildContext context) {
    AppError appError = ErrorUtils.toAppError(error);
    //
    final Size size = calculatePreferredDialogSize(
      context,
      preferredWidth: 440,
      preferredHeight:
          appError.errorDetails == null || appError.errorDetails!.isEmpty
              ? 160
              : 240,
    );

    return Container(
      height: size.height,
      width: size.width,
      padding: EdgeInsets.all(5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
              appError.errorMessage,
              maxLines: 3,
              style: const TextStyle(
                fontSize: 13,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          if (appError.errorDetails != null &&
              appError.errorDetails!.isNotEmpty)
            Divider(height: 10),
          Expanded(
            child: ListView(
              children: appError.errorDetails != null &&
                      appError.errorDetails!.isNotEmpty
                  ? appError.errorDetails!
                      .map((errorDetail) => _buildErrorDetail(errorDetail))
                      .toList()
                  : [],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorDetail(String errorDetail) {
    return ListTile(
      dense: true,
      visualDensity: const VisualDensity(
        vertical: -3,
        horizontal: -3,
      ),
      contentPadding: const EdgeInsets.all(0),
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
    );
  }
}

Future<void> _showErrorViewerDialog({
  required BuildContext context,
  required String title,
  required dynamic error,
}) async {
  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return SimpleErrorViewerDialog(
        title: title,
        error: error,
      );
    },
  );
}
