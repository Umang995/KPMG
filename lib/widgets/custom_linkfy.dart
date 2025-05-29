import 'package:dreamcast/core/extension/content_extension.dart';
import 'package:dreamcast/widgets/textview/customTextView.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:linkify/linkify.dart';

typedef LinkCallback = void Function(LinkableElement link);

class ReadMoreLinkify extends StatefulWidget {
  final String text;
  final List<Linkifier> linkifiers;
  final LinkCallback? onOpen;
  final LinkifyOptions options;

  // TextSpan
  final TextStyle? style;
  final TextStyle? linkStyle;

  // RichText
  final TextAlign textAlign;
  final TextDirection? textDirection;
  final int maxLines;
  final TextOverflow overflow;
  final double textScaleFactor;
  final bool softWrap;
  final StrutStyle? strutStyle;
  final Locale? locale;
  final TextWidthBasis textWidthBasis;
  final TextHeightBehavior? textHeightBehavior;
  final bool useMouseRegion;

  const ReadMoreLinkify({
    Key? key,
    required this.text,
    this.linkifiers = defaultLinkifiers,
    this.onOpen,
    this.options = const LinkifyOptions(),
    this.style,
    this.linkStyle,
    this.textAlign = TextAlign.start,
    this.textDirection,
    this.maxLines = 3,
    this.overflow = TextOverflow.clip,
    this.textScaleFactor = 1.0,
    this.softWrap = true,
    this.strutStyle,
    this.locale,
    this.textWidthBasis = TextWidthBasis.parent,
    this.textHeightBehavior,
    this.useMouseRegion = true,
  }) : super(key: key);

  @override
  _ReadMoreLinkifyState createState() => _ReadMoreLinkifyState();
}

class _ReadMoreLinkifyState extends State<ReadMoreLinkify> {
  bool isExpanded = false;

  void toggleReadMore() {
    setState(() {
      isExpanded = !isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    bool moreThenLines = isMoreThanFourLines(
        widget.text.trim(),
        widget.style ?? const TextStyle(fontSize: 14),
        widget.maxLines,
        context.width);

    final elements = linkify(
      widget.text.trim(),
      options: widget.options,
      linkifiers: widget.linkifiers,
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(
          buildTextSpan(
            elements,
            style: widget.style ?? Theme.of(context).textTheme.bodyMedium,
            onOpen: widget.onOpen,
            useMouseRegion: widget.useMouseRegion,
            linkStyle: (widget.style ?? Theme.of(context).textTheme.bodyMedium)
                ?.copyWith(
                  color: Colors.blueAccent,
                  decoration: TextDecoration.underline,
                )
                .merge(widget.linkStyle),
          ),
          textAlign: widget.textAlign,
          textDirection: widget.textDirection,
          maxLines: isExpanded ? null : widget.maxLines,
          overflow: isExpanded ? TextOverflow.visible : widget.overflow,
          textScaleFactor: widget.textScaleFactor,
          softWrap: widget.softWrap,
          strutStyle: widget.strutStyle,
          locale: widget.locale,
          textWidthBasis: widget.textWidthBasis,
          textHeightBehavior: widget.textHeightBehavior,

        ),
        moreThenLines == true
            ? GestureDetector(
                onTap: toggleReadMore,
                child: Padding(
                  padding: const EdgeInsets.only(top: 0.0),
                  child: CustomTextView(text:
                    isExpanded ? 'Read Less' : 'Read More',
                    fontWeight: FontWeight.w500,color: Colors.blueAccent,fontSize: 15,
                  ),
                ),
              )
            : const SizedBox(),
      ],
    );
  }

  bool isMoreThanFourLines(
      String text, TextStyle style, int maxLines, double maxWidth) {
    final textSpan = TextSpan(text: text, style: style);
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
      maxLines: maxLines,
    )..layout(maxWidth: maxWidth);

    // Compare the height of the rendered text with the allowed height for maxLines.
    return textPainter.height > style.fontSize! * maxLines;
  }
}

/// Helper function to build the TextSpan with link elements
TextSpan buildTextSpan(
  List<LinkifyElement> elements, {
  TextStyle? style,
  TextStyle? linkStyle,
  LinkCallback? onOpen,
  bool useMouseRegion = false,
}) {
  return TextSpan(
    children: elements.map((element) {
      if (element is LinkableElement) {
        return TextSpan(
          text: element.text,
          style: linkStyle,
          recognizer: onOpen != null
              ? (TapGestureRecognizer()..onTap = () => onOpen(element))
              : null,
        );
      } else {
        return TextSpan(
          text: element.text,
          style: style,
        );
      }
    }).toList(),
  );
}
