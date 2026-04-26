import 'package:flutter/material.dart';
import 'package:flutter_artist_commons_ui/flutter_artist_commons_ui.dart';
import 'package:flutter_artist_core/flutter_artist_core.dart';
import 'package:tabbed_view/tabbed_view.dart';

import '../../core/enums/_tip_document.dart';
import '../../core/icon/icon_constants.dart';
import '../../core/widgets/_simple_copy_button.dart';
import '../../core/widgets/_simple_open_url_button.dart';
import '../utils/_tab_theme_utils.dart';

class TipDocumentViewerDialog extends StatefulWidget {
  final TipDocument tipDocument;

  const TipDocumentViewerDialog({
    required this.tipDocument,
    super.key,
  });

  @override
  State<StatefulWidget> createState() {
    return _TipDocumentViewerDialogState();
  }

  static Future<void> open({
    required BuildContext context,
    required TipDocument tipDocument,
  }) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return TipDocumentViewerDialog(
          tipDocument: tipDocument,
        );
      },
    );
  }
}

class _TipDocumentViewerDialogState extends State<TipDocumentViewerDialog> {
  late TipDocument tipDocument;
  late TabbedViewController _controller;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    tipDocument = widget.tipDocument;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      _controller = TabbedViewController(_buildTabs());
      _controller.selectedIndex = 0;
      _isInitialized = true;
    }
  }

  Widget _buildMainContent(BuildContext context) {
    return Column(
      children: [
        _buildControlBar(),
        const SizedBox(height: 6),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color:
                  FaColorUtils.surfaceContainer(context).withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(4),
              border: Border.all(
                  color: FaColorUtils.dividerColor(context)
                      .withValues(alpha: 0.3)),
            ),
            child: TabbedViewTheme(
              data: TabThemeUtils.getTabbedViewThemeData(context),
              child: TabbedView(controller: _controller),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildControlBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: FaColorUtils.surfaceContainer(context).withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        children: [
          Icon(Icons.auto_awesome_outlined,
              size: 12, color: FaColorUtils.technicalHighlight(context)),
          const SizedBox(width: 4),
          Text(
            "${tipDocument.getPosition()} / ${TipDocument.enabledValues.length}",
            style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: FaColorUtils.primaryContent(context)),
          ),
          const Spacer(),
          _buildNavButton(Icons.arrow_back_ios_new_rounded,
              () => _refresh(tipDocument.previous())),
          const SizedBox(width: 4),
          _buildNavButton(Icons.arrow_forward_ios_rounded,
              () => _refresh(tipDocument.next())),
        ],
      ),
    );
  }

  Widget _buildTip() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.lightbulb_outline_rounded,
                  size: 14, color: FaColorUtils.technicalHighlight(context)),
              const SizedBox(width: 6),
              Text("PRO TIP",
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: FaColorUtils.technicalHighlight(context),
                  )),
            ],
          ),
          const SizedBox(height: 4),
          SelectableText(
            tipDocument.getTip(),
            style: TextStyle(
                fontSize: 13,
                height: 1.4,
                color: FaColorUtils.primaryContent(context)),
          ),
        ],
      ),
    );
  }

  Widget? _buildDocument(BuildContext context) {
    List<String> docs = tipDocument.getDocuments();
    if (docs.isEmpty) return null;

    return ListView(
      padding: const EdgeInsets.all(6),
      children: [
        Text("Detailed Documentation",
            style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: FaColorUtils.infoLabel(context))),
        const SizedBox(height: 8),
        ...docs.map((doc) => _buildLink(context, doc)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final Size preferContentSize = calculatePreferredDialogSize(
      context,
      preferredWidth: 620,
      preferredHeight: 340,
    );

    return FaDialog(
      iconData: FaIconConstants.tipDocument,
      titleText: "Artist Insights - ${tipDocument.getTitle()}",
      contentPadding: const EdgeInsets.all(8),
      preferredContentWidth: preferContentSize.width,
      preferredContentHeight: preferContentSize.height,
      content: _buildMainContent(context),
    );
  }

  Widget _buildNavButton(IconData icon, VoidCallback onPressed) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(4),
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: Icon(icon,
              size: 14, color: FaColorUtils.primaryAction(context)),
        ),
      ),
    );
  }

  Widget _buildLink(BuildContext context, String url) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: FaColorUtils.primaryContent(context).withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
            color: FaColorUtils.dividerColor(context).withValues(alpha: 0.5)),
      ),
      child: Row(
        children: [
          Icon(Icons.link_rounded,
              size: 16, color: FaColorUtils.primaryAction(context)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              url,
              style: TextStyle(
                  fontSize: 13,
                  color: FaColorUtils.primaryAction(context),
                  decoration: TextDecoration.underline),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SimpleOpenUrlButton(
                iconSize: 16,
                url: url,
              ),
              SimpleCopyButton(
                iconSize: 16,
                getText: () {
                  return url;
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _refresh(TipDocument newTipDocument) {
    tipDocument = newTipDocument;
    List<TabData> tabs = _buildTabs();
    int currentTab = _controller.selectedIndex ?? 0;
    _controller.setTabs(tabs);
    _controller.selectedIndex = currentTab;
    setState(() {});
  }

  List<TabData> _buildTabs() {
    List<TabData> tabs = [];

    tabs.add(
      TabData(
        id: "tips",
        text: ' Tips',
        closable: false,
        leading: (context, status) => Icon(
          Icons.tips_and_updates_outlined,
          color: TabThemeUtils.getTabIconColor(context, status),
          size: 16,
        ),
        view: _buildTip(),
      ),
    );
    tabs.add(
      TabData(
        id: "docs",
        text: ' Docs',
        closable: false,
        leading: (context, status) => Icon(
          Icons.policy_outlined,
          color: TabThemeUtils.getTabIconColor(context, status),
          size: 16,
        ),
        view: _buildDocument(context),
      ),
    );
    return tabs;
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}
