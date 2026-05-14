import 'package:flutter/material.dart';
import 'package:flutter_artist_commons_ui/flutter_artist_commons_ui.dart';
import 'package:flutter_artist_core/flutter_artist_core.dart';
import 'package:flutter_artist_styles/flutter_artist_styles.dart';

import '../widgets/_doc_link_view.dart';

class DocumentSelectionDialog extends StatefulWidget {
  final List<String> documentIds;
  final String title;

  const DocumentSelectionDialog({
    required this.documentIds,
    this.title = "Related Documentation",
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _DocumentSelectionDialogState();

  static Future<void> show({
    required BuildContext context,
    required List<String> documentIds,
    String? title,
  }) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return DocumentSelectionDialog(
          documentIds: documentIds,
          title: title ?? "Related Documentation",
        );
      },
    );
  }
}

class _DocumentSelectionDialogState extends State<DocumentSelectionDialog> {
  String _selectedLangCode = 'en';
  late Future<FaDocuments> _docsFuture;

  @override
  void initState() {
    super.initState();
    _docsFuture = FlutterArtistDocSystem.instance.faDocuments;
  }

  @override
  Widget build(BuildContext context) {
    final Size preferContentSize = calculatePreferredDialogSize(
      context,
      preferredWidth: 500,
      preferredHeight: 300,
    );

    return FaDialog(
      iconData: Icons.menu_book_rounded,
      titleText: widget.title,
      contentPadding: const EdgeInsets.all(12),
      preferredContentWidth: preferContentSize.width,
      preferredContentHeight: preferContentSize.height,
      content: Column(
        children: [
          _buildControlBar(),
          const SizedBox(height: 12),
          Expanded(child: _buildDocumentList(context)),
        ],
      ),
    );
  }

  Widget _buildControlBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: context.faColors.bar.standard,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        children: [
          Icon(
            Icons.language_rounded,
            size: 14,
            color: context.faColors.ink.highlight,
          ),
          const SizedBox(width: 8),
          Text(
            "Select Language",
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: context.faColors.ink.highlight,
            ),
          ),
          const Spacer(),
          _buildLangFlag("en"),
          const SizedBox(width: 8),
          _buildLangFlag("vi"),
        ],
      ),
    );
  }

  Widget _buildLangFlag(String langCode) {
    bool isSelected = _selectedLangCode == langCode;
    return InkWell(
      onTap: () => setState(() => _selectedLangCode = langCode),
      child: Container(
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: isSelected
              ? context.faColors.action.fill.selected
              : Colors.transparent,
          borderRadius: BorderRadius.circular(4),
          border: isSelected
              ? Border.all(
                  color: context.faColors.action.stroke.primary,
                  width: 0.5,
                )
              : null,
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

        List<FaDocument> filteredDocs = [];
        if (snapshot.hasData) {
          filteredDocs = snapshot.data!.documents
              .where((doc) =>
                  doc.langCode == _selectedLangCode &&
                  widget.documentIds.contains(doc.id))
              .toList();
        }

        if (filteredDocs.isEmpty) {
          return Center(
            child: Text(
              "No English documentation available for this example.",
              style: TextStyle(
                color: context.faColors.ink.muted,
                fontSize: 12,
              ),
            ),
          );
        }

        return ListView.separated(
          itemCount: filteredDocs.length,
          separatorBuilder: (context, index) => const SizedBox(height: 8),
          itemBuilder: (context, index) {
            return DocLinkView(
              faDocument: filteredDocs[index],
              padding: const EdgeInsets.all(10),
              margin: EdgeInsets.all(0),
            );
          },
        );
      },
    );
  }
}
