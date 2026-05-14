import 'package:flutter/material.dart';
import 'package:flutter_artist_commons_ui/flutter_artist_commons_ui.dart';
import 'package:flutter_artist_core/flutter_artist_core.dart';
import 'package:flutter_artist_styles/flutter_artist_styles.dart';
import 'package:tabbed_view/tabbed_view.dart';

import '../../core/enums/_tip_document.dart';
import '../../core/icon/icon_constants.dart';
import '../utils/_tab_theme_utils.dart';
import '../widgets/_doc_link_view.dart';

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

  static Future<void> show({
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

  String _selectedLangCode = 'en';
  late Future<FaDocuments> _docsFuture;

  @override
  void initState() {
    super.initState();
    tipDocument = widget.tipDocument;
    _docsFuture = FlutterArtistDocSystem.instance.faDocuments;
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

  Widget _buildControlBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: context.faColors.bar.standard,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        children: [
          Icon(
            Icons.auto_awesome_outlined,
            size: 12,
            color: context.faColors.action.ink.highlight,
          ),
          const SizedBox(width: 4),
          Text(
            "${tipDocument.getPosition()} / ${TipDocument.enabledValues.length}",
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: context.faColors.ink.primary,
            ),
          ),
          const SizedBox(width: 16),
          _buildLangFlag("EN", "en"),
          const SizedBox(width: 8),
          _buildLangFlag("VI", "vi"),
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

  Widget _buildLangFlag(String flag, String langCode) {
    bool isSelected = _selectedLangCode == langCode;
    return InkWell(
      onTap: () {
        setState(() {
          _selectedLangCode = langCode;
          _refresh(tipDocument);
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        decoration: BoxDecoration(
          color: isSelected
              ? context.faColors.action.fill.selected
              : context.faColors.common.transparent,
          border: isSelected
              ? Border.all(
                  color: context.faColors.action.stroke.primary, width: 0.5)
              : null,
          borderRadius: BorderRadius.circular(4),
        ),
        child: FlagCdnView.flagHeight(langCode: langCode, height: 14),
      ),
    );
  }

  Widget _buildDocumentList(BuildContext context) {
    return FutureBuilder<FaDocuments>(
      future: _docsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator(strokeWidth: 2));
        }
        List<String> docIds = tipDocument.getDocuments();
        List<FaDocument> filteredDocs = [];

        if (snapshot.hasData) {
          filteredDocs = snapshot.data!.documents
              .where((doc) =>
                  doc.langCode == _selectedLangCode && docIds.contains(doc.id))
              .toList();
        }

        if (filteredDocs.isEmpty) {
          return Center(
            child: Text(
              "No documentation available for $_selectedLangCode.",
              style: TextStyle(
                color: context.faColors.ink.muted,
                fontSize: 12,
              ),
            ),
          );
        }

        return ListView(
          padding: const EdgeInsets.all(6),
          children: [
            Text(
              "Detailed Documentation ($_selectedLangCode)",
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: context.faColors.ink.label,
              ),
            ),
            const SizedBox(height: 8),
            ...filteredDocs.map(
              (doc) => DocLinkView(
                faDocument: doc,
                padding: EdgeInsets.all(8),
                margin: EdgeInsets.only(bottom: 8),
              ),
            ),
          ],
        );
      },
    );
  }

  void _refresh(TipDocument newTipDocument) {
    int currentTab = _controller.selectedIndex ?? 0;

    setState(() {
      tipDocument = newTipDocument;

      List<TabData> tabs = _buildTabs();

      _controller.setTabs(tabs);

      Future.microtask(() {
        if (_controller.tabs.isNotEmpty) {
          _controller.selectedIndex = currentTab;
        }
      });
    });
  }

  List<TabData> _buildTabs() {
    return [
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
      TabData(
        id: "docs",
        text: ' Docs',
        closable: false,
        leading: (context, status) => Icon(
          Icons.policy_outlined,
          color: TabThemeUtils.getTabIconColor(context, status),
          size: 16,
        ),
        view: _buildDocumentList(context), // Sử dụng hàm nạp tài liệu mới
      ),
    ];
  }

  Widget _buildMainContent(BuildContext context) {
    return Column(
      children: [
        _buildControlBar(),
        const SizedBox(height: 6),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: context.faColors.surface.muted,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: context.faColors.divider.subtle),
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

  Widget _buildTip() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.lightbulb_outline_rounded,
                size: 14,
                color: context.faColors.ink.highlight,
              ),
              const SizedBox(width: 6),
              Text("PRO TIP",
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: context.faColors.ink.highlight,
                  )),
            ],
          ),
          const SizedBox(height: 4),
          SelectableText(
            tipDocument.getTip(),
            style: TextStyle(
              fontSize: 13,
              height: 1.4,
              color: context.faColors.ink.primary,
            ),
          ),
        ],
      ),
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
          child: Icon(
            icon,
            size: 14,
            color: context.faColors.action.ink.primary,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}
