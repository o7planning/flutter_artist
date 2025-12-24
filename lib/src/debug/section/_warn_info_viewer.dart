import 'package:flutter/material.dart';
import 'package:flutter_artist_core/flutter_artist_core.dart';

import '../../core/icon/icon_constants.dart';

class WarningInfoView extends StatefulWidget {
  final WarningInfo warningInfo;
  final double width;
  final double height;

  const WarningInfoView({
    required this.warningInfo,
    required this.width,
    required this.height,
    super.key,
  });

  @override
  State<StatefulWidget> createState() {
    return _WarningInfoViewState();
  }
}

class _WarningInfoViewState extends State<WarningInfoView> {
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
      child: _buildWarningDetails(),
    );
  }

  Widget _buildWarningDetails() {
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
            FaIconConstants.dataStateWarningIconData,
            size: 18,
            color: Colors.deepOrange,
          ),
          title: Text(
            widget.warningInfo.warningMessage,
            maxLines: 3,
            style: const TextStyle(
              fontSize: 13,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ],
    );
  }
}
