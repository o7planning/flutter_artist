part of '../../flutter_artist.dart';

class ErrorInfoView extends StatefulWidget {
  final ErrorInfo errorInfo;
  final double width;
  final double height;

  const ErrorInfoView({
    required this.errorInfo,
    required this.width,
    required this.height,
    super.key,
  });

  @override
  State<StatefulWidget> createState() {
    return _ErrorInfoViewState();
  }
}

class _ErrorInfoViewState extends State<ErrorInfoView> {
  bool showErrorDetail0 = true;
  bool showErrorDetail1 = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: _buildErrorDetails(),
    );
  }

  Widget _buildErrorDetails() {
    bool hasErrorDetails = widget.errorInfo.errorDetails != null &&
        widget.errorInfo.errorDetails!.isNotEmpty;
    bool hasStackTrace = widget.errorInfo.stackTrace != null;
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
            widget. errorInfo.errorMessage,
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
                      children: appError.errorDetails!
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
                        widget.errorInfo.stackTrace.toString(),
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
}
