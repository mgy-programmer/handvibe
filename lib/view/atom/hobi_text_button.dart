import 'package:flutter/material.dart';
import 'package:handvibe/utility/text_font.dart';

class HobiTextButton extends StatelessWidget {
  final String text;
  final Function() onTap;
  final Color textColor;
  final double textFont;
  const HobiTextButton({super.key, required this.text, required this.onTap, required this.textColor, required this.textFont});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onTap,
      child: Text(
        text,
        style: TextFont().ralewayRegularMethod(textFont, textColor, context),
      ),
    );
  }
}
