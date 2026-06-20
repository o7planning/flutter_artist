import 'package:flutter/material.dart';
import 'package:flutter_artist_commons_ui/flutter_artist_commons_ui.dart';
import 'package:flutter_artist_doc/flutter_artist_doc.dart';
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
  late Future<FaDocSystem> _docSystemFuture;

  @override
  void initState() {
    super.initState();
    _docSystemFuture = FlutterArtistDocSystem.instance.faDocSystem;
  }

  @override
  Widget build(BuildContext context) {
    return FaDialog(
      iconData: Icons.menu_book_rounded,
      titleText: widget.title,
      contentPadding: const EdgeInsets.all(12),
      preferredContentWidth: 500,
      preferredContentHeight: 300,
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
              ? context.faColors.action.fill.primary.selected
              : context.faColors.action.fill.primary,
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
    return FutureBuilder<FaDocSystem>(
      future: _docSystemFuture,
      builder: (context, snapshot) {
        // 1. Handling Asynchronous Loading State
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator(strokeWidth: 2));
        }

        // 2. Handling High-Level Network/HTTP Exceptions
        if (snapshot.hasError) {
          return _buildErrorView(
            context,
            message: "Network Exception Raised",
            details: snapshot.error.toString(),
          );
        }

        // 3. Handling Business Domain/Parsing Logic Errors
        if (snapshot.hasData && snapshot.data!.isError) {
          return _buildErrorView(
            context,
            message: "Failed to compile Documentation Infrastructure",
            details: snapshot.data!.errorMessage,
          );
        }

        // 4. Filtering Valid Data Stream Matrix
        List<FaDoc> filteredDocs = [];
        if (snapshot.hasData && snapshot.data!.ready) {
          filteredDocs = snapshot.data!.allDocs
              .where((doc) =>
                  doc.langCode == _selectedLangCode &&
                  widget.documentIds.contains(doc.id))
              .toList();
        }

        // 5. Handling Empty Collection Fallbacks Dynamically Based on Locale
        if (filteredDocs.isEmpty) {
          final String missingLangLabel =
              _selectedLangCode == 'vi' ? "Vietnamese" : "English";
          return Center(
            child: Text(
              "No $missingLangLabel documentation available for this example.",
              style: TextStyle(
                color: context.faColors.ink.tertiaryQuiet,
                fontSize: 12,
              ),
            ),
          );
        }

        // 6. Rendering Document Feed View Link Cards
        return ListView.separated(
          itemCount: filteredDocs.length,
          separatorBuilder: (context, index) => const SizedBox(height: 8),
          itemBuilder: (context, index) {
            return DocLinkView(
              faDoc: filteredDocs[index],
              padding: const EdgeInsets.all(10),
              margin: EdgeInsets.all(0),
            );
          },
        );
      },
    );
  }

  /// Compiles a responsive, standardized diagnostic error card layout.
  Widget _buildErrorView(
    BuildContext context, {
    required String message,
    required String? details,
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline_rounded,
              color: context.faColors.ink.error,
              size: 28,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: context.faColors.ink.primary,
              ),
            ),
            if (details != null && details.trim().isNotEmpty) ...[
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.all(8),
                constraints: BoxConstraints(
                  maxHeight: 100,
                ),
                width: double.maxFinite,
                decoration: BoxDecoration(
                  color: context.faColors.surface.emphasized,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: SingleChildScrollView(
                  child: Text(
                    details,
                    style: TextStyle(
                      fontFamily: 'Courier',
                      fontSize: 11,
                      color: context.faColors.ink.secondary,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
