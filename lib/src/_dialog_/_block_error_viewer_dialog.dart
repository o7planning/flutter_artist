part of '../../flutter_artist.dart';

class BlockErrorViewerDialog extends StatelessWidget {
  final BlockErrorInfo blockErrorInfo;

  const BlockErrorViewerDialog({
    required this.blockErrorInfo,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    dialogs.FaAlertDialog alert = dialogs.FaAlertDialog(
      titleText: "Error",
      contentPadding: EdgeInsets.all(8),
      content: _buildContent(context),
    );
    return alert;
  }

  Widget _buildContent(BuildContext context) {
    AppError apiError = ErrorUtils.toAppError(blockErrorInfo.error);
    //
    final Size size = calculatePreferredDialogSize(
      context,
      preferredWidth: 440,
      preferredHeight:
          apiError.errorDetails == null || apiError.errorDetails!.isEmpty
              ? 200
              : 280,
    );
    //
    return Container(
      height: size.height,
      width: size.width,
      padding: EdgeInsets.all(5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("?? ${blockErrorInfo.queryDataState}"),
          if (blockErrorInfo.queryDataState == DataState.error)
            IconLabelText(
              icon: Icon(
                _formErrorDisabledIconData2,
                color: Colors.red,
                size: 20,
              ),
              text: "Block query data error.",
            ),
          Divider(),
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
              apiError.errorMessage,
              maxLines: 3,
              style: const TextStyle(
                fontSize: 13,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          if (apiError != null &&
              apiError.errorDetails != null &&
              apiError.errorDetails!.isNotEmpty)
            Divider(height: 10),
          Expanded(
            child: ListView(
              children: apiError != null &&
                      apiError.errorDetails != null &&
                      apiError.errorDetails!.isNotEmpty
                  ? apiError.errorDetails!
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

Future<void> _showBlockErrorViewerDialog({
  required BuildContext context,
  required BlockErrorInfo blockErrorInfo,
}) async {
  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return BlockErrorViewerDialog(
        blockErrorInfo: blockErrorInfo,
      );
    },
  );
}
