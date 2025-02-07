import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:extended_text_field/extended_text_field.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';

class InvitationTextField extends StatelessWidget {
  final TextEditingController controller;
  final Function(String) onChange;
  final Function(String) onDeleteEmail;
  final String currentText;
  final Set<String> selectedEmails;

  const InvitationTextField({
    super.key,
    required this.controller,
    required this.currentText,
    required this.onDeleteEmail,
    required this.onChange,
    required this.selectedEmails,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: Colors.black,
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(30),
        ),
        child: MultiHitStack(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                top: 4,
                left: 4,
              ),
              child: Image.asset(
                'assets/groups/magnifying_glass_icon.png',
                height: 20,
                width: 20,
              ),
            ),
            ExtendedTextField(
              controller: controller,
              onChanged: onChange,
              specialTextSpanBuilder: EmailInvitesSpanBuilder(
                selectedEmails: selectedEmails,
                controller: controller,
                onDeleteEmail: onDeleteEmail,
              ),
              maxLines: 1,
              cursorColor: Colors.black,
              keyboardType: TextInputType.emailAddress,
              style: GoogleFonts.jost(color: Colors.black, fontSize: 12),
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.only(
                  left: 30,
                  top: 5,
                  right: 16,
                  bottom: 5,
                ),
                isDense: true,
                border: InputBorder.none,
                hintText: 'search emails here',
                hintStyle:
                    GoogleFonts.jost(color: Colors.white54, fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EmailInvitesSpanBuilder extends SpecialTextSpanBuilder {
  final Set<String> selectedEmails;
  final TextEditingController controller;
  final Function(String) onDeleteEmail;

  EmailInvitesSpanBuilder({
    required this.selectedEmails,
    required this.onDeleteEmail,
    required this.controller,
  });

  @override
  TextSpan build(String data,
      {TextStyle? textStyle, SpecialTextGestureTapCallback? onTap}) {
    if (data.isEmpty) return TextSpan(text: '', style: textStyle);

    final words = data.split(' ');
    final List<InlineSpan> spans = [];
    var currentPosition = 0;

    final Set<String> processedEmails = {};

    for (var i = 0; i < words.length; i++) {
      final word = words[i];

      if (i > 0) {
        spans.add(TextSpan(text: ' ', style: textStyle));
        currentPosition += 1;
      }

      if (selectedEmails.contains(word) && !processedEmails.contains(word)) {
        processedEmails.add(word);
        spans.add(
          ExtendedWidgetSpan(
            actualText: word,
            start: currentPosition,
            deleteAll: true,
            alignment: PlaceholderAlignment.middle,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(4.0),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 6.0),
                      child: Text(
                        word,
                        style: textStyle?.copyWith(color: Colors.black87),
                      ),
                    ),
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () => onDeleteEmail(word),
                        child: const Padding(
                          padding: EdgeInsets.all(4.0),
                          child: Icon(
                            Icons.close,
                            size: 14.0,
                            color: Colors.black54,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      } else if (selectedEmails.contains(word)) {
        spans.add(TextSpan(text: '', style: textStyle));
      } else {
        spans.add(TextSpan(text: word, style: textStyle));
      }

      currentPosition += word.length;
    }

    return TextSpan(children: spans);
  }

  @override
  SpecialText? createSpecialText(String flag,
      {TextStyle? textStyle,
      SpecialTextGestureTapCallback? onTap,
      required int index}) {
    return null;
  }
}
