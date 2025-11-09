import 'package:flutter/material.dart';
import 'package:handvibe/utility/text_font.dart';

class SettingsOption extends StatelessWidget {
  final String title;
  final Color textColor;
  final double fontSize;
  final Function() onTap;
  const SettingsOption({super.key, required this.title, required this.textColor, required this.fontSize, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      title: Text(
        title,
        style: TextFont().ralewayRegularMethod(
          fontSize,
          textColor,
          context,
        ),
      ),
      trailing: Icon(Icons.arrow_forward_ios, color: textColor,),
    );
  }
}
