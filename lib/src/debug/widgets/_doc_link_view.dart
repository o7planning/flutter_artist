import 'package:flutter/material.dart';
import 'package:flutter_artist_commons_ui/flutter_artist_commons_ui.dart';
import 'package:flutter_artist_core/flutter_artist_core.dart';

import '../../_wcfg.dart';
import '../../core/utils/_url_utils.dart';
import '../../core/widgets/_simple_copy_button.dart';
import '../../core/widgets/_simple_open_url_button.dart';

class DocLinkView extends StatelessWidget {
  final FaDocument faDocument;
  final EdgeInsets padding;
  final EdgeInsets margin;

  const DocLinkView({
    super.key,
    required this.faDocument,
    required this.padding,
    required this.margin,
  });

  @override
  Widget build(BuildContext context) {
    final String draftUrl = DevUtils.getDraftUrl(faDocument);

    return Container(
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        color: FaColorUtils.primaryContent(context).withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
            color: FaColorUtils.dividerColor(context).withValues(alpha: 0.5)),
      ),
      child: Row(
        children: [
          FlagCdnView.flagHeight(
            langCode: faDocument.langCode,
            height: 14,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              faDocument.title,
              style: TextStyle(
                  fontSize: 13,
                  color: faDocument.published && demoRelease
                      ? FaColorUtils.primaryAction(context)
                      : FaColorUtils.disabledContent(context),
                  decoration: faDocument.published
                      ? TextDecoration.underline
                      : TextDecoration.none),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 4),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.edit_note, size: 18),
                tooltip: "Open Draft URL",
                onPressed: () => UrlUtils.tryOpen(url: draftUrl),
                color: FaColorUtils.alertWarning(context),
                constraints: const BoxConstraints(),
                padding: const EdgeInsets.symmetric(horizontal: 4),
              ),
              if (faDocument.published && demoRelease)
                SimpleOpenUrlButton(
                  iconSize: 16,
                  url: faDocument.url,
                ),
              SimpleCopyButton(
                iconSize: 16,
                getText: () => faDocument.published && demoRelease
                    ? faDocument.url
                    : draftUrl,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
