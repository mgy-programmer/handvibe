import 'package:flutter/material.dart';
import 'package:handvibe/utility/screen_size_util.dart';
import 'package:handvibe/utility/text_font.dart';

class HobiText extends StatelessWidget {
  final String text;
  final double width;
  final Color textColor;
  final double textFont;
  const HobiText({super.key, required this.text, this.width = 200, this.textColor = Colors.black, this.textFont = 16});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: ScreenSizeUtil().getCalculateWith(context, width),
      margin: EdgeInsets.only(
        top: ScreenSizeUtil().getCalculateHeight(context, 10),
        bottom: ScreenSizeUtil().getCalculateHeight(context, 2),
      ),
      child: Text(
        text,
        style: TextFont().ralewayRegularMethod(
          textFont,
          textColor,
          context,
          fontWeight: FontWeight.w500,
        ),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
