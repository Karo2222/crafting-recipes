import 'package:craftingrecipes/languages/languages.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

final RegExp _webLinkPattern = RegExp(
  r'(?:https?://|www\.)[^\s<>]+',
  caseSensitive: false,
);
const String _webLinkTrailingPunctuation = '.,;:!?)]}';

List<String> detectWebLinks(String text) {
  return _webLinkPattern.allMatches(text).map((match) {
    final end = _trimmedLinkEnd(text, match.start, match.end);
    return text.substring(match.start, end);
  }).toList();
}

int _trimmedLinkEnd(String text, int start, int end) {
  var trimmedEnd = end;
  while (trimmedEnd > start &&
      _webLinkTrailingPunctuation.contains(text[trimmedEnd - 1])) {
    trimmedEnd--;
  }
  return trimmedEnd;
}

class LinkifiedText extends StatefulWidget {
  const LinkifiedText(
    this.text, {
    super.key,
    this.style,
  });

  final String text;
  final TextStyle? style;

  @override
  State<LinkifiedText> createState() => _LinkifiedTextState();
}

class _LinkifiedTextState extends State<LinkifiedText> {
  final List<TapGestureRecognizer> _recognizers = [];
  late List<_TextPart> _parts;

  @override
  void initState() {
    super.initState();
    _parseText();
  }

  @override
  void didUpdateWidget(covariant LinkifiedText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.text != widget.text) {
      _disposeRecognizers();
      _parseText();
    }
  }

  void _parseText() {
    final parts = <_TextPart>[];
    var cursor = 0;
    for (final match in _webLinkPattern.allMatches(widget.text)) {
      final linkEnd = _trimmedLinkEnd(
        widget.text,
        match.start,
        match.end,
      );
      if (match.start > cursor) {
        parts.add(_TextPart(widget.text.substring(cursor, match.start)));
      }
      if (linkEnd > match.start) {
        final label = widget.text.substring(match.start, linkEnd);
        final recognizer = TapGestureRecognizer()..onTap = () => _open(label);
        _recognizers.add(recognizer);
        parts.add(_TextPart(label, recognizer: recognizer));
      }
      if (linkEnd < match.end) {
        parts.add(_TextPart(widget.text.substring(linkEnd, match.end)));
      }
      cursor = match.end;
    }
    if (cursor < widget.text.length) {
      parts.add(_TextPart(widget.text.substring(cursor)));
    }
    _parts = parts;
  }

  Future<void> _open(String value) async {
    final normalized =
        value.toLowerCase().startsWith('www.') ? 'https://$value' : value;
    final uri = Uri.tryParse(normalized);
    var opened = false;
    if (uri != null && (uri.scheme == 'http' || uri.scheme == 'https')) {
      try {
        opened = await launchUrl(uri, webOnlyWindowName: '_blank');
      } catch (_) {
        opened = false;
      }
    }
    if (opened || !mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(Languages.of(context)!.couldNotOpenLink)),
    );
  }

  void _disposeRecognizers() {
    for (final recognizer in _recognizers) {
      recognizer.dispose();
    }
    _recognizers.clear();
  }

  @override
  void dispose() {
    _disposeRecognizers();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final linkStyle = TextStyle(
      color: Theme.of(context).colorScheme.primary,
      decoration: TextDecoration.underline,
      decorationColor: Theme.of(context).colorScheme.primary,
    );
    return SelectableText.rich(
      TextSpan(
        style: widget.style ?? Theme.of(context).textTheme.bodyLarge,
        children: _parts
            .map(
              (part) => TextSpan(
                text: part.text,
                style: part.recognizer == null ? null : linkStyle,
                recognizer: part.recognizer,
              ),
            )
            .toList(),
      ),
    );
  }
}

class _TextPart {
  const _TextPart(this.text, {this.recognizer});

  final String text;
  final TapGestureRecognizer? recognizer;
}
