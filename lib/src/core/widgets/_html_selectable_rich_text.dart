import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

/// A widget that renders HTML-styled text using Flutter's RichText widget.
///
/// [HtmlSelectableRichText] allows you to display text with basic HTML-like styling
/// by defining custom styles for specific tags. It's a lightweight alternative
/// to full HTML rendering widgets.
///
/// Example:
/// ```dart
/// HtmlSelectableRichText(
///   '<b>Bold text</b> and <i>italic text</i>',
///   tagStyles: {
///     'b': TextStyle(fontWeight: FontWeight.bold),
///     'i': TextStyle(fontStyle: FontStyle.italic),
///   },
/// )
/// ```
class HtmlSelectableRichText extends StatefulWidget {
  final Icon? icon;
  final String? label;
  final TextStyle? labelStyle;
  final String htmlText;
  final TextStyle? style;
  final Map<String, TextStyle> tagStyles;
  final void Function(String)? onLinkTap;
  final TextAlign textAlign;

  const HtmlSelectableRichText(
    this.htmlText, {
    super.key,
    this.icon,
    this.label,
    this.labelStyle,
    this.style,
    required this.tagStyles,
    this.onLinkTap,
    this.textAlign = TextAlign.start,
  });

  @override
  State<HtmlSelectableRichText> createState() => _HtmlSelectableRichTextState();
}

class _HtmlSelectableRichTextState extends State<HtmlSelectableRichText> {
  final List<TapGestureRecognizer> _recognizers = [];

  @override
  void dispose() {
    for (final r in _recognizers) {
      r.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SelectableText.rich(
      _parseHtml(widget.htmlText, context),
      textAlign: widget.textAlign,
    );
  }

  TextSpan _parseHtml(String html, BuildContext context) {
    final List<InlineSpan> spans = [];

    if (widget.icon != null) {
      spans.add(WidgetSpan(
          child: widget.icon!, alignment: PlaceholderAlignment.middle));
      spans.add(const WidgetSpan(child: SizedBox(width: 4)));
    }
    if (widget.label != null) {
      spans.add(TextSpan(
        text: widget.label!,
        style:
            widget.labelStyle ?? const TextStyle(fontWeight: FontWeight.bold),
      ));
      spans.add(const WidgetSpan(child: SizedBox(width: 4)));
    }

    final baseStyle = widget.style ??
        Theme.of(context).textTheme.bodyMedium ??
        const TextStyle();

    final tagRegex =
        RegExp(r'''<(/?)([a-zA-Z0-9]+)(?:\s+href=["']([^"']*)["'])?>''');

    int lastIndex = 0;
    List<TextStyle> styleStack = [baseStyle];
    List<String?> linkStack = [null];

    for (final Match match in tagRegex.allMatches(html)) {
      if (match.start > lastIndex) {
        final text = html.substring(lastIndex, match.start);
        spans.add(TextSpan(
          text: text,
          style: styleStack.last,
          recognizer: _createRecognizer(linkStack.last),
        ));
      }

      final bool isClosingTag = match.group(1) == '/';
      final String tagName = match.group(2)!.toLowerCase();
      final String? href = match.group(3);

      if (isClosingTag) {
        if (styleStack.length > 1) {
          styleStack.removeLast();
          linkStack.removeLast();
        }
      } else {
        TextStyle currentStyle = styleStack.last;

        if (tagName == 'a') {
          final aStyle = widget.tagStyles['a'] ??
              const TextStyle(
                  color: Colors.blue, decoration: TextDecoration.underline);
          styleStack.add(currentStyle.merge(aStyle));
          linkStack.add(href);
        } else if (widget.tagStyles.containsKey(tagName)) {
          styleStack.add(currentStyle.merge(widget.tagStyles[tagName]));
          linkStack.add(linkStack.last);
        } else {
          styleStack.add(currentStyle);
          linkStack.add(linkStack.last);
        }
      }
      lastIndex = match.end;
    }

    if (lastIndex < html.length) {
      spans.add(TextSpan(
        text: html.substring(lastIndex),
        style: styleStack.last,
        recognizer: _createRecognizer(linkStack.last),
      ));
    }

    return TextSpan(children: spans);
  }

  TapGestureRecognizer? _createRecognizer(String? url) {
    if (url == null || widget.onLinkTap == null) return null;
    final recognizer = TapGestureRecognizer()
      ..onTap = () => widget.onLinkTap!(url);
    _recognizers.add(recognizer);
    return recognizer;
  }
}
